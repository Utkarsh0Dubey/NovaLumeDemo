// dashboard.dart
import 'package:flutter/material.dart';
import 'dashboard_plots.dart'; // Import the dashboard plots file

class Dash_Board extends StatefulWidget {
  const Dash_Board({Key? key}) : super(key: key);

  @override
  State<Dash_Board> createState() => _Dash_BoardState();
}

class _Dash_BoardState extends State<Dash_Board> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  /// Build the static device list widget.
  Widget _buildDeviceList() {
    final devices = [
      "lighting2",
      "lighting5",
      "lighting4",
      "refrigerator",
      "microwave",
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 65),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: List.generate(devices.length, (index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  // Device-specific action if needed.
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          devices[index] == 'refrigerator'
                              ? Icons.kitchen
                              : devices[index] == 'microwave'
                              ? Icons.microwave
                              : Icons.lightbulb,
                          size: 23,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 8),
                        Text(devices[index],
                            style: const TextStyle(color: Colors.black54, fontSize: 17)),
                      ],
                    ),
                    const Icon(Icons.navigate_next, color: Colors.black54, size: 23),
                  ],
                ),
              ),
              if (index != devices.length - 1)
                const Divider(thickness: 1, color: Colors.grey),
            ],
          );
        }),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Additional bottom nav logic if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DashBoard',
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Today"),
            Tab(text: "Week"),
            Tab(text: "Month"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: DashboardBarPlot(period: 'today'),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: DashboardBarPlot(period: 'week'),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: DashboardBarPlot(period: 'month'),
                ),
              ],
            ),
          ),
          _buildDeviceList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
