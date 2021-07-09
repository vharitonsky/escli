import 'package:escli/util.dart' as util;

void add(String name, host) async {
  final settings = await util.getSettings();
  final List<dynamic> clusters = settings.putIfAbsent('clusters', () => []);
  for (final cluster in clusters) {
    if (cluster['name'] == name) {
      cluster['host'] = host;
      util.setSettings(settings);
      return;
    }
  }
  clusters.add({'name': name, 'host': host});
  util.setSettings(settings);
}
