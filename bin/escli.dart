import 'package:escli/shards.dart' as shards;
import 'package:escli/indices.dart' as indices;
import 'package:escli/health.dart' as health;
import 'package:escli/settings.dart' as settings;

void main(List<String> arguments) async {
  final baseHost = arguments[0];
  final command = arguments[1];

  if (command == 'health') {
    health.health(baseHost);
  } else if (command == 'settings' && arguments.length > 2){
    settings.settings(baseHost, arguments.sublist(2));
  } else if (command == 'indices') {
    indices.indices(baseHost, arguments.sublist(2));
  } else if (command == 'shards') {
    shards.shards(baseHost, arguments.sublist(2));
  }
}
