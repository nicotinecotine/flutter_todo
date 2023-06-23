import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_todo/l10n/l10n.dart';
import 'package:flutter_todo/screens/main_page.dart';
import 'package:flutter_todo/screens/edit_page.dart';
import 'package:flutter_todo/providers/task_provider.dart';
import 'package:flutter_todo/providers/scroll_provider.dart';
import 'package:flutter_todo/providers/edit_provider.dart';

void main() {
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>.value(
          value: TaskProvider(),
        ),
        ChangeNotifierProvider<ScrollProvider>.value(
          value: ScrollProvider(),
        ),
        ChangeNotifierProvider<EditProvider>.value(
          value: EditProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ToDo App',
        theme: ThemeData(useMaterial3: true),
        home: const MainPage(),
        routes: {
          '/mainPage': (context) => const MainPage(),
          '/editPage': (context) => const EditPage(),
        },
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
