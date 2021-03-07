import 'package:escli/shards.dart' as shards;
import 'package:escli/indices.dart' as indices;
import 'package:escli/health.dart' as health;
import 'package:escli/nodes.dart' as nodes;
import 'package:escli/settings.dart' as settings;
import 'package:escli/stats.dart' as stats;

void main(List<String> arguments) async {
  final baseHost = arguments[0];
  final command = arguments[1];

  if (command == 'health') {
    health.health(baseHost);
  } else if (command == 'stats') {
    stats.stats(baseHost, arguments.sublist(2));
  } else if (command == 'nodes') {
    nodes.nodes(baseHost, arguments.sublist(2));
  } else if (command == 'settings'){
    settings.settings(baseHost, arguments.sublist(2));
  } else if (command == 'indices') {
    indices.indices(baseHost, arguments.sublist(2));
  } else if (command == 'shards') {
    shards.shards(baseHost, arguments.sublist(2));
  } else {
    print('Incorrect command or insufficient arguments');
  }
}
