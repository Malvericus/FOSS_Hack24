import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:circular_selector_v2/circular_selector_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Selector Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Circular Selector Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  Function(int) testSelected(int selectorIndex) {
    return (index) {
      if (kDebugMode) {
        print('Selected: $index of selector $selectorIndex');
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Stack(alignment: Alignment.center, children: [
              CircularSelector(
                onSelected: testSelected(0),
                childSize: 30.0,
                radiusDividend: 2.5,
                customOffset: Offset(
                  0.0,
                  AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                ),
                circleBackgroundColor: const Color.fromARGB(255, 85, 85, 85),
                children: const [
                  Icon(Icons.person),
                  Icon(Icons.notifications),
                  Icon(Icons.nightlight),
                  Icon(Icons.volume_up),
                  Icon(Icons.wb_sunny),
                  Icon(Icons.settings)
                ],
              ),
              CircularSelector(
                onSelected: testSelected(2),
                childSize: 30.0,
                radiusDividend: 7,
                customOffset: Offset(
                  0.0,
                  AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                ),
                circleBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
                children: const [Icon(Icons.home_filled), Icon(Icons.logout)],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
