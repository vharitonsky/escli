import 'package:colorize/colorize.dart';
import 'package:escli/util.dart' as util;

import 'health.dart';

void clusters(List<String> arguments) async {
  final clusters = await util.getClusters();
  if (arguments.isNotEmpty && arguments[0] == 'health') {
    for (final cluster in clusters) {
      print('${cluster.name} ${cluster.host} ${await getHealth(cluster.host)}');
    }
    return;
  } else {
    for (final cluster in clusters) {
      var clusterString = '${cluster.name} ${cluster.host}';
      if (cluster.selected) {
        clusterString = Colorize(clusterString).lightBlue().underline().toString();
      }
      print(clusterString);
    }
  }
}

void clustersHealth() async{
  final clusters = await util.getClusters();
  for (final cluster in clusters) {
    print('${cluster.name}\t${cluster.host}\t${getHealth(cluster.host)}');
  }
}