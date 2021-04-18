/// Support for doing something awesome.
///
/// More dartdocs go here.
library remote_config_data_generator;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_config/built_config.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

class BuiltConfigGenerator extends Generator {
  final bool forClasses, forLibrary;

  const BuiltConfigGenerator({
    this.forClasses = true,
    this.forLibrary = false,
  });

  static bool isRemoteConfig(ClassElement classElement) {
    return !classElement.displayName.startsWith('_\$') &&
        classElement.allSupertypes.any(
          (interfaceType) {
            return interfaceType.element.name == '$BuiltConfig';
          },
        );
  }

  @override
  Future<String> generate(LibraryReader library, _) async {
    final output = <String>[];
    if (forLibrary) {
      var name = library.element.name;
      if (name?.isEmpty ?? false) {
        name = library.element.source.uri.pathSegments.last;
      }
      output.add('// Code for "$name"');
    }
    if (forClasses) {
      for (var classElement in library.allElements.whereType<ClassElement>()) {
        if (isRemoteConfig(classElement)) {
          final e = classElement.allSupertypes.firstWhere(
            (element) =>
                element.getDisplayString(withNullability: false) ==
                '$BuiltConfig',
            orElse: () => null,
          );
          for (final a in e.accessors) {
            output.add('// ' + a.displayName);
          }
          if (classElement.displayName.contains('GoodError')) {
            throw InvalidGenerationSourceError(
              "Don't use classes with the word 'Error' in the name",
              todo: 'Rename ${classElement.displayName} to something else.',
              element: classElement,
            );
          }
          output.add(_RemoteConfigBuilder(classElement).generateConfig());
        }
      }
    }
    return output.join('\n');
  }
}

// GENERATION UTILS

extension _InterfaceUtils on InterfaceType {
  bool get isRemoteConfig =>
      getDisplayString(withNullability: false) == '$BuiltConfig';
}

extension _ClassUtils on ClassElement {
  // checks for "factory Class()" constructor
  bool get hasDefaultFactoryConstructor =>
      constructors.firstWhere(
        (element) => element.isFactory && element?.displayName == '',
        orElse: () => null,
      ) !=
      null;

  // checks for "Class._()" constructos
  bool get hasDefaultPrivateConstructor =>
      constructors.firstWhere(
        (element) =>
            !element.isFactory &&
            element.isPrivate &&
            element.displayName == '_',
        orElse: () => null,
      ) !=
      null;

  InterfaceType get remoteConfigInterface => interfaces.firstWhere(
        (e) => e.isRemoteConfig,
        orElse: () => null,
      );
}

extension _ElementAnnotationUtils on ElementAnnotation {
  bool get isBuiltConfigFieldAnnotated {
    var displayString =
        computeConstantValue().type.getDisplayString(withNullability: false);
    return isConstantEvaluated && displayString == '$BuiltConfigField';
  }

  bool get isBuiltConfigOptionsAnnotated {
    var displayString =
        computeConstantValue().type.getDisplayString(withNullability: false);
    return isConstantEvaluated && displayString == '$BuiltConfigOptions';
  }
}

extension _PropertyAccessorElementUtils on PropertyAccessorElement {
  ElementAnnotation get BuiltConfigFieldAnnotation => metadata.firstWhere(
        (e) => e.isBuiltConfigFieldAnnotated,
        orElse: () => null,
      );
}

class _RemoteConfigBuilder {
  _RemoteConfigBuilder(this.classElement);

  final ClassElement classElement;
  final DartEmitter emitter = DartEmitter();
  final DartFormatter formatter = DartFormatter(lineEnding: '\n\n');

  String get rootClassName => classElement.displayName;

  String output = '';

  Class buildClass(ClassElement c) {
    final remoteConfigInterface = c.remoteConfigInterface;

    // ensure the class implements BuiltConfig
    if (remoteConfigInterface == null) {
      throw InvalidGenerationSourceError(
        '$rootClassName should implement $BuiltConfig',
        todo: 'Try to do \'$rootClassName implements $BuiltConfig\'',
        element: c,
      );
    }

    // ensure factory constructor
    if (!c.hasDefaultFactoryConstructor) {
      throw InvalidGenerationSourceError(
        'Make sure $rootClassName has a factory constructor\nAdd "factory $rootClassName() = _\$$rootClassName;"',
        todo: 'Add "factory $rootClassName() = _\$$rootClassName"',
        element: c,
      );
    }

    // ensure private constructor
    if (!c.hasDefaultPrivateConstructor) {
      throw InvalidGenerationSourceError(
        'Make sure $rootClassName has a private constructor\nAdd "$rootClassName._();"',
        todo: 'Add "$rootClassName._();"',
        element: c,
      );
    }

    // create class
    return Class((b) {
      b
        ..name = '_\$$rootClassName'
        ..extend = Reference('${classElement.displayName}')
        ..constructors = ListBuilder([
          Constructor((b) {
            b
              ..factory = true
              ..lambda = true
              ..body = Code('_\$$rootClassName._()');
          }),
          Constructor((b) {
            b
              ..factory = false
              ..name = '_'
              ..initializers = ListBuilder([Code('super._()')]);
          })
        ]);
    });
  }

  Method _buildMethod(
    PropertyAccessorElement accessor,
    Map<String, String> jsonBuilder,
    Map<String, dynamic> defaultJsonBuilder,
  ) {
    // if no annotation don't generate
    if (accessor.metadata.isEmpty) {
      return null;
    }

    final annotation = accessor.BuiltConfigFieldAnnotation;

    // if no annotation don't generate
    if (annotation == null) {
      return null;
    }

    // make sure is getter
    if (!accessor.isGetter) {
      throw InvalidGenerationSourceError(
        'Methods annotated with $BuiltConfigField should be getters',
        todo:
            'Try to do "${accessor.returnType.getDisplayString(withNullability: true)} get ${accessor.variable.name};"',
        element: accessor,
      );
    }

    // make sure is abstract
    if (!accessor.isAbstract) {
      throw InvalidGenerationSourceError(
        'Getters annotated with $BuiltConfigField should not have definition',
        todo: '',
        element: accessor,
      );
    }

    // get wireName
    final wireName =
        annotation.computeConstantValue().getField('wireName').toStringValue();

    // get default value
    final defaultValueObj =
        annotation.computeConstantValue().getField('defaultValue');

    // make sure default value type and return type are same
    if (defaultValueObj.type.getDisplayString(withNullability: false) !=
        accessor.returnType.getDisplayString(withNullability: false)) {
      throw InvalidGenerationSourceError(
        'The type of "defaultValue" in $BuiltConfigField is not same as the Return type of the getter',
        todo: '',
        element: accessor,
      );
    }

    // get default value
    var defaultValue = _getValueForDartType(defaultValueObj, accessor);

    // get all values
    final allValues = annotation
        .computeConstantValue()
        .getField('allValues')
        .toListValue()
        .map((e) {
      var valueForDartType = _getValueForDartType(e, accessor);
      // make sure default value type and list elements type are same
      if (valueForDartType.runtimeType != defaultValue.runtimeType) {
        throw InvalidGenerationSourceError(
          'The value $valueForDartType in the "allValues" is not as the same type of "defaultValue"'
          '\ndefaultValue is a ${defaultValue.runtimeType}, but $valueForDartType is ${valueForDartType.runtimeType}',
          todo: '',
          element: accessor,
        );
      }
      return valueForDartType;
    }).toList();

    // make sure default value is one of the all values
    if (allValues.isNotEmpty &&
        !allValues.contains(defaultValue) &&
        defaultValue != null) {
      throw InvalidGenerationSourceError(
        'The default value is not in accepted values',
        todo: '',
        element: accessor,
      );
    }

    var key = wireName ?? accessor.name;
    jsonBuilder[key] = accessor.name;
    var encodedDefaultValue =
        defaultValue is String ? '\'$defaultValue\'' : defaultValue;
    defaultJsonBuilder[key] = encodedDefaultValue;
    return Method((b) {
      b
        ..name = accessor.name
        ..type = MethodType.getter
        ..returns = Reference(
            defaultValueObj.type.getDisplayString(withNullability: false))
        ..annotations = ListBuilder([CodeExpression(Code('override'))])
        ..lambda = true
        ..body = Code(
          'get${defaultValue.runtimeType.toString().pascalCase}(${'\'$key\''}) ?? _defaultRemoteValues[\'$key\']',
        );
    });
  }

  dynamic _getValueForDartType(
    DartObject defaultValueObj,
    PropertyAccessorElement accessor,
  ) {
    var defaultValue;
    if (defaultValueObj.isNull) {
      defaultValue = null;
    } else if (defaultValueObj.type.isDartCoreString) {
      defaultValue = defaultValueObj.toStringValue();
    } else if (defaultValueObj.type.isDartCoreBool) {
      defaultValue = defaultValueObj.toBoolValue();
    } else if (defaultValueObj.type.isDartCoreInt) {
      defaultValue = defaultValueObj.toIntValue();
    } else if (defaultValueObj.type.isDartCoreDouble) {
      defaultValue = defaultValueObj.toDoubleValue();
    }
    // else if (defaultValueObj.type.isDartCoreList) {
    //   defaultValue = defaultValueObj.toListValue();
    // } else if (defaultValueObj.type.isDartCoreMap) {
    //   defaultValue = defaultValueObj.toMapValue();
    // }
    else {
      throw InvalidGenerationSourceError(
        'Unaccepted return value type ${defaultValueObj.type.getDisplayString(withNullability: true)}',
        todo: '',
        element: accessor,
      );
    }
    return defaultValue;
  }

  String generateConfig() {
    var _remoteClass = buildClass(classElement);

    // check if super type is remote configuration
    final e = classElement.supertype.element.remoteConfigInterface;

    final _jsonBuilder = <String, String>{};
    final _defaultValueJson = <String, dynamic>{};

    var _accessors = classElement.accessors?.map((e) => e.name)?.toSet();

    // get all accessors
    // if super type is remote configuration, copy its accessors;
    var allAccessors = [
      ...classElement.accessors,
      if (e != null)
        ...?(classElement.supertype.element?.accessors
            ?.where((element) => !_accessors.contains(element.name))),
    ];

    for (final accessor in allAccessors) {
      final m = _buildMethod(
        accessor,
        _jsonBuilder,
        _defaultValueJson,
      );
      if (m != null) {
        _remoteClass = _remoteClass.rebuild((b) => b..methods.add(m));
      }
    }

    _remoteClass = _remoteClass.rebuild((b) => b
      ..fields = ListBuilder([
        Field((b) {
          b
            ..modifier = FieldModifier.final$
            ..type = Reference('Map<String,dynamic>')
            ..name = '_defaultRemoteValues'
            ..assignment = Code(
                '''<String,dynamic>${_defaultValueJson.map((key, value) => MapEntry('\'$key\'', value))}''');
        }),
      ]));

    _remoteClass = _remoteClass.rebuild((b) => b
      ..methods.add(Method((b) {
        b
          ..returns = Reference('Map<String,dynamic>')
          ..name = 'toDefaultJson'
          ..lambda = true
          ..annotations = ListBuilder([CodeExpression(Code('override'))])
          ..body = Code('''_defaultRemoteValues''');
      })));

    _remoteClass = _remoteClass.rebuild((b) => b
      ..methods.add(Method((b) {
        b
          ..returns = Reference('Map<String,dynamic>')
          ..name = 'toJson'
          ..annotations = ListBuilder([CodeExpression(Code('override'))])
          ..body = Code(
              '''return <String,dynamic>${_jsonBuilder.map((key, value) => MapEntry('\'$key\'', value))};''');
      })));

    for (final a in classElement.metadata) {
      if (a.isBuiltConfigOptionsAnnotated) {
        final shouldOutputJson =
            a.computeConstantValue().getField('outputJson').toBoolValue();
        if (shouldOutputJson) {
          final jsonFileName =
              a.computeConstantValue().getField('jsonFileName').toStringValue();
          File('built_config/${jsonFileName ?? 'built_config'}.json')
            ..createSync(recursive: true)
            ..writeAsString(jsonEncode(_defaultValueJson));
        }
      }
    }

    return formatter
        .format(_remoteClass.accept(emitter).toString() + '\n/*\n$output\n*/');
  }
}
