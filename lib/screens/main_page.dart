import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_todo/providers/edit_provider.dart';
import 'package:flutter_todo/providers/scroll_provider.dart';
import 'package:flutter_todo/providers/task_provider.dart';
import 'package:flutter_todo/models/task_model.dart';
import 'package:flutter_todo/constants/colors.dart';
import 'package:flutter_todo/screens/widgets/new_button_widget.dart';
import 'package:flutter_todo/data/networking.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollProvider scroll = Provider.of<ScrollProvider>(context);
    EditProvider editProvider = Provider.of<EditProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.indigoColor,
        child: const Icon(
          Icons.add,
          color: AppColors.backgroundColor,
        ),
        onPressed: () {
          editProvider.edit('', 'Нет', DateTime.now(), false, false, false, 0);
          Navigator.pushNamed(context, '/editPage');
        },
      ),
      body: RefreshIndicator(
        displacement: 15,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: updateTasksList,
        child: CustomScrollView(
          controller: scroll.scrollController,
          slivers: const <Widget>[
            MySliverAppBar(),
            MySliverRow(),
            MySliverTasks(),
            MySliverSizedBox(),
          ],
        ),
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
      backgroundColor: AppColors.backgroundColor,
      actions: [
        if (scroll.topEyeVisibility)
          !taskProvider.isCompletedVisible
              ? IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: AppColors.indigoColor,
                  ),
                  onPressed: () {
                    taskProvider.changeVisibility();
                  },
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.visibility_off,
                    color: AppColors.indigoColor,
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
        title: Text(
          AppLocalizations.of(context)!.title,
          style: const TextStyle(
            fontSize: 24,
            color: AppColors.textColor,
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
              '${AppLocalizations.of(context)!.done} ${taskProvider.completedTaskCount}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.shadowColor,
              ),
            ),
            !taskProvider.isCompletedVisible
                ? IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: AppColors.indigoColor.withOpacity(
                        scroll.bottomEyeTransparency,
                      ),
                    ),
                    onPressed: () {
                      taskProvider.changeVisibility();
                    },
                  )
                : IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.visibility_off,
                      color: AppColors.indigoColor.withOpacity(
                        scroll.bottomEyeTransparency,
                      ),
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
              color: AppColors.shadowColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          color: AppColors.foregroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: taskProvider.isCompletedVisible
            ? ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (taskProvider.completedTasks +
                        taskProvider.tasksNotCompleted)
                    .length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = (taskProvider.completedTasks +
                      taskProvider.tasksNotCompleted)[index];
                  if (item.title == 'workingtitle256') {
                    return const NewButton();
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
                              taskProvider.completedTasks.add(item);
                              taskProvider.updateCount();
                            });
                            return false;
                          } else if (direction == DismissDirection.endToStart) {
                            return true;
                          }
                          return null;
                        },
                        background: Container(
                          color: AppColors.activeCheckBoxColor,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Icon(
                                Icons.check,
                                color: AppColors.foregroundColor,
                              ),
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: AppColors.attentionColor,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.delete,
                                color: AppColors.foregroundColor,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            if (item.isDone == false) {
                              setState(() {
                                item.isDone = true;
                                taskProvider.tasksNotCompleted.remove(item);
                                taskProvider.completedTasks.add(item);
                                taskProvider.updateCount();
                              });
                            }
                          } else if (direction == DismissDirection.endToStart) {
                            if (item.isDone == true) {
                              setState(() {
                                taskProvider.completedTasks.remove(item);
                              });
                            } else {
                              setState(() {
                                taskProvider.tasksNotCompleted.remove(item);
                              });
                            }
                          }
                          taskProvider.updateCount();
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
                                      activeColor:
                                          AppColors.activeCheckBoxColor,
                                      onChanged: (e) {
                                        setState(() {
                                          item.isDone = !item.isDone;
                                          if (item.isDone == false) {
                                            taskProvider.completedTasks
                                                .remove(item);
                                            taskProvider.tasksNotCompleted
                                                .removeLast();
                                            taskProvider.tasksNotCompleted
                                                .add(item);
                                            taskProvider.tasksNotCompleted.add(
                                              Task(
                                                'workingtitle256',
                                                'no',
                                                DateTime.now(),
                                                false,
                                                false,
                                              ),
                                            );
                                          } else {
                                            taskProvider.tasksNotCompleted
                                                .remove(item);
                                            taskProvider.completedTasks
                                                .add(item);
                                          }
                                        });
                                        taskProvider.updateCount();
                                      },
                                      value: item.isDone,
                                    ),
                                    if (item.importance ==
                                        AppLocalizations.of(context)!.low)
                                      Container(
                                        padding: EdgeInsets.zero,
                                        child: const Icon(
                                            Icons.keyboard_arrow_down),
                                      )
                                    else if (item.importance ==
                                        AppLocalizations.of(context)!.important)
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 2),
                                        child: const Text(
                                          '!!',
                                          style: TextStyle(
                                            color: AppColors.attentionColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.zero,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
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
                                                      color:
                                                          AppColors.shadowColor,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          AppColors.shadowColor,
                                                    ),
                                                  ),
                                            if (item.isDateVisible)
                                              Text(
                                                item.date
                                                    .toString()
                                                    .split(' ')[0],
                                                style: const TextStyle(
                                                  color: AppColors.shadowColor,
                                                  fontSize: 14,
                                                ),
                                              )
                                          ],
                                        ),
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
                                editProvider.edit(
                                  item.title,
                                  item.importance,
                                  item.date!,
                                  item.isDateVisible,
                                  true,
                                  item.isDone,
                                  item.isDone
                                      ? index
                                      : index - taskProvider.completedTaskCount,
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
                    return const NewButton();
                  } else {
                    return ClipRect(
                      child: Dismissible(
                        key: Key(item.title),
                        direction: DismissDirection.horizontal,
                        background: Container(
                          color: AppColors.activeCheckBoxColor,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Icon(
                                Icons.check,
                                color: AppColors.foregroundColor,
                              ),
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: AppColors.attentionColor,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.delete,
                                color: AppColors.foregroundColor,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            setState(() {
                              taskProvider.tasksNotCompleted.remove(item);
                              item.isDone = true;
                              taskProvider.completedTasks.add(item);
                            });
                          } else if (direction == DismissDirection.endToStart) {
                            setState(() {
                              taskProvider.tasksNotCompleted.remove(item);
                            });
                          }
                          taskProvider.updateCount();
                        },
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColors.activeCheckBoxColor,
                                    onChanged: (e) {
                                      if (item.isDone == false) {
                                        setState(() {
                                          taskProvider.tasksNotCompleted
                                              .remove(item);
                                          item.isDone = true;
                                          taskProvider.completedTasks.add(item);
                                          taskProvider.updateCount();
                                        });
                                      } else {
                                        setState(() {
                                          taskProvider.completedTasks
                                              .remove(item);
                                          item.isDone = false;
                                          taskProvider.tasksNotCompleted
                                              .add(item);
                                          taskProvider.completedTasks.add(item);
                                          taskProvider.updateCount();
                                        });
                                      }
                                    },
                                    value: item.isDone,
                                  ),
                                  if (item.importance ==
                                      AppLocalizations.of(context)!.low)
                                    Container(
                                      padding: EdgeInsets.zero,
                                      child:
                                          const Icon(Icons.keyboard_arrow_down),
                                    )
                                  else if (item.importance ==
                                      AppLocalizations.of(context)!.important)
                                    Container(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: const Text(
                                        '!!',
                                        style: TextStyle(
                                          color: AppColors.attentionColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.zero,
                                          child: Text(
                                            item.title.trim(),
                                          ),
                                        ),
                                        if (item.isDateVisible)
                                          Text(
                                            item.date.toString().split(' ')[0],
                                            style: const TextStyle(
                                              color: AppColors.shadowColor,
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
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                Navigator.pushNamed(context, '/editPage');
                                editProvider.edit(
                                  item.title,
                                  item.importance,
                                  item.date!,
                                  item.isDateVisible,
                                  true,
                                  item.isDone,
                                  index,
                                );
                              },
                            ),
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
