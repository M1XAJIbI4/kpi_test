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
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroupItem: (str, from, to) {
      print('on move group item - $str $from $to');
    },
    onMoveGroup: (gr1, from, gr2, to) {
      print('on move group $gr1 $from $gr2 $to');
    },
    onMoveGroupItemToGroup: (grFrom, from, grTo, to) {
      print('on move item to group $grFrom $from $grTo $to');
    }
  );


  late AppFlowyBoardScrollController boardController;

  @override
  void didUpdateWidget(covariant _KanbanBoardWidget oldWidget) {
    print('FOOBAR DID UPDATE');
    super.didUpdateWidget(oldWidget);
  }

  int _groupCount = 1;

  @override
  void initState() {
    _configureBoard();
    super.initState();
    // _itemWidthNotifier.value = MediaQuery.sizeOf(context).width;
    boardController = AppFlowyBoardScrollController();
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
      controller.addGroup(group);
    }
    _groupCount = controller.groupDatas.length;
  }

  TaskTextItem _createTextItem(int index, String taskId) =>
      TaskTextItem(index, taskId);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: AppFlowyBoard(
        controller: controller,
        boardScrollController: boardController,
        groupConstraints: BoxConstraints(
          maxWidth: min(MediaQuery.sizeOf(context).width / _groupCount * 0.95, 400),
          // minWidth: 200,
        ),
        headerBuilder: (_, groupData) {
          groupData.headerData.groupName;
          return Container(
            width: double.infinity,
            height: 40,
            color: Colors.red,
          );
        },
       
       
        cardBuilder: (controller, group, groupItem) {
          final textItem = groupItem as TaskTextItem;
          final task = widget.allTasksMap[textItem.taskId];
          return AppFlowyGroupCard(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            boxConstraints: BoxConstraints(minWidth: 200),
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
  String get id => index.toString();
}
