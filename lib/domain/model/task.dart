class Task {
  final String name;
  final String indicatorToMoId;
  final String parentId;
  final int order;

  Task({
    required this.name, 
    required this.indicatorToMoId, 
    required this.parentId, 
    required this.order,
  });

  Task.fromMap(Map<String, dynamic> map) : 
    name = map['name'].toString(),
    indicatorToMoId = map['indicator_to_mo_id'].toString(),
    parentId = map['parent_id'].toString(),
    order = map['order'];

  @override
  bool operator ==(Object other) =>
      runtimeType == other.runtimeType &&
      other is Task &&
      name == other.name &&
      indicatorToMoId == other.indicatorToMoId &&
      parentId == other.parentId &&
      order == other.order;

  @override
  int get hashCode =>
      name.hashCode +indicatorToMoId.hashCode + parentId.hashCode + order.hashCode;
}