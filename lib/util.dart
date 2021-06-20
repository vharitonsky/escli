import 'dart:convert' as convert;
import 'package:colorize/colorize.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class Cluster {
  final String host;
  final String name;
  final bool selected;

  Cluster({
    required this.host,
    required this.name,
    required this.selected,
  });

}

void pprintJson(String jsonData) {
  final encoder = convert.JsonEncoder.withIndent('  ');
  print(encoder.convert(convert.jsonDecode(jsonData)));
}

String getConfigPath() {
  final home = io.Platform.environment['HOME'] ?? io.Platform.environment['USERPROFILE'];
  assert(home != null);
  return path.join(home ?? '', '.escli.conf');
}

Future<Map<String, dynamic>> getSettings() async{
  final f = io.File(getConfigPath());
  if(f.existsSync()) {
    return convert.jsonDecode(await f.readAsString());
  } else {
    return {};
  }
}

Future<List<Cluster>> getClusters() async {
  final settings = await getSettings();
  var clusters = <Cluster>[];
  for (final cluster in settings['clusters'] ?? []) {
    clusters.add(Cluster(
      host: cluster['host'],
      name: cluster['name'],
      selected: cluster['selected'] ?? false,
    ));
  }
  return clusters;
}

Future<String?> getSelectedClusterHost() async {
  final settings = await getSettings();
  for (final cluster in settings['clusters'] ?? []) {
    if (cluster['selected']) {
      return cluster['host'];
    }
  }
  return null;
}

Future<List<String>> getClusterNames() async {
  final settings = await getSettings();
  List<dynamic> clusters = (settings['clusters'] ?? []);
  final names = clusters.map((e) => e['name'].toString()).toList();
  return names;
}

void writeArguments(List<String> arguments) async{
  final f = io.File('args').openWrite();
  f.write(arguments.join(' '));
  await f.close();
}


void setSettings(Map<String, dynamic> settings) async{
  final f = io.File(getConfigPath()).openWrite();
  f.write(convert.jsonEncode(settings));
  await f.close();
}

String colorizeHealth(String health) {
  var coloredHealth = Colorize(health);
  if(health == 'green') {
    return coloredHealth.green().toString();
  } else if (health == 'yellow') {
    return coloredHealth.yellow().toString();
  } else {
    return coloredHealth.red().toString();
  }
}