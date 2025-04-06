
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(Check());

class Check extends StatefulWidget {
  @override
  _BubbleChartAppState createState() => _BubbleChartAppState();
}

class _BubbleChartAppState extends State<Check> {
  final Random random = Random();
  List<BubbleData> bubbles = [];

  @override
  void initState() {
    super.initState();
    _generateBubbles();
    _startBubbleAnimation();
  }

  void _generateBubbles() {
    bubbles = [
      BubbleData(label: 'One', size: 150, color: Colors.blue),
      BubbleData(label: 'Two', size: 100, color: Colors.red),
      BubbleData(label: 'Three', size: 140, color: Colors.green),
      BubbleData(label: 'Four', size: 110, color: Colors.orange),
      BubbleData(label: 'Five', size: 90, color: Colors.purple),
      BubbleData(label: 'Six', size: 80, color: Colors.yellow),
    ];

    _assignNonOverlappingPositions();
  }

  void _assignNonOverlappingPositions() {
    const int containerSize = 400; // Define container limits
    const int padding = 10; // Space between bubbles
    List<Point> positions = [];

    for (var bubble in bubbles) {
      bool hasCollision;
      int x, y;

      do {
        hasCollision = false;
        x = random.nextInt(containerSize - bubble.size.toInt());
        y = random.nextInt(containerSize - bubble.size.toInt());

        for (var pos in positions) {
          double distance = sqrt(pow(pos.x - x, 2) + pow(pos.y - y, 2));
          if (distance < bubble.size + padding) { // Check if too close
            hasCollision = true;
            break;
          }
        }
      } while (hasCollision);

      bubble.x = x;
      bubble.y = y;
      positions.add(Point(x, y)); // Store the new position
    }
  }

  void _startBubbleAnimation() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _assignNonOverlappingPositions(); // Recalculate positions
      });
      _startBubbleAnimation(); // Loop the animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Animated Non-Overlapping Bubbles')),
        body: Center(
          child: Container(
            height: 400,
            width: 400,
            child: Stack(
              children: bubbles.map((bubble) {
                return AnimatedPositioned(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  left: bubble.x.toDouble(),
                  top: bubble.y.toDouble(),
                  child: BubbleWidget(bubble: bubble),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleData {
  String label;
  double size;
  int x = 0, y = 0;
  Color color;

  BubbleData({required this.label, required this.size, required this.color});
}

class BubbleWidget extends StatelessWidget {
  final BubbleData bubble;

  const BubbleWidget({required this.bubble});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: bubble.size,
      height: bubble.size,
      decoration: BoxDecoration(
        color: bubble.color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        bubble.label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
