// The listTile area will have the recommendations and the always on thingy
// While the bell icon is for the notifications

 import 'package:auth_demo/Add_Post.dart';
import 'package:auth_demo/Meter.dart';
import 'package:auth_demo/dashboard.dart';
import 'package:auth_demo/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gradient Navbar App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home_Screen(),
    );
  }
}

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Meter()));
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dash_Board()),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

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
      BubbleData(label: 'Ac ( living ) ', size: 150,  color: Color( 0xFFEBA2A3) ),
      BubbleData(label: 'Ac ( Dining ) ', size: 100, color: Color( 0xFFEBA2A3)),
      BubbleData(label: ' Geyser ', size: 140,   color: Color( 0xFFD8BEAD)),
      BubbleData(label: ' Refrigerator ', size: 110, color: Color(0xFFEBDDD0)),
      BubbleData(label: ' Washing Machine ', size: 100, color: Color(0xFFF4C2C2)),
      BubbleData(label: ' Add Device +  ', size: 100, color: Color( 0xFFF4C2C2)),
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
    final session = Supabase.instance.client.auth.currentSession;
    final email = session?.user?.email ?? 'No email found';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( backgroundColor: Colors.brown, title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(
              '  N ',
              style: GoogleFonts.raleway(
                  color: Colors.white,

                  fontSize: 29),
            ),
            Icon(Icons.lightbulb, color: Colors.white, size: 30),
            Text(
              ' V A L U M E ',
              style: GoogleFonts.raleway(
                  color: Colors.white,

                  fontSize: 29),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Tooltip(
                message: ' Post your own stories',
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outline_outlined,
                      color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Add_Post()));
                  },
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                  onTap: () {},
                  child: Icon(Icons.notifications,
                      size: 30, color: Colors.white))
            ],
          ),
        ],
      ), ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        color: Colors.white30,
        child: Column(
          children: [
            Container(
              height: 400,
              width: 400,
              child: Stack(
                children: bubbles.map((bubble) {
                  return AnimatedPositioned(
                    duration: Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    left: bubble.x.toDouble(),
                    top: bubble.y.toDouble(),
                    child: BubbleWidget(
                      onTap: () => _onBubbleTapped(bubble),
                      bubble: bubble,
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(
              color: Colors.black54,
              thickness: 2,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('unique_item_$index'),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black12, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        tileColor: Colors.transparent,
                        title: const Text('List Tile '),
                      ),
                    ),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.black),
                    ),
                    onDismissed: (direction) {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[400],
            selectedFontSize: 14,
            unselectedFontSize: 12,
            iconSize: 28,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Metrics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _onBubbleTapped(BubbleData bubble) {
    _showComparisonSheet( context, bubble);
  }

  void _showComparisonSheet(BuildContext context, BubbleData bubble) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Bubble Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "You tapped on: ${bubble.label}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bubble.color,
                    ),
                  ),
                  Text(
                    "Size: ${bubble.size}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
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
  final VoidCallback onTap;

  const BubbleWidget({required this.bubble, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: bubble.size,
        height: bubble.size,
        decoration: BoxDecoration(
          color: bubble.color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          bubble.label,
          style: TextStyle(
            color: Colors.black, // Change this to any color you want
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

