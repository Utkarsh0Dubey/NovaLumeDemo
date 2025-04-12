import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import your external screens.
import 'add_post.dart';
import 'meter.dart';
import 'dashboard.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

/// Top-level widget, wrapping your app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gradient Navbar App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(), // This should match your main screen name.
    );
  }
}

/// HomeScreen is now the main widget managing bottom navigation.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  /// List of pages (first page is our bubble plot page).
  final List<Widget> _pages = const [
    HomeScreenBody(),
    Meter(),       // Provided in meter.dart
    Dash_Board(), // Provided in dashboard.dart
    ProfilePage(),   // Provided in profile_page.dart
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
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
}

/// The stateful widget representing the home page with bubble plot and list.
class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  List<BubbleData> bubbles = [];
  Timer? _pollTimer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    // Initial fetch of device data from Supabase.
    fetchDeviceData();
    // Poll the unified table every 3 seconds for real-time updates.
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchDeviceData();
    });
  }

  /// Fetch data from the unified table "device_data" and map it to BubbleData.
  Future<void> fetchDeviceData() async {
    try {
      // Using the new Supabase Flutter API: select() returns a List<dynamic> or null.
      final dataList = await Supabase.instance.client
          .from('device_data')
          .select() as List<dynamic>?;

      if (dataList == null) {
        print('Error fetching data: returned null');
        return;
      }

      // Convert each record into a BubbleData object.
      final newBubbles = dataList.map((e) {
        final double consumption = (e['consumption'] as num).toDouble();
        final double bubbleSize = _computeBubbleSize(consumption);
        return BubbleData(
          deviceId: e['device_id'] as String,
          label: e['bubble_label'] as String,
          size: bubbleSize,
          color: (e['bubble_color'] != null)
              ? _hexToColor(e['bubble_color'] as String)
              : Colors.grey,
        );
      }).toList();

      // Update our bubble list and reassign random positions.
      setState(() {
        bubbles = newBubbles;
        _assignNonOverlappingPositions();
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  /// Compute bubble size dynamically from consumption.
  /// For example, scale a consumption value between 0 and 200 to a size between 50 and 150.
  double _computeBubbleSize(double consumption) {
    final double size = 50 + 100 * (consumption / 200);
    return size.clamp(50, 150);
  }

  /// Convert a HEX color string (e.g. "#EBA2A3") to a Flutter Color.
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF' + hex; // add opacity if needed.
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Reassign random positions for each bubble using limited collision detection attempts.
  void _assignNonOverlappingPositions() {
    const int containerSize = 400; // Container dimensions.
    const int padding = 10; // Padding to avoid collisions.
    final List<Point<int>> positions = [];

    for (var bubble in bubbles) {
      bool hasCollision = false;
      int x = 0, y = 0;
      const int maxAttempts = 100;
      int attempt = 0;
      do {
        hasCollision = false;
        attempt++;
        x = random.nextInt(containerSize - bubble.size.toInt());
        y = random.nextInt(containerSize - bubble.size.toInt());
        for (var pos in positions) {
          double distance = sqrt(pow(pos.x - x, 2) + pow(pos.y - y, 2));
          final minDist = (bubble.size / 2) + padding;
          if (distance < minDist) {
            hasCollision = true;
            break;
          }
        }
        if (attempt >= maxAttempts && hasCollision) {
          print("Warning: couldn't place ${bubble.deviceId} without overlap. Forcing position with possible overlap.");
          hasCollision = false;
        }
      } while (hasCollision && attempt < maxAttempts);
      bubble.x = x;
      bubble.y = y;
      positions.add(Point<int>(x, y));
    }
  }

  /// Called when a bubble is tapped.
  void _onBubbleTapped(BubbleData bubble) {
    _showComparisonSheet(context, bubble);
  }

  /// Displays a bottom sheet with details about the tapped device.
  void _showComparisonSheet(BuildContext context, BubbleData bubble) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Device Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("You tapped on: ${bubble.label}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: bubble.color)),
                  Text("Bubble Size: ${bubble.size.toStringAsFixed(1)}", style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final email = session?.user?.email ?? 'No email found';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text('  N ', style: TextStyle(color: Colors.white, fontSize: 29)),
                Icon(Icons.lightbulb, color: Colors.white, size: 30),
                Text(' V A L U M E ', style: TextStyle(color: Colors.white, fontSize: 29)),
              ],
            ),
            Row(
              children: [
                Tooltip(
                  message: 'Post your own stories',
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline_outlined, color: Colors.white, size: 30),
                    onPressed: () {
                      // Navigate to the AddPost screen imported from add_post.dart.
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddPost()));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.notifications, size: 30, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        color: Colors.white30,
        child: Column(
          children: [
            // Bubble plot container.
            SizedBox(
              height: 400,
              width: 400,
              child: Stack(
                children: bubbles.map((bubble) {
                  return AnimatedPositioned(
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    left: bubble.x.toDouble(),
                    top: bubble.y.toDouble(),
                    child: BubbleWidget(onTap: () => _onBubbleTapped(bubble), bubble: bubble),
                  );
                }).toList(),
              ),
            ),
            const Divider(color: Colors.black54, thickness: 2),
            // Example list view with dismissible items.
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('unique_item_$index'),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.black),
                    ),
                    onDismissed: (direction) {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black12, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const ListTile(
                        tileColor: Colors.transparent,
                        title: Text('List Tile '),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model representing each device (mapped from a row in "device_data").
class BubbleData {
  final String deviceId;
  final String label;
  double size;
  Color color;
  int x; // x-coordinate for positioning
  int y; // y-coordinate for positioning

  BubbleData({
    required this.deviceId,
    required this.label,
    required this.size,
    required this.color,
    this.x = 0,
    this.y = 0,
  });
}

/// A widget to display a bubble with its label.
class BubbleWidget extends StatelessWidget {
  final BubbleData bubble;
  final VoidCallback onTap;
  const BubbleWidget({required this.bubble, required this.onTap, super.key});
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
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
