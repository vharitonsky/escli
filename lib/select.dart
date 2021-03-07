import 'package:escli/util.dart' as util;

void select(String name) async {
  final settings = await util.getSettings();
  for(final cluster in settings['clusters'] ?? []) {
    if(cluster['name'] == name) {
      cluster['selected'] = true;
      for (final cluster in settings['clusters']) {
        if(cluster['name'] != name) {
          cluster['selected'] = false;
        }
      }
      util.setSettings(settings);
      return;
    }
  }
  print('No such cluster');
}