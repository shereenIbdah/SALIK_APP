class Node {
  final String name;
  final NodeType type; // "checkpoint" or "city"
  String status; // If it's checkpoint

  Node({
    required this.name,
    required this.type,
    this.status = "",
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Node && other.name == name && other.type == type;
  }

  @override
  int get hashCode => name.hashCode ^ type.hashCode;
}

enum NodeType {
  city,
  checkpoint,
}

class NodePath {
  final List<Node> nodes;

  NodePath(this.nodes);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NodePath) return false;
    return _areListsEqual(nodes, other.nodes);
  }

  @override
  int get hashCode =>
      nodes.map((node) => node.hashCode).fold(0, (prev, curr) => prev ^ curr);

  bool _areListsEqual(List<Node> list1, List<Node> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}

class Path {
  final List<Node> route;
  final double safetyPercentage;

  Path({
    required this.route,
    required this.safetyPercentage,
  });
}
