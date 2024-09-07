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
}