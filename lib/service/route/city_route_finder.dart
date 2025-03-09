import '../../model/city.dart';
import '../../pages/route_node.dart';
import 'route_finder.dart';

class CityRouteFinder extends BasicFinder {
  Future<void> populateCityData() async {
    print("Initializing Route Finder..");
    List<City> cities = await firebaseCity.getAllCities();
    for (var city in cities) {
      String cityName = city.name;
      List<String> neighbors = List<String>.from(city.neighbors);
      Node cityNode = Node(name: cityName, type: NodeType.city);
      for (String neighbor in neighbors) {
        Node neighborNode = Node(name: neighbor, type: NodeType.city);
        addEdge(cityNode, neighborNode);
      }
    }
    print("Route Finder Initialized!");
  }

  Future<Set<String>> getRelatedCitiesInRoad(
      String initialCity, String targetCity) async {
    return _findBestCitiesForRoute(initialCity, targetCity, 1);
  }

  Future<Set<String>> _findBestCitiesForRoute(
      String start, String goal, int maxPaths) async {
    Set<NodePath> uniquePaths = {};
    List<String> visited = [];
    List<String> path = [];
    await findPaths(start, goal, visited, path, uniquePaths, -1);

    // Convert the paths back to lists
    List<List<Node>> allPaths =
        uniquePaths.map((nodePath) => nodePath.nodes).toList();

    allPaths.sort((a, b) {
      return a.length.compareTo(b.length);
    });
    print("Num of All Paths: ${allPaths.length}");
    allPaths = allPaths.take(maxPaths).toList();
    Set<String> nodeNames = {};

    for (var path in allPaths) {
      for (var node in path) {
        nodeNames.add(node.name);
      }
    }
    print("Best Cities to reach the target: ${nodeNames}");
    return nodeNames;
  }
}
