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
    name = map['name'] ?? '',
    indicatorToMoId = map[''] ?? '',
    parentId = '',
    order = 1;
}