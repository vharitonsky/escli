import 'dart:convert' as convert;
import 'dart:io';
import 'package:colorize/colorize.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

enum ClusterHealth { red, green, yellow, unreachable }

final LETTERS = RegExp(r'([a-z]+)');

class Cluster {
  final String host;
  final String name;
  final bool selected;

  Cluster({
    required this.host,
    required this.name,
    required this.selected,
  });
}

void pprintJson(String jsonData) {
  if (stdout.hasTerminal) {
    print(highlightJson(convert.jsonDecode(jsonData)));
  } else {
    final encoder = convert.JsonEncoder.withIndent('  ');
    print(encoder.convert(convert.jsonDecode(jsonData)));
  }
}

String getConfigPath() {
  final home =
      io.Platform.environment['HOME'] ?? io.Platform.environment['USERPROFILE'];
  assert(home != null);
  return path.join(home ?? '', '.escli.conf');
}

Future<Map<String, dynamic>> getSettings() async {
  final f = io.File(getConfigPath());
  if (f.existsSync()) {
    return convert.jsonDecode(await f.readAsString());
  } else {
    return {};
  }
}

Future<List<Cluster>> getClusters() async {
  final settings = await getSettings();
  var clusters = <Cluster>[];
  for (final cluster in settings['clusters'] ?? []) {
    clusters.add(Cluster(
      host: cluster['host'],
      name: cluster['name'],
      selected: cluster['selected'] ?? false,
    ));
  }
  return clusters;
}

Future<String?> getSelectedClusterHost() async {
  final settings = await getSettings();
  for (final cluster in settings['clusters'] ?? []) {
    if (cluster['selected']) {
      return cluster['host'];
    }
  }
  return null;
}

Future<List<String>> getClusterNames() async {
  final settings = await getSettings();
  List<dynamic> clusters = (settings['clusters'] ?? []);
  final names = clusters.map((e) => e['name'].toString()).toList();
  return names;
}

void writeArguments(List<String> arguments) async {
  final f = io.File('args').openWrite();
  f.write(arguments.join(' '));
  await f.close();
}

void setSettings(Map<String, dynamic> settings) async {
  final f = io.File(getConfigPath()).openWrite();
  f.write(convert.jsonEncode(settings));
  await f.close();
}

ClusterHealth parseHealth(String health) {
  switch (health) {
    case 'red':
      return ClusterHealth.red;
    case 'yellow':
      return ClusterHealth.yellow;
    case 'green':
      return ClusterHealth.green;
    default:
      return ClusterHealth.unreachable;
  }
}

String colorizeHealth(ClusterHealth health, {String text = ''}) {
  switch (health) {
    case ClusterHealth.green:
      return Colorize(text.isNotEmpty ? text : 'green').green().toString();
    case ClusterHealth.yellow:
      return Colorize(text.isNotEmpty ? text : 'yellow').yellow().toString();
    default:
      return Colorize(text.isNotEmpty ? text : health.toString())
          .red()
          .toString();
  }
}

const INDENT = 2;

String highlightJson(dynamic decoded,
    {int indent = 0, scalarIndent: 0, String buffer = ''}) {
  if (decoded is Map) {
    buffer += ' ' * scalarIndent + '{\n';
    indent += INDENT;
    var keys = decoded.keys.toList();
    keys.asMap().forEach((i, value) {
      buffer +=
          ' ' * indent + Colorize('"' + value + '"').blue().toString() + ': ';
      buffer +=
          highlightJson(decoded[keys[i]], indent: indent, scalarIndent: 0);
      if (i != keys.length - 1) {
        buffer += ',';
      }
      buffer += '\n';
    });
    buffer += ' ' * (indent - INDENT) + '}';
  } else if (decoded is List) {
    var keysLen = decoded.length;
    if (keysLen == 0) {
      buffer += '[]';
    } else {
      buffer += '[\n';
      indent += INDENT;
      decoded.asMap().forEach((key, value) {
        buffer += highlightJson(value, indent: indent, scalarIndent: indent);
        if (key != keysLen - 1) {
          buffer += ',';
        }
        buffer += '\n';
      });
      buffer += ' ' * (indent - INDENT) + ']';
    }
  } else if (decoded is int || decoded is double) {
    buffer += ' ' * scalarIndent + decoded.toString();
  } else {
    buffer += ' ' * scalarIndent +
        Colorize('"' + decoded.toString() + '"').green().toString();
  }
  return buffer;
}

double sizeToBytes(String sizeStr) {
  sizeStr = sizeStr.toLowerCase();
  final match = LETTERS.firstMatch(sizeStr);
  if (match == null) {
    return 0;
  }
  final value = match.group(0);
  if (value == null) {
    return 0;
  }
  sizeStr = sizeStr.replaceFirst(value, '');
  final size = double.parse(sizeStr);
  switch (value) {
    case 'gb':
      return size * 1024 * 1024 * 1024;
    case 'mb':
      return size * 1024 * 1024;
    case 'kb':
      return size * 1024;
    case 'b':
      return 0;
    default:
      return 0;
  }
}
