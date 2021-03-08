import 'package:escli/util.dart' as util;

void clusters() async {
  final settings = await util.getSettings();
  for (final cluster in settings['clusters'] ?? []) {
    print("${cluster['selected'] ?? false ? '*': ''} ${cluster['name']} ${cluster['host']}");
  }
}