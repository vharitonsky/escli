import 'package:escli/util.dart' as util;

void remove(String name) async {
  final settings = await util.getSettings();
  final List<dynamic> clusters = settings.putIfAbsent('clusters', () => []);
  for(final cluster in clusters) {
    if(cluster['name'] == name) {
      clusters.remove(cluster);
      util.setSettings(settings);
      return;
    }
  }
}