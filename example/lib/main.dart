import 'package:example/custom_theme/custom_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CustomTheme lightTheme = const CustomTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      textColor: Colors.black,
      themeName: 'Light',
      actionButtonTheme: ActionButtonTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.black,
          icon: Icons.add));

  CustomTheme darkTheme = const CustomTheme(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.blue,
      textColor: Colors.white,
      textAlign: Alignment.centerRight,
      themeName: 'Dark',
      actionButtonTheme: ActionButtonTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          icon: Icons.add));

  bool isLightTheme = true;

  void switchTheme() {
    setState(() {
      isLightTheme = !isLightTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(extensions: [
        CustomThemeExtension(isLightTheme ? lightTheme : darkTheme)
      ]),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        switchTheme: switchTheme,
        decoration: CustomThemeDecoration(
          themeName: 'Override by decoration'
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.switchTheme,
      this.decoration});
  final String title;
  final Function switchTheme;
  final CustomThemeDecoration? decoration;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    widget.switchTheme();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)
        .customThemeExtension
        .copyWithDecoration(widget.decoration);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.foregroundColor,
        foregroundColor: theme.backgroundColor,
        title: Text(widget.title),
      ),
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: theme.textAlign ?? Alignment.center,
              child: Text(
                'This is ${theme.themeName} theme',
                style: TextStyle(color: theme.textColor),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        foregroundColor: theme.actionButtonTheme.foregroundColor,
        backgroundColor: theme.actionButtonTheme.backgroundColor,
        child: Icon(theme.actionButtonTheme.icon),
      ),
    );
  }
}
