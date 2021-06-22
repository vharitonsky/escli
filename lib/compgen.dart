import 'package:escli/util.dart' as util;
import 'package:escli/es.dart' as es;

import 'package:escli/indices.dart' as indices;

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
  'select',
  'shards',
  'templates',
];

class SubCommands{
  static var index = [
    'open', 'close', 'create', 'delete',
    'reroute', 'settings', 'analysis', 'mappings',
    'search'
  ];
}

Future<String> compgen(List<String> arguments) async {
  // drop -- generated in compgen call
  arguments = arguments.where((element) => element != '--').toList();

  // first command is select, next must be cluster name from config
  if (arguments[0] == 'select') {
    final names = await util.getClusterNames();
    if(arguments.length == 2) {
      return names.where((element) => element.startsWith(arguments[1])).toList().join(' ');
    }
    return names.join(' ');
  }
  if (arguments[0] == 'indices') {
    final host = await util.getSelectedClusterHost();
    if (host == null){
      return '';
    }
    final names = await es.getIndexNames(host);
    if(arguments.length == 2) {
      return names.where((element) => element.startsWith(arguments[1])).toList().join(' ');
    }
    return names.join(' ');
  }
  if (arguments[0] == 'templates') {
    final host = await util.getSelectedClusterHost();
    if (host == null){
      return '';
    }
    final names = await es.getTemplateNames(host);
    if(arguments.length == 2) {
      return names.where((element) => element.startsWith(arguments[1])).toList().join(' ');
    }
    return names.join(' ');
  }
  if (arguments[0] == 'nodes') {
    final host = await util.getSelectedClusterHost();
    if (host == null){
      return '';
    }
    final names = await es.getNodeNames(host);
    if(arguments.length == 2) {
      return names.where((element) => element.startsWith(arguments[1])).toList().join(' ');
    }
    return names.join(' ');
  }
  // index has subcommands, like that: escli index create <index>
  if (arguments[0] == 'index') {
    // escli index cre
    if (arguments.length == 2) {
      if (SubCommands.index.contains(arguments[1])) {
        final baseHost = await util.getSelectedClusterHost() ?? '';
        if (baseHost != '') {
          return (await indices.getIndices(baseHost))
              .map((e) => e.name)
              .toList()
              .join(' ');
        }
      } else {
        var found = SubCommands.index.where((element) =>
            element.startsWith(arguments[1])).toList();
        if (found.isNotEmpty) return found.join(' ');
      }
      // escli index create inde
    } else if (arguments.length == 3) {
        final baseHost = await util.getSelectedClusterHost() ?? '';
        if (baseHost != '') {
          var allIndices = (await indices.getIndices(baseHost)).map((e) =>
          e.name).toList();
          return allIndices.where((element) => element.startsWith(arguments[2]))
              .toList()
              .join(' ');
        }
        // escli index
      } else {
        return SubCommands.index.join(' ');
      }
  }
  // escli ind
  if(arguments.length == 1) {
    return COMMANDS.where((element) =>
        element.startsWith(arguments[0])).join(' ');
  }
  return COMMANDS.join(' ');
}