import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'NotificationsService.dart';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Dash_Board(),
      theme: ThemeData(
        textTheme: GoogleFonts.notoSerifTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Dash_Board extends StatefulWidget {
  const Dash_Board({super.key});
  @override
  State<Dash_Board> createState() => _Dash_BoardState();
}

class _Dash_BoardState extends State<Dash_Board> {
  int _selectedTab = 0; // 0: Day, 1: Week, 2: Month
  List<DeviceData> _deviceData = [];
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    fetchChartData();
    // Poll every 5 seconds; adjust interval if needed.
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchChartData();
    });
  }

  Future<void> fetchChartData() async {
    try {
      // Query daily_device_data table.
      final dataList = await Supabase.instance.client
          .from('daily_device_data')
          .select() as List<dynamic>?;

      if (dataList == null) {
        print('Error: Query returned null');
        return;
      }

      final List<DeviceData> devices = dataList.map((e) {
        return DeviceData(
          deviceId: e['device_id'] as String,
          consumption: (e['consumption'] as num).toDouble(),
        );
      }).toList();

      setState(() {
        _deviceData = devices;
      });
    } catch (error) {
      print("Error fetching chart data: $error");
    }
  }

  /// Compute a dynamic maximum Y value based on the selected factor.
  double _getMaxY(double factor) {
    if (_deviceData.isEmpty) return 100;
    double maxValue = _deviceData
        .map((d) => d.consumption * factor)
        .reduce(max);
    // Add a 10% margin.
    double margin = maxValue * 0.1;
    // Round up to the nearest multiple of 10.
    return ((maxValue + margin) / 10).ceil() * 10.0;
  }

  /// Build bar chart groups for each device.
  List<BarChartGroupData> _getChartData() {
    double factor;
    if (_selectedTab == 0) {
      factor = 1;
    } else if (_selectedTab == 1) {
      factor = 7;
    } else {
      factor = 30;
    }

    List<BarChartGroupData> groups = [];
    for (int i = 0; i < _deviceData.length; i++) {
      final device = _deviceData[i];
      double value = device.consumption * factor;
      groups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
              toY: value,
              color: Colors.brown,
              width: 20,
            )
          ],
        ),
      );
    }
    return groups;
  }

  /// Navbar item builder for Day, Week, Month.
  Widget _buildNavBarItem(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _selectedTab == index ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For demonstration, static texts are used for "XYZ Kwh" etc.
    double factor = (_selectedTab == 0)
        ? 1
        : (_selectedTab == 1)
        ? 7
        : 30;

    return Scaffold(
      backgroundColor: const Color(0xFFD8BEAD),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.brown,
        title: Text(
          'Dashboard',
          style: GoogleFonts.notoSerif(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Container showing overall consumption and the chart.
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEBDDD0),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Avg Consumption",
                  style: GoogleFonts.notoSerif(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // You may calculate a true average from _deviceData if needed.
                    Text(
                      "XYZ Kwh",
                      style: GoogleFonts.notoSerif(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.arrow_circle_down_rounded, size: 20),
                        Text(
                          "14% less usage",
                          style: GoogleFonts.notoSerif(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Animated chart that changes as you switch tabs.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (widget, animation) => FadeTransition(
                    opacity: animation,
                    child: widget,
                  ),
                  child: SizedBox(
                    height: 200,
                    key: ValueKey<int>(_selectedTab),
                    child: _deviceData.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _getMaxY(factor),
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                int index = value.toInt();
                                if (index < 0 || index >= _deviceData.length) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  _deviceData[index].deviceId,
                                  style: GoogleFonts.notoSerif(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        barGroups: _getChartData(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Navbar for Day, Week, Month.
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavBarItem("Day", 0),
                _buildNavBarItem("Week", 1),
                _buildNavBarItem("Month", 2),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Comparison section with multiple InkWell rows.
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: 220,
            width: 400,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
              color: const Color(0xFFEBDDD0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _showComparisonSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.ac_unit_outlined, size: 23, color: Colors.black),
                          Text(
                            ' Air Conditioning ( Living ) ',
                            style: GoogleFonts.notoSerif(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),
                InkWell(
                  onTap: () {
                    _showComparisonSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.ac_unit_outlined, size: 23, color: Colors.black),
                          Text(
                            ' Air Conditioning ( Dining ) ',
                            style: GoogleFonts.notoSerif(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),
                InkWell(
                  onTap: () {
                    _showComparisonSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, size: 23, color: Colors.black),
                          Text(
                            ' Geyser ( Common ) ',
                            style: GoogleFonts.notoSerif(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),
                InkWell(
                  onTap: () {
                    _showComparisonSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.severe_cold, size: 23, color: Colors.black),
                          Text(
                            ' Refrigerator ',
                            style: GoogleFonts.notoSerif(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),
                InkWell(
                  onTap: () {
                    _showComparisonSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.water_drop, size: 23, color: Colors.black),
                          Text(
                            ' Washing Machine ',
                            style: GoogleFonts.notoSerif(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                      const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

/// Helper method to show comparison details in a bottom sheet.
void _showComparisonSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Comparison Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, size: 24, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text('Here you can compare energy consumption over time.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    },
  );
}

/// Model to hold daily consumption for each device.
class DeviceData {
  final String deviceId;
  final double consumption;
  DeviceData({required this.deviceId, required this.consumption});
}
