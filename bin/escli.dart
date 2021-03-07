import 'package:escli/shards.dart' as shards;
import 'package:escli/indices.dart' as indices;
import 'package:escli/health.dart' as health;
import 'package:escli/nodes.dart' as nodes;
import 'package:escli/settings.dart' as settings;
import 'package:escli/stats.dart' as stats;
import 'package:escli/select.dart' as select;
import 'package:escli/add.dart' as add;
import 'package:escli/clusters.dart' as clusters;
import 'package:escli/util.dart' as util;

void main(List<String> arguments) async {
  final command = arguments[0];
  final baseHost = await util.getSelectedClusterHost();

  if (command == 'clusters'){
    clusters.clusters();
  }else if (command == 'add') {
    add.add(arguments[1], arguments[2]);
  } else if (command == 'select'){
    select.select(arguments[1]);
  } else if (command == 'health') {
    health.health(baseHost);
  } else if (command == 'stats') {
    stats.stats(baseHost, arguments.sublist(1));
  } else if (command == 'nodes') {
    nodes.nodes(baseHost, arguments.sublist(1));
  } else if (command == 'settings'){
    settings.settings(baseHost, arguments.sublist(1));
  } else if (command == 'indices') {
    indices.indices(baseHost, arguments.sublist(1));
  } else if (command == 'shards') {
    shards.shards(baseHost, arguments.sublist(1));
  } else {
    print('Incorrect command or insufficient arguments');
  }
}
