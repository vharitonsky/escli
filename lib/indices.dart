import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:escli/util.dart' as util;
import 'dart:io' as io;

const HEADERS = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

class Index {
  final String name;
  final util.ClusterHealth health;
  final String size;
  final String shards;
  final String replicas;
  final String docs;
  Index(
      {required this.name,
      required this.health,
      required this.size,
      required this.shards,
      required this.replicas,
      required this.docs});
}

void indices(String baseHost, List<String> arguments) async {
  final match = arguments.isNotEmpty ? arguments[0] : null;
  var indices = await getIndices(baseHost);
  if (match != null) {
    indices = indices.where((element) => element.name.contains(match)).toList();
  }
  for (final index in indices) {
    print('\t${util.colorizeHealth(index.health, text: index.name)}');
  }
}

Future<List<Index>> getIndices(String baseHost) async {
  final response =
      await http.read(Uri.http('$baseHost', '/_cat/indices'), headers: HEADERS);
  final indicesRaw = convert.jsonDecode(response);
  var indices = <Index>[];
  for (var indexRaw in indicesRaw) {
    indices.add(Index(
        name: indexRaw['index'],
        health: util.parseHealth(indexRaw['health']),
        size: indexRaw['store.size'],
        shards: indexRaw['pri'],
        replicas: indexRaw['rep'],
        docs: indexRaw['docs.count']));
  }
  return indices;
}

void index(String baseHost, List<String> arguments) async {
  var data;
  var subcommand = arguments[0];
  if (subcommand == 'create') {
    data = await create(baseHost, arguments[1]);
  } else if (subcommand == 'delete') {
    data = await delete(baseHost, arguments[1]);
  } else if (subcommand == 'open') {
    data = await open(baseHost, arguments[1]);
  } else if (subcommand == 'close') {
    data = await close(baseHost, arguments[1]);
  } else if (subcommand == 'reroute') {
    data = await reroute(baseHost, arguments[1]);
  } else if (subcommand == 'settings') {
    data = await settings(baseHost, arguments[1], arguments[2]);
  } else if (subcommand == 'mappings') {
    data = await mappings(baseHost, arguments[1], arguments[2]);
  } else if (subcommand == 'analysis') {
    data = await settings(baseHost, arguments[1], arguments[2]);
  } else if (subcommand == 'search') {
    data = await search(baseHost, arguments[1], arguments[2]);
  }
  util.pprintJson(data);
}

Future<String> settings(String baseHost, String index, String path) async {
  var headers = {...HEADERS};
  if (path != '') {
    if (path.endsWith('yaml') || path.endsWith('yml')) {
      headers['Content-Type'] = 'application/yaml';
    } else {
      headers['Content-Type'] = 'application/json';
    }
    var newSettings = await io.File(path).readAsString();
    var response = await http.put(Uri.http('$baseHost', '/$index/_settings'),
        headers: headers, body: newSettings);
    return response.body;
  } else {
    var response = await http.get(Uri.http('$baseHost', '/$index/_settings'),
        headers: headers);
    return response.body;
  }
}

Future<String> mappings(String baseHost, String index, String path) async {
  var headers = {...HEADERS};
  if (path != '') {
    if (path.endsWith('yaml') || path.endsWith('yml')) {
      headers['Content-Type'] = 'application/yaml';
    } else {
      headers['Content-Type'] = 'application/json';
    }
    var newSettings = await io.File(path).readAsString();
    var response = await http.put(Uri.http('$baseHost', '/$index/_mappings'),
        headers: headers, body: newSettings);
    return response.body;
  } else {
    var response = await http.get(Uri.http('$baseHost', '/$index/_mappings'),
        headers: headers);
    return response.body;
  }
}

Future<String> analysis(String baseHost, String index, String path) async {
  var headers = {...HEADERS};
  if (path != '') {
    if (path.endsWith('yaml') || path.endsWith('yml')) {
      headers['Content-Type'] = 'application/yaml';
    } else {
      headers['Content-Type'] = 'application/json';
    }
    var newSettings = await io.File(path).readAsString();
    var response = await http.put(Uri.http('$baseHost', '/$index/_analysis'),
        headers: headers, body: newSettings);
    return response.body;
  } else {
    var response = await http.get(Uri.http('$baseHost', '/$index/_analysis'),
        headers: headers);
    return response.body;
  }
}

Future<String> close(String baseHost, index) async {
  var response = await http.post(Uri.http('$baseHost', '/$index/_close'),
      headers: HEADERS);
  return response.body;
}

Future<String> open(String baseHost, index) async {
  var response =
      await http.post(Uri.http('$baseHost', '/$index/_open'), headers: HEADERS);
  return response.body;
}

Future<String> reroute(String baseHost, index) async {
  var response = await http.post(
      Uri.http('$baseHost', '/$index/_reroute?retry_failed=true'),
      headers: HEADERS);
  return response.body;
}

Future<String> create(String baseHost, index) async {
  var response =
      await http.put(Uri.http('$baseHost', '/$index'), headers: HEADERS);
  return response.body;
}

Future<String> delete(String baseHost, index) async {
  var response =
      await http.delete(Uri.http('$baseHost', '/$index'), headers: HEADERS);
  return response.body;
}

Future<String> search(String baseHost, index, query) async {
  var request = {
    'query': {
      'query_string': {
        'query': query,
      }
    }
  };
  var response = await http.post(
    Uri.http('$baseHost', '/$index/_search'),
    headers: HEADERS,
    body: convert.jsonEncode(request),
  );
  return response.body;
}
