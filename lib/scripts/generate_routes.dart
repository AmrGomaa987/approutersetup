import 'dart:io';

void main() {
  print('Flutter Route Generator');
  print('=======================');

  final projectRoot = getProjectRoot();
  final screensDir = getScreensDirectory(projectRoot);
  final outputDir = getOutputDirectory(projectRoot);

  final routes = generateRoutes(screensDir);
  final imports = generateImports(screensDir, projectRoot);

  writeRoutesFile(outputDir, routes);
  writeRouterFile(outputDir, routes, imports);

  print('\nRoute generation completed successfully!');
  print('Add the generated files to your pubspec.yaml and update your main.dart to use the new routes.');
}

Directory getProjectRoot() {
  var current = Directory.current;
  while (current.path != current.parent.path) {
    if (File('${current.path}/pubspec.yaml').existsSync()) {
      return current;
    }
    current = current.parent;
  }
  throw Exception('Could not find project root (pubspec.yaml not found in any parent directory)');
}

Directory getScreensDirectory(Directory projectRoot) {
  print('\nEnter the relative path to your screens directory (default: lib/screens):');
  final input = stdin.readLineSync() ?? '';
  final path = input.isEmpty ? 'lib/screens' : input;
  final dir = Directory('${projectRoot.path}/$path');
  if (!dir.existsSync()) {
    print('Directory does not exist. Creating it now...');
    dir.createSync(recursive: true);
  }
  return dir;
}

Directory getOutputDirectory(Directory projectRoot) {
  print('\nEnter the relative path for output files (default: lib/routes):');
  final input = stdin.readLineSync() ?? '';
  final path = input.isEmpty ? 'lib/routes' : input;
  final dir = Directory('${projectRoot.path}/$path');
  if (!dir.existsSync()) {
    print('Directory does not exist. Creating it now...');
    dir.createSync(recursive: true);
  }
  return dir;
}

List<Map<String, dynamic>> generateRoutes(Directory dir) {
  final routes = <Map<String, dynamic>>[];

  void processDirectory(Directory directory, String currentPath) {
    for (var entity in directory.listSync()) {
      if (entity is Directory) {
        processDirectory(entity, '$currentPath/${entity.path.split(Platform.pathSeparator).last}');
      } else if (entity is File && entity.path.endsWith('_page.dart')) {
        final fileName = entity.path.split(Platform.pathSeparator).last;
        final routeName = fileName.replaceAll('_page.dart', '').toUpperCase();
        final className = fileName.split('_').map((e) => e.capitalize()).join('').replaceAll('.dart', '');
        final routePath = currentPath.isEmpty ? '/$routeName' : '$currentPath/$routeName'.toLowerCase();
        
        routes.add({
          'name': routeName,
          'path': routePath,
          'className': className,
          'fileName': fileName,
        });
      }
    }
  }

  processDirectory(dir, '');
  return routes;
}

List<String> generateImports(Directory screensDir, Directory projectRoot) {
  final imports = <String>[];
  final relativeScreensPath = screensDir.path.replaceFirst(projectRoot.path, '').replaceAll('\\', '/');

  void processDirectory(Directory directory) {
    for (var entity in directory.listSync()) {
      if (entity is Directory) {
        processDirectory(entity);
      } else if (entity is File && entity.path.endsWith('_page.dart')) {
        final relativePath = entity.path.replaceFirst(screensDir.path, '').replaceAll('\\', '/');
        final importPath = "import 'package:${projectRoot.path.split(Platform.pathSeparator).last}$relativeScreensPath$relativePath';";
        imports.add(importPath);
      }
    }
  }

  processDirectory(screensDir);
  return imports;
}

void writeRoutesFile(Directory outputDir, List<Map<String, dynamic>> routes) {
  final routesFile = File('${outputDir.path}/app_routes.dart');
  final buffer = StringBuffer();

  buffer.writeln('// Generated code - do not modify by hand\n');
  buffer.writeln('class AppRoutes {');

  for (var route in routes) {
    final constName = route['name'];
    buffer.writeln("  static const String $constName = '${route['path']}';");
  }

  buffer.writeln('}');
  routesFile.writeAsStringSync(buffer.toString());
  print('Routes file generated: ${routesFile.path}');
}

void writeRouterFile(Directory outputDir, List<Map<String, dynamic>> routes, List<String> imports) {
  final routerFile = File('${outputDir.path}/app_router.dart');
  final buffer = StringBuffer();

  buffer.writeln('// Generated code - do not modify by hand\n');
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'app_routes.dart';");
  for (var import in imports) {
    buffer.writeln(import);
  }

  buffer.writeln('\nclass AppRouter {');
  buffer.writeln('  static Route<dynamic> onGenerateRoute(RouteSettings settings) {');
  buffer.writeln('    switch (settings.name) {');

  for (var route in routes) {
    buffer.writeln("      case AppRoutes.${route['name']}:");
    buffer.writeln('        return MaterialPageRoute(');
    buffer.writeln('          builder: (_) => ${route['className']}(),');
    buffer.writeln('        );');
  }

  buffer.writeln('      default:');
  buffer.writeln('        return MaterialPageRoute(');
  buffer.writeln('          builder: (_) => Scaffold(');
  buffer.writeln("            appBar: AppBar(title: Text('Not Found')),");
  buffer.writeln("            body: Center(child: Text('Page not found')),");
  buffer.writeln('          ),');
  buffer.writeln('        );');
  buffer.writeln('    }');
  buffer.writeln('  }');
  buffer.writeln('}');

  routerFile.writeAsStringSync(buffer.toString());
  print('Router file generated: ${routerFile.path}');
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}