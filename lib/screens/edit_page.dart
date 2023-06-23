import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_todo/providers/task_provider.dart';
import 'package:flutter_todo/providers/edit_provider.dart';
import 'package:flutter_todo/models/task_model.dart';
import 'package:flutter_todo/constants/colors.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
      backgroundColor: AppColors.backgroundColor,
      pinned: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        padding: EdgeInsets.zero,
        color: AppColors.textColor,
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        editProvider.isEdit
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: () {
                    if (editProvider.toDo != '') {
                      if (editProvider.isCompleted) {
                        taskProvider.completedTasks[editProvider.index] = Task(
                          editProvider.toDo,
                          editProvider.importancy,
                          editProvider.date,
                          editProvider.isCompleted,
                          editProvider.isSwitched,
                        );
                      } else {
                        taskProvider.tasksNotCompleted[editProvider.index] =
                            Task(
                                editProvider.toDo,
                                editProvider.importancy,
                                editProvider.date,
                                editProvider.isCompleted,
                                editProvider.isSwitched);
                      }
                      taskProvider.updateList();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: const TextStyle(color: AppColors.indigoColor),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: () {
                    if (editProvider.toDo != '') {
                      taskProvider.addTask(
                          editProvider.toDo,
                          editProvider.importancy,
                          editProvider.date,
                          editProvider.isCompleted,
                          editProvider.isSwitched);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: const TextStyle(color: AppColors.indigoColor),
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
              color: AppColors.foregroundColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              initialValue: editProvider.toDo,
              onChanged: (value) {
                editProvider.changeToDo(value);
              },
              maxLines: null,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.hintText,
                labelStyle: const TextStyle(
                  color: AppColors.shadowColor,
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
            child: Text(
              AppLocalizations.of(context)!.importance,
              style: const TextStyle(
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
              items: [
                AppLocalizations.of(context)!.basic,
                AppLocalizations.of(context)!.low,
                AppLocalizations.of(context)!.important,
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: value == AppLocalizations.of(context)!.important
                        ? const TextStyle(color: AppColors.attentionColor)
                        : const TextStyle(color: AppColors.textColor),
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
                    child: Text(
                      AppLocalizations.of(context)!.makeItTo,
                      style: const TextStyle(
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
                              color: AppColors.indigoColor,
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
            child: editProvider.isEdit
                ? TextButton(
                    onPressed: () {
                      if (editProvider.isCompleted) {
                        taskProvider.completedTasks.removeAt(
                          editProvider.index,
                        );
                        taskProvider.updateCount();
                      } else {
                        taskProvider.tasksNotCompleted.removeAt(
                          editProvider.index,
                        );
                        taskProvider.updateCount();
                      }
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          color: AppColors.attentionColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            AppLocalizations.of(context)!.delete,
                            style: const TextStyle(
                              color: AppColors.attentionColor,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : TextButton(
                    onPressed: null,
                    child: Row(
                      children: [
                        const Icon(Icons.delete, color: AppColors.shadowColor),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            AppLocalizations.of(context)!.delete,
                            style: const TextStyle(
                              color: AppColors.shadowColor,
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
