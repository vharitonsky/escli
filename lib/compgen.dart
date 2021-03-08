import 'package:escli/util.dart' as util;
import 'package:escli/es.dart' as es;

const COMMANDS = [
  'clusters',
  'add',
  'select',
  'health',
  'stats',
  'nodes',
  'settings',
  'indices',
  'shards',
];

Future<String> compgen(List<String> arguments) async {
  if (arguments[0] == 'select') {
    final names = await util.getClusterNames();
    if(arguments.length > 2 && arguments[2] != null) {
      return names.where((element) => element.startsWith(arguments[2])).toList().join(' ');
    }
    return names.join(' ');
  }
  if (arguments[0] == 'indices') {
    final names = await es.getIndexNames(await util.getSelectedClusterHost());
    if(arguments.length > 2 && arguments[2] != null) {
      return names.where((element) => element.startsWith(arguments[2])).toList().join(' ');
    }
    return names.join(' ');
  }
  if(arguments.length > 1 && arguments[1] != null) {
    return COMMANDS.where((element) =>
        element.startsWith(arguments[1])).join(' ');
  }
  return COMMANDS.join(' ');
}