part of 'home_screen.dart';

class _KanbanBoardWidget extends StatefulWidget {
  final Map<String, List<Task>> sortedTasks;
  final Map<String, Task> allTasksMap;

  const _KanbanBoardWidget({
    required this.allTasksMap,
    required this.sortedTasks,
  });

  @override
  State<_KanbanBoardWidget> createState() => _KanbanBoardWidgetState();
}

class _KanbanBoardWidgetState extends State<_KanbanBoardWidget> {
  late final AppFlowyBoardController boardController;

  late AppFlowyBoardScrollController boardScrollController;
  late final TaskListCubit _taskListCubit;

  int _groupCount = 1;

  @override
  void initState() {
    _taskListCubit =  context.read<TaskListCubit>();
    boardController = AppFlowyBoardController(
      onMoveGroupItem: _onMoveGroupItem,
      onMoveGroup: _onMoveGroup,
      onMoveGroupItemToGroup:_onMoveGroupItemToGroup,
    );
  
    _configureBoard();
    boardScrollController = AppFlowyBoardScrollController();
    super.initState();
  }

  void _onMoveGroupItem(String groupKey, int fromIndex, int toIndex) {
    final task = _findTask(groupKey, toIndex);
    logger.d('TASK - ${task?.name} $toIndex $groupKey');
    if (task != null) {
      _taskListCubit.updateTask(
        taskId: task.indicatorToMoId, 
        parentId: task.parentId, 
        newOrder: toIndex + 1
      );
    }
  }

  void _onMoveGroup(String gr1, int from, String gr2, int to ) {}

  void _onMoveGroupItemToGroup(String grFrom, int indexFrom, String grTo, int indexTo) {
    final task = _findTask(grTo, indexTo);
    logger.d('TASK - ${task?.name} $indexTo $grTo');
    if (task != null) {
      _taskListCubit.updateTask(
        taskId: task.indicatorToMoId, 
        parentId: grTo, 
        newOrder: indexTo + 1,
      );
    }
  }

  Task? _findTask(String groupKey, int index) {
    final items = boardController.groupDatas.firstWhere((e) => e.id == groupKey).items;
    final item = items[index] as TaskTextItem;
    final task = widget.allTasksMap[item.taskId];

    return task;
  }

  void _configureBoard() {
    final sortedMap = widget.sortedTasks;

    int index = 0;
    for (final groupKey in sortedMap.keys) {
      final currentGroupTasks = sortedMap[groupKey] ?? [];
      final group = AppFlowyGroupData<TaskTextItem>(
        id: groupKey,
        name: groupKey,
        items: [
          ...currentGroupTasks.map((e) {
            final item = _createTextItem(index, e.indicatorToMoId);
            index++;
            return item;
          }),
        ],
      );
      boardController.addGroup(group);
    }
    _groupCount = boardController.groupDatas.length;
  }

  TaskTextItem _createTextItem(int index, String taskId) =>
      TaskTextItem(index, taskId);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: AppFlowyBoard(
        controller: boardController,
        config: const AppFlowyBoardConfig(boardCornerRadius: 4.0, cardMargin: EdgeInsets.zero, groupHeaderPadding: EdgeInsets.zero),
        boardScrollController: boardScrollController,
        groupConstraints: BoxConstraints(
          maxWidth: min(MediaQuery.sizeOf(context).width / _groupCount * 0.95, 400),
          // minWidth: 200,
        ),
        headerBuilder: (_, groupData) => Container(
            width: double.infinity,
            height: 40,
            color: Colors.red,
            child: Text(groupData.headerData.groupName),
          ),
       
       
        cardBuilder: (ctx, group, groupItem) {
          final textItem = groupItem as TaskTextItem;
          final task = widget.allTasksMap[textItem.taskId];
          return AppFlowyGroupCard(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            boxConstraints: const BoxConstraints(minWidth: 200),
            key: ValueKey(groupItem.id),
            child: task != null
                ? GestureDetector(
                    onTap: () {
                      print('FOOBAR on task tap - ${task.parentId} ${task.indicatorToMoId}');
                    },
                    child: TaskItem(task: task),
                  )
                : Text(textItem.index.toString()),
          );
        },
      ));
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}

class TaskTextItem extends AppFlowyGroupItem {
  final int index;
  final String taskId;

  TaskTextItem(this.index, this.taskId);

  @override
  String get id => '${index.toString()} $taskId';
}