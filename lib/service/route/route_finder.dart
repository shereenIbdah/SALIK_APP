import '../../constants/constants.dart';
import '../../pages/route_node.dart';
import '../checkpoint_service.dart';
import '../city_service.dart';

class BasicFinder {
  final CityService firebaseCity = CityService();
  final CheckpointService firebaseCheckpoint = CheckpointService();

  final Map<Node, List<Node>> adjacencyList = {};

  Future<Node> _getNodeByName(String nodeName) async {
    // Find the node with the specified name
    return adjacencyList.keys.firstWhere(
      (key) => key.name == nodeName,
    );
  }
  
  Future<bool> _isCheckpoint(String nodeName) async {
    Node? node = await _getNodeByName(nodeName);
    if(node.type == NodeType.checkpoint) {
      return true;
    }
    return false;
  }

  Future<List<Node>> getAdjacentNodesByName(String nodeName) async {
    // Find the node with the specified name
    Node? node = await _getNodeByName(nodeName);
    return adjacencyList[node] ?? [];
  }

  Future<void> addEdge(Node node1, Node node2) async {
    adjacencyList.putIfAbsent(node1, () => []).add(node2);
    // For undirected graph
    adjacencyList.putIfAbsent(node2, () => []).add(node1);
  }

  Future<void> findPaths(
    String current,
    String goal,
    List<String> visited,
    List<String> path,
    Set<NodePath> uniquePaths,
    int checkpointsLimit,
  ) async {
    visited.add(current);
    path.add(current);

    if (path.length > (adjacencyList.length) || checkpointsLimit > AppConstants.limitForCheckpoint) {
      // Backtrack
      path.removeLast();
      visited.remove(current);
      return;
    }

    if (current == goal) {
      List<Node> nodes = [];
      for (var name in path) {
        nodes.add(await _getNodeByName(name));
      }
      // Convert path of names to path of Nodes
      uniquePaths.add(NodePath(nodes));
    } else {
      for (String neighbor in (await getAdjacentNodesByName(current))
          .map((node) => node.name)
          .toList()) {
        if (!visited.contains(neighbor)) {
          if(checkpointsLimit != -1) {
            if(await _isCheckpoint(neighbor)) {
              await findPaths(neighbor, goal, visited, path, uniquePaths, checkpointsLimit + 1);
            } else {
              await findPaths(neighbor, goal, visited, path, uniquePaths, 0);
            }
          } else { 
            await findPaths(neighbor, goal, visited, path, uniquePaths, checkpointsLimit);
          }
        }
      }
    }

    // Backtrack
    path.removeLast();
    visited.remove(current);
  }
}
