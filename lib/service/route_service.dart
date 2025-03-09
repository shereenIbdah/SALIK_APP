import 'package:grad_app/pages/route_node.dart';

import 'route/city_route_finder.dart';
import 'route/deep_route_finder.dart';

class RouteService {
  final CityRouteFinder cityRouteFinder;

  RouteService(this.cityRouteFinder);

  Future<List<Path>> computeBestPaths(
      String start, String goal, int maxPathsToShow) async {
    final generalStopwatch = Stopwatch()..start();
    Set<String> namesOfCities =
        await cityRouteFinder.getRelatedCitiesInRoad(start, goal);
    DeepRouteFinder deepRouteFinder = DeepRouteFinder();
    final initializeGraphStopwatch = Stopwatch()..start();
    await deepRouteFinder.initializeGraph(namesOfCities);
    initializeGraphStopwatch.stop();
    int elapsedMilliseconds = initializeGraphStopwatch.elapsedMilliseconds;
    print('Exec time in initializing deep graph: ${elapsedMilliseconds}ms');

    // Find and print the best 5 roads between initialCity and targetCity
    List<Path> bestPaths =
        await deepRouteFinder.findBestPaths(start, goal, maxPathsToShow);

    generalStopwatch.stop();
    print('Execution time: ${generalStopwatch.elapsedMilliseconds} ms');
    print('Best $maxPathsToShow roads between ${start} and ${goal}:');
    for (var path in bestPaths) {
      String roadDetails = path.route.map((node) {
        return "${node.name}${(node.type == NodeType.checkpoint) ? "(${node.status})" : ""}";
      }).join(",");
      print("Road ${path.safetyPercentage}: $roadDetails");
    }
    return bestPaths;
  }
}
