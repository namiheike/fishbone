import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:barback/barback.dart';
import 'package:path/path.dart' as path;

class CompileTemplates extends AggregateTransformer {
  final BarbackSettings _settings;

  CompileTemplates.asPlugin(this._settings);

  classifyPrimary(AssetId id) {
    if (!id.path.startsWith('web/scripts/views/')) return null;
    if (!id.path.endsWith('.js')) return null;

    return path.url.dirname(id.path);
  }

  Future apply(AggregateTransform transform) {
    // TODO FEATURE couldnot modify files directly in transformers
    // waiting for the fixed jaded lib in dart
    // current walkthrough is, run `jade -c -D web/scripts/views` manually before `pub build`
    // compile .jade to .js via jade
    // Process.runSync('jade', ['-c', '-D', 'web/scripts/views']);

    var buffer = new StringBuffer();
    buffer.writeln('if (Fishbone == undefined){var Fishbone = {}}');
    buffer.writeln('Fishbone.views = {};');

    return transform.primaryInputs.toList().then((assets) {
      assets.sort((x, y) => x.id.compareTo(y.id));
      return Future.wait(assets.map((asset) {
        return asset.readAsString().then((content) {
          // predefine undefined objects
          var pathComponents = path.split(asset.id.path.replaceFirst('web/scripts/views/', '').replaceFirst('.js',''));
          predefineObject(buffer, pathComponents);

          buffer.write("${objectPath(pathComponents)} = ");
          buffer.writeln(content);

          // delete compiled .js file
          // var compiledJs = new File(asset.id.path);
          // compiledJs.deleteSync();
        });
      }));
    }).then((_){
      var id = new AssetId(transform.package, 'web/scripts/views/manifest.js');
      transform.addOutput(new Asset.fromString(id, buffer.toString()));
    });
  }

  void predefineObject(StringBuffer buffer, List components){
    String tmpBuffer = '';
    for (var i = 0; i < components.length; i++ ) {
      String objToDefine = objectPath(components.take(i+1));
      tmpBuffer += "if ($objToDefine == undefined) { $objToDefine = {} }\n";
    }
    buffer.writeln(tmpBuffer);
  }

  String objectPath(List components){
    return('Fishbone.views.' + components.join('.'));
  }
}
