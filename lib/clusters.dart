import 'package:colorize/colorize.dart';
import 'package:escli/util.dart' as util;

import 'health.dart';

void clusters(List<String> arguments) async {
  var subcommand = arguments.isNotEmpty ? arguments[0] : '';
  final clusters = await util.getClusters();
  if (subcommand == 'health') {
    for (final cluster in clusters) {
      print(
          '${cluster.name} ${cluster.host} ${util.colorizeHealth(await getHealth(cluster.host))}');
    }
    return;
  } else if (subcommand == 'red') {
    for (final cluster in clusters) {
      var health = await getHealth(cluster.host);
      if ([util.ClusterHealth.red, util.ClusterHealth.unreachable]
          .contains(health)) {
        print('${cluster.name} ${cluster.host} ${util.colorizeHealth(health)}');
      }
    }
    return;
  } else if (subcommand == 'yellow') {
    for (final cluster in clusters) {
      var health = await getHealth(cluster.host);
      if (health == util.ClusterHealth.yellow) {
        print('${cluster.name} ${cluster.host} ${util.colorizeHealth(health)}');
      }
    }
    return;
  } else if (subcommand == 'green') {
    for (final cluster in clusters) {
      var health = await getHealth(cluster.host);
      if (health == util.ClusterHealth.green) {
        print('${cluster.name} ${cluster.host} ${util.colorizeHealth(health)}');
      }
    }
    return;
  } else {
    for (final cluster in clusters) {
      var clusterString = '${cluster.name} ${cluster.host}';
      if (cluster.selected) {
        clusterString =
            Colorize(clusterString).lightBlue().underline().toString();
      }
      print(clusterString);
    }
  }
}

void clustersHealth() async {
  final clusters = await util.getClusters();
  for (final cluster in clusters) {
    print('${cluster.name}\t${cluster.host}\t${getHealth(cluster.host)}');
  }
}
