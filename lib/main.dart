import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'locator.dart';
import 'stores/task_store.dart';
import 'screens/splash_screen.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskStore>(create: (_) => getIt<TaskStore>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Potato Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
