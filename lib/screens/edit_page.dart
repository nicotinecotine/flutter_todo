import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/task_provider.dart';
import 'package:flutter_todo/providers/edit_provider.dart';
import 'package:flutter_todo/models/task_model.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF7F6F2),
      body: CustomScrollView(
        slivers: [
          EditSliverAppBar(),
          EditSliverBody(),
        ],
      ),
    );
  }
}

class EditSliverAppBar extends StatelessWidget {
  const EditSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    EditProvider editProvider = Provider.of<EditProvider>(context);
    return SliverAppBar(
      backgroundColor: const Color(0xffF7F6F2),
      pinned: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        padding: EdgeInsets.zero,
        color: Colors.black,
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: TextButton(
            onPressed: () {
              if (editProvider.toDo != '') {
                taskProvider.addTask(
                  editProvider.toDo,
                  editProvider.importancy,
                  editProvider.date,
                  editProvider.isCompleted,
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'СОХРАНИТЬ',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ),
      ],
    );
  }
}

class EditSliverBody extends StatelessWidget {
  const EditSliverBody({super.key});

  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                editProvider.changeToDo(value);
              },
              maxLines: null,
              decoration: InputDecoration(
                hintText: editProvider.toDo,
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: const Text(
              'Важность',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            child: DropdownButtonFormField<String>(
              value: editProvider.importancy,
              items: ['Нет', 'Низкая', '!! Важно'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: value == '!! Важно'
                        ? const TextStyle(color: Colors.red)
                        : const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                editProvider.changeImportancy(value ?? '');
              },
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: const Text(
                      'Сделать до',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  editProvider.isSwitched
                      ? Container(
                          padding: const EdgeInsets.only(
                            top: 4,
                            left: 16,
                            bottom: 20,
                          ),
                          child: Text(
                            editProvider.date.toString().split(' ')[0],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.indigo,
                            ),
                          ),
                        )
                      : const Text(''),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Switch(
                  value: editProvider.isSwitched,
                  onChanged: (value) {
                    if (value == true) {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        if (date != null) {
                          editProvider.changeDate(date);
                          editProvider.toSwitch();
                        }
                      });
                    } else {
                      editProvider.toSwitch();
                    }
                  },
                ),
              )
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 8),
            child: editProvider.toDo != ''
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (taskProvider.allTasks.contains(
                        Task(
                          editProvider.toDo,
                          editProvider.importancy,
                          editProvider.date,
                          editProvider.isCompleted,
                        ),
                      )) {
                        taskProvider.allTasks.remove(
                          Task(
                            editProvider.toDo,
                            editProvider.importancy,
                            editProvider.date,
                            editProvider.isCompleted,
                          ),
                        );
                      } else if (taskProvider.tasksNotCompleted.contains(
                        Task(
                          editProvider.toDo,
                          editProvider.importancy,
                          editProvider.date,
                          editProvider.isCompleted,
                        ),
                      )) {
                        taskProvider.tasksNotCompleted.remove(
                          Task(
                            editProvider.toDo,
                            editProvider.importancy,
                            editProvider.date,
                            editProvider.isCompleted,
                          ),
                        );
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text(
                            'Удалить',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const TextButton(
                    onPressed: null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text(
                            'Удалить',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
