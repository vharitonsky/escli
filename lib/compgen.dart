import 'package:escli/util.dart' as util;
import 'package:escli/es.dart' as es;

const COMMANDS = [
  'clusters',
  'add',
  'remove',
  'health',
  'stats',
  'nodes',
  'settings',
  'set',
  'index',
  'indices',
  'shards',
  'templates',
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
    final host = await util.getSelectedClusterHost();
    if (host == null){
      return '';
    }
    final names = await es.getIndexNames(host);
    if(arguments.length > 2 && arguments[2] != null) {
      return names.where((element) => element.startsWith(arguments[2])).toList().join(' ');
    }
    return names.join(' ');
  }
  if (arguments[0] == 'templates') {
    final host = await util.getSelectedClusterHost();
    if (host == null){
      return '';
    }
    final names = await es.getTemplateNames(host);
    if(arguments.length > 2 && arguments[2] != null) {
      return names.where((element) => element.startsWith(arguments[2])).toList().join(' ');
    }
    return names.join(' ');
  }
  if (arguments[0] == 'nodes') {
    final host = await util.getSelectedClusterHost();
    if (host == null){
      return '';
    }
    final names = await es.getNodeNames(host);
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