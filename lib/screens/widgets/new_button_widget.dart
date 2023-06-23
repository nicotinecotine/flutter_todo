import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/constants/colors.dart';
import 'package:flutter_todo/providers/edit_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewButton extends StatelessWidget {
  const NewButton({super.key});

  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
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
            editProvider.edit(
                '', 'Нет', DateTime.now(), false, false, false, 0);
            Navigator.pushNamed(context, '/editPage');
          },
          child: Text(
            AppLocalizations.of(context)!.newTodo,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.shadowColor,
            ),
          ),
        ),
      ),
    );
  }
}
