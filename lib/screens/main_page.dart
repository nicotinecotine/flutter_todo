import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/edit_provider.dart';
import 'package:flutter_todo/providers/scroll_provider.dart';
import 'package:flutter_todo/providers/task_provider.dart';
import 'package:flutter_todo/models/task_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollProvider scroll = Provider.of<ScrollProvider>(context);
    EditProvider editProvider = Provider.of<EditProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF7F6F2),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/editPage');
          editProvider.changeToDo('');
          editProvider.changeDate(DateTime.now());
          editProvider.changeImportancy('Нет');
          editProvider.changeSwitch(false);
        },
      ),
      body: CustomScrollView(
        controller: scroll.scrollController,
        slivers: const <Widget>[
          MySliverAppBar(),
          MySliverRow(),
          MySliverTasks(),
          MySliverSizedBox(),
        ],
      ),
    );
  }
}

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollProvider scroll = Provider.of<ScrollProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return SliverAppBar(
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height / 5.4,
      backgroundColor: const Color(0xffF7F6F2),
      actions: [
        if (scroll.topEyeVisibility)
          !taskProvider.isCompletedVisible
              ? IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Color.fromRGBO(63, 81, 181, 1),
                  ),
                  onPressed: () {
                    taskProvider.changeVisibility();
                  },
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.visibility_off,
                    color: Color.fromRGBO(63, 81, 181, 1),
                  ),
                  onPressed: () {
                    taskProvider.changeVisibility();
                  },
                ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(
          left: scroll.titleLeftPadding,
          bottom: scroll.titleBottomPadding,
        ),
        title: const Text(
          'Мои дела',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class MySliverRow extends StatelessWidget {
  const MySliverRow({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollProvider scroll = Provider.of<ScrollProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 70,
          bottom: 6,
          right: 33,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Выполнено — ${taskProvider.allTasks.length - taskProvider.tasksNotCompleted.length}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff8E8E93),
              ),
            ),
            !taskProvider.isCompletedVisible
                ? IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Color.fromRGBO(
                          63, 81, 181, scroll.bottomEyeTransparency),
                    ),
                    onPressed: () {
                      taskProvider.changeVisibility();
                    },
                  )
                : IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.visibility_off,
                      color: Color.fromRGBO(
                          63, 81, 181, scroll.bottomEyeTransparency),
                    ),
                    onPressed: () {
                      taskProvider.changeVisibility();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class MySliverTasks extends StatefulWidget {
  const MySliverTasks({super.key});

  @override
  State<MySliverTasks> createState() => _MySliverTasksState();
}

class _MySliverTasksState extends State<MySliverTasks> {
  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    EditProvider editProvider = Provider.of<EditProvider>(context);
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: taskProvider.isCompletedVisible
            ? ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: taskProvider.allTasks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = taskProvider.allTasks[index];
                  if (item.title == 'workingtitle256') {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                          top: 6,
                          bottom: 6,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/editPage');
                            editProvider.changeToDo('');
                            editProvider.changeDate(DateTime.now());
                            editProvider.changeImportancy('Нет');
                            editProvider.changeSwitch(false);
                          },
                          child: const Text(
                            'Новое',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ClipRect(
                      child: Dismissible(
                        key: Key(item.title),
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd &&
                              item.isDone == false) {
                            setState(() {
                              item.isDone = true;
                              taskProvider.tasksNotCompleted.remove(item);
                            });
                            return false;
                          } else if (direction == DismissDirection.endToStart) {
                            return true;
                          }
                          return null;
                        },
                        background: Container(
                          color: Colors.green,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            setState(() {
                              item.isDone = true;
                              taskProvider.tasksNotCompleted.removeAt(index);
                            });
                          } else if (direction == DismissDirection.endToStart) {
                            setState(() {
                              if (taskProvider.tasksNotCompleted
                                  .contains(item)) {
                                taskProvider.tasksNotCompleted.removeAt(index);
                              }

                              taskProvider.allTasks.removeAt(index);
                            });
                          }
                        },
                        child: ListTile(
                          title: Container(
                            padding: EdgeInsets.zero,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.green,
                                      onChanged: (e) {
                                        setState(() {
                                          item.isDone = !item.isDone;
                                          if (item.isDone == false) {
                                            taskProvider.tasksNotCompleted
                                                .removeLast();
                                            taskProvider.tasksNotCompleted
                                                .add(item);
                                            taskProvider.tasksNotCompleted.add(
                                                Task('workingtitle256', 'no',
                                                    DateTime.now(), false));
                                          } else {
                                            taskProvider.tasksNotCompleted
                                                .remove(item);
                                          }
                                        });
                                      },
                                      value: item.isDone,
                                    ),
                                    if (item.importance == 'Низкая')
                                      Container(
                                        padding: EdgeInsets.zero,
                                        child: const Icon(
                                            Icons.keyboard_arrow_down),
                                      )
                                    else if (item.importance == '!! Важно')
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: const Text(
                                          '!!',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          !item.isDone
                                              ? Text(
                                                  item.title.trim(),
                                                )
                                              : Text(
                                                  item.title.trim(),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationColor:
                                                        Colors.grey,
                                                  ),
                                                ),
                                          if (item.date.day !=
                                              DateTime.now().day)
                                            Text(
                                              item.date
                                                  .toString()
                                                  .split(' ')[0],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 2, left: 1),
                            child: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                Navigator.pushNamed(context, '/editPage');
                                editProvider.changeToDo(item.title);
                                editProvider.changeDate(item.date);
                                editProvider.changeImportancy(item.importance);
                                editProvider.changeSwitch(
                                  item.date.day != DateTime.now().day,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: taskProvider.tasksNotCompleted.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = taskProvider.tasksNotCompleted[index];
                  if (item.title == 'workingtitle256') {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                          top: 6,
                          bottom: 6,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/editPage');
                            editProvider.changeToDo('');
                            editProvider.changeDate(DateTime.now());
                            editProvider.changeImportancy('Нет');
                            editProvider.changeSwitch(false);
                          },
                          child: const Text(
                            'Новое',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ClipRect(
                      child: Dismissible(
                        key: Key(item.title),
                        direction: DismissDirection.horizontal,
                        background: Container(
                          color: Colors.green,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            setState(() {
                              item.isDone = true;
                              taskProvider.tasksNotCompleted.removeAt(index);
                            });
                          } else if (direction == DismissDirection.endToStart) {
                            setState(() {
                              taskProvider.tasksNotCompleted.removeAt(index);
                              taskProvider.allTasks.remove(item);
                            });
                          }
                        },
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    onChanged: (e) {
                                      if (item.isDone == true) {
                                        setState(() {
                                          item.isDone = !item.isDone;
                                          taskProvider.tasksNotCompleted
                                              .removeAt(index);
                                        });
                                      }
                                      setState(() {
                                        item.isDone = !item.isDone;
                                        taskProvider.tasksNotCompleted
                                            .removeAt(index);
                                      });
                                    },
                                    value: item.isDone,
                                  ),
                                  if (item.importance == 'Низкая')
                                    Container(
                                      padding: EdgeInsets.zero,
                                      child:
                                          const Icon(Icons.keyboard_arrow_down),
                                    )
                                  else if (item.importance == '!! Важно')
                                    Container(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: const Text(
                                        '!!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.zero,
                                        child: Text(
                                          item.title..trim(),
                                        ),
                                      ),
                                      if (item.date.day != DateTime.now().day)
                                        Text(
                                          item.date.toString().split(' ')[0],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/editPage');
                                    editProvider.changeToDo(item.title);
                                    editProvider.changeDate(item.date);
                                    editProvider
                                        .changeImportancy(item.importance);
                                    editProvider.changeSwitch(
                                      item.date.day != DateTime.now().day,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}

class MySliverSizedBox extends StatelessWidget {
  const MySliverSizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 75,
      ),
    );
  }
}
