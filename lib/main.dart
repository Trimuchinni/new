import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'drawingArea.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Painter Example',
      home: FlipBook(),
    );
  }
}

class FlipBook extends StatefulWidget {
  const FlipBook({Key? key}) : super(key: key);

  @override
  _FlipBookState createState() => _FlipBookState();
}

class _FlipBookState extends State<FlipBook> {
  List<CustomPaint> paintList = [];
  List<DrawingArea> points = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.teal,
            child: GestureDetector(
              onPanDown: (details) {
                setState(() {
                  points.add(
                    DrawingArea(
                        coordinate: details.localPosition,
                        areaPaint: Paint()
                          ..strokeCap = StrokeCap.round
                          ..isAntiAlias = true
                          ..color = Colors.red
                          ..strokeWidth = 5),
                  );
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  points.add(
                    DrawingArea(
                        coordinate: details.localPosition,
                        areaPaint: Paint()
                          ..strokeCap = StrokeCap.round
                          ..isAntiAlias = true
                          ..color = Colors.red
                          ..strokeWidth = 5),
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(
                      DrawingArea(coordinate: Offset.zero, areaPaint: Paint()));
                });
              },
              child: Column(
                  children: [
                        CustomPaint(
                          painter: FlipPainter(coordinates: points, tt: 0),
                          size: Size(
                              720 / MediaQuery.of(context).devicePixelRatio,
                              720 / MediaQuery.of(context).devicePixelRatio),
                        ),
                      ] +
                      paintList),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                  child: const Icon(Icons.clear),
                  onPressed: () {
                    points.clear();
                  }),
              FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    addStackEle();
                  }),
            ],
          )
        ],
      ),
    );
  }

  addStackEle() {
    setState(() {
      paintList.add(stackEle());
    });

    log(paintList.length.toString() + "len");
  }

  CustomPaint stackEle() {
    return CustomPaint(
      painter: FlipPainter(coordinates: points, tt: paintList.length + 1),
      size: Size(720 / MediaQuery.of(context).devicePixelRatio,
          720 / MediaQuery.of(context).devicePixelRatio),
    );
  }
}

class FlipPainter extends CustomPainter {
  List<DrawingArea> coordinates;
  int tt;
  FlipPainter({required this.coordinates, required this.tt});

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.saveLayer(Offset.zero & size, Paint());
    // canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height),
    //     Paint()..color = Colors.black);
    if (tt <= 0) {
      for (int x = 0; x < coordinates.length - 1; x++) {
        if (coordinates[x].coordinate != Offset.zero &&
            coordinates[x + 1].coordinate != Offset.zero) {
          Paint paint = coordinates[x].areaPaint;
          canvas.drawLine(
              coordinates[x].coordinate, coordinates[x + 1].coordinate, paint);
        } else if (coordinates[x].coordinate != Offset.zero &&
            coordinates[x + 1].coordinate == Offset.zero) {
          Paint paint = coordinates[x].areaPaint;
          canvas.drawPoints(
              PointMode.points, [coordinates[x].coordinate], paint);
        }
      }
    }
    //log(coordinates.length.toString() + "mid");
    //
    //canvas.restore();
    // canvas.drawPath(path, paint)
    if (tt > 0) {
      // log(tt.toString() + "in paint");
      // log(coordinates.length.toString() + "ll");
      for (int x = 0; x < coordinates.length - 1; x++) {
        if (coordinates[x].coordinate != Offset.zero &&
            coordinates[x + 1].coordinate != Offset.zero) {
          Paint paint = Paint()..color = Colors.yellow;
          // log(paint.color.toString());
          canvas.drawLine(
              coordinates[x].coordinate, coordinates[x + 1].coordinate, paint);
        } else if (coordinates[x].coordinate != Offset.zero &&
            coordinates[x + 1].coordinate == Offset.zero) {
          Paint paint = Paint()..color = Colors.yellow;
          canvas.drawPoints(
              PointMode.points, [coordinates[x].coordinate], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
