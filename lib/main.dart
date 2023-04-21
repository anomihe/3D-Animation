import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MyMyDrawer(),
    );
  }
}

class MyMyDrawer extends StatelessWidget {
  const MyMyDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return MyDrawer(
        drawer: Material(
          child: Container(
            color: const Color(0xff24283b),
            child: ListView.builder(
                itemCount: 20,
                padding: const EdgeInsets.only(left: 80, right: 100),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('item $index'),
                  );
                }),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Animated Drawer'),
          ),
          body: Container(
            color: const Color(0xff414868),
          ),
        ));
  }
}

class MyDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  const MyDrawer({super.key, required this.child, required this.drawer});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _xControllerForChild;
  late Animation<double> _yRotationAnimationForChild;
  late AnimationController _xControllerForDrawer;
  late Animation<double> _yRotationAnimationForDrawer;
  @override
  void initState() {
    super.initState();
    _xControllerForChild = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 500),
    );
    _yRotationAnimationForChild = Tween<double>(
      begin: 0.0,
      end: -pi / 2,
    ).animate(_xControllerForChild);
    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 500),
    );
    _yRotationAnimationForDrawer = Tween<double>(
      begin: -pi / 2.7,
      end: 0.0,
    ).animate(_xControllerForDrawer);
  }

  @override
  void dispose() {
    super.dispose();
    _xControllerForChild.dispose();
    _xControllerForDrawer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.8;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _xControllerForChild.value += details.delta.dx / maxDrag;
        _xControllerForDrawer.value += details.delta.dx / maxDrag;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerForChild.value < 0.5) {
          _xControllerForChild.reverse();
          _xControllerForDrawer.reverse();
        } else {
          _xControllerForChild.forward();
          _xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
          animation: Listenable.merge([
            _xControllerForChild,
            _xControllerForDrawer,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  color: const Color(0xFF1a1b26),
                ),
                Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(_xControllerForChild.value * maxDrag)
                      ..rotateY(_yRotationAnimationForChild.value),
                    alignment: Alignment.centerLeft,
                    child: widget.child),
                Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(
                          -screenWidth + _xControllerForDrawer.value * maxDrag)
                      ..rotateY(_yRotationAnimationForDrawer.value),
                    alignment: Alignment.centerRight,
                    child: widget.drawer),
              ],
            );
          }),
    );
  }
}
