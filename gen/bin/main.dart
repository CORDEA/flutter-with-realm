import 'package:analyzer/analyzer.dart';
import 'package:args/args.dart';

void main(List<String> args) {
  var parser = new ArgParser()..addFlag('full', defaultsTo: false, abbr: 'f');
  var result = parser.parse(args);

  if (result.rest.length == 0) {
    return;
  }
  var filename = result.rest[0];

  CompilationUnit unit = parseDartFile(filename);
  NodeList<Declaration> nodes = unit.declarations;
  var map = {};
  var node = nodes[0];
  if (!(node is ClassDeclaration)) {
    return;
  }
  var name = node.name.name;
  node.members.forEach((f) {
    if (f is FieldDeclaration) {
      var type = f.fields.type.name.name;
      f.fields.variables.forEach((n) {
        map[n] = type;
      });
    }
  });

  print('--- Kotlin ---\n');
  generateKotlinCode(name, map, result['full']);

  print('\n--- Objective-C Header ---\n');
  generateObjCCode(name, map, result['full']);

  if (result['full']) {
    print('\n--- Objective-C ---\n');
    generateObjCImplCode(name);
  }
}

const String kotlinIndent = '    ';

void generateKotlinCode(String className, Map map, bool isFullOutput) {
  if (isFullOutput) {
    print('import io.realm.RealmObject\n');
    print('open class ${className} : RealmObject() {\n');
  }
  map.forEach((key, value) {
    switch (value) {
      case 'String':
        print('${kotlinIndent}open var ${key}: ${value}? = null\n');
        break;
      case 'int':
        print('${kotlinIndent}open var ${key}: Int = 0\n');
        break;
      case 'double':
        print('${kotlinIndent}open var ${key}: Double = 0.0\n');
        break;
    }
  });
  if (isFullOutput) {
    print('}');
  }
}

void generateObjCCode(String className, Map map, bool isFullOutput) {
  if (isFullOutput) {
    print('#import <Realm/Realm.h>\n');
    print('@interface ${className} : RLMObject\n');
  }
  map.forEach((key, value) {
    switch (value) {
      case 'String':
        print('@property (nonatomic, strong) NSString *${key};\n');
        break;
      case 'int':
        print('@property (nonatomic, assign) int ${key};\n');
        break;
      case 'double':
        print('@property (nonatomic, assign) double ${key};\n');
    }
  });
  if (isFullOutput) {
    print('@end');
  }
}

void generateObjCImplCode(String className) {
  print('#import "${className}.h"\n');
  print('@implementation ${className}\n');
  print('@end');
}
