import 'package:grad_app/constants/constants.dart';

import '../../model/checkpoint.dart';
import '../../model/city.dart';
import '../../pages/route_node.dart';
import 'route_finder.dart';

class DeepRouteFinder extends BasicFinder {
  Map<String, String> checkpointStatusMap = {};

  Future<List<String>> getLinkedCheckpoints(String city1, String city2,
      List<Checkpoint> filteredExternalCheckpoints) async {
    List<String> linkedCheckpoints = [];
    for (var checkpoint in filteredExternalCheckpoints) {
      if (checkpoint.nearbyCities[0] == city1 &&
          checkpoint.nearbyCities.contains(city2)) {
        linkedCheckpoints.add(checkpoint.name);
        checkpointStatusMap.putIfAbsent(
            checkpoint.name, () => checkpoint.status);
      }
    }
    return linkedCheckpoints;
  }

  Future<Node> createCheckpointNode(String checkpoint) async {
    return Node(
      name: checkpoint,
      type: NodeType.checkpoint,
    );
  }

  Future<void> initializeGraph(Set<String> namesOfCities) async {
    List<City> filteredCities = await firebaseCity
        .getFilteredCitiesAndNeighborsByCityNames(namesOfCities);
    List<Checkpoint> filteredExternalCheckpoints =
        await firebaseCheckpoint.getCheckpointsByCitiesAndType(
            namesOfCities: namesOfCities,
            type: AppConstants.externalCheckpoint);
    for (var city in filteredCities) {
      String cityName = city.name;
      if (!namesOfCities.contains(cityName)) {
        continue;
      }
      List<String> neighbors = List<String>.from(city.neighbors);
      Node cityNode = Node(name: cityName, type: NodeType.city);
      for (String neighbor in neighbors) {
        if (!namesOfCities.contains(neighbor)) {
          continue;
        }
        Node neighborNode = Node(name: neighbor, type: NodeType.city);
        List<String> cityCheckpoints = await getLinkedCheckpoints(
            cityName, neighbor, filteredExternalCheckpoints);
        List<String> neighborCheckpoints = await getLinkedCheckpoints(
            neighbor, cityName, filteredExternalCheckpoints);

        if (cityCheckpoints.isNotEmpty || neighborCheckpoints.isNotEmpty) {
          for (var cityCheckpoint in cityCheckpoints) {
            Node cityCheckpointNode =
                await createCheckpointNode(cityCheckpoint);
            await addEdge(cityNode, cityCheckpointNode);

            if (neighborCheckpoints.isNotEmpty) {
              for (var neighborCheckpoint in neighborCheckpoints) {
                Node neighborCheckpointNode =
                    await createCheckpointNode(neighborCheckpoint);
                await addEdge(cityCheckpointNode, neighborCheckpointNode);
                await addEdge(neighborCheckpointNode, neighborNode);
              }
            } else {
              await addEdge(neighborNode, cityCheckpointNode);
            }
          }

          if (cityCheckpoints.isEmpty) {
            for (var neighborCheckpoint in neighborCheckpoints) {
              Node neighborCheckpointNode =
                  await createCheckpointNode(neighborCheckpoint);
              await addEdge(cityNode, neighborCheckpointNode);
              await addEdge(neighborNode, neighborCheckpointNode);
            }
          }
        } else {
          await addEdge(cityNode, neighborNode);
        }
      }
    }
  }

  Future<double> calculateSafetyForRoute(List<Node> route) async {
    double count = 0, sum = 0;
    for (Node node in route) {
      if (node.type == NodeType.city) {
        continue;
      }
      count++;
      node.status = checkpointStatusMap[node.name] ?? "";
      sum += AppConstants.dangerWeight[node.status] ?? 0;
    }
    if (count == 0) return 1.0;
    return 1 - (sum / count);
  }

  Future<List<Path>> findBestPaths(
      String start, String goal, int maxPaths) async {
    Set<NodePath> uniquePaths = {};
    List<String> visited = [];
    List<String> path = [];
    await findPaths(start, goal, visited, path, uniquePaths, 0);

    // Convert the paths back to lists
    List<Path> allPaths = [];
    for (var nodePath in uniquePaths) {
      double safetyPercentage = await calculateSafetyForRoute(nodePath.nodes);
      allPaths
          .add(Path(route: nodePath.nodes, safetyPercentage: safetyPercentage));
    }

    allPaths.sort((a, b) {
      double safetyA = a.safetyPercentage;
      double safetyB = b.safetyPercentage;

      // First, compare by total priority
      if (safetyA != safetyB) {
        return safetyB.compareTo(safetyA);
      }
      // If priorities are equal, compare by length of path
      return a.route.length.compareTo(b.route.length);
    });
    print("Num of All Paths in Deep Route Finder: ${allPaths.length}");
    
    // Return the top 'maxPaths' shortest paths
    allPaths = allPaths.take(maxPaths).toList();
    return allPaths;
  }
}
