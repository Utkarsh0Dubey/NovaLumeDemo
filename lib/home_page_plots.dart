import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Model class representing one row of your device data.
class DeviceData {
  final DateTime time;
  final int lighting2;
  final int lighting5;
  final int lighting4;
  final int refrigerator;
  final int microwave;

  DeviceData({
    required this.time,
    required this.lighting2,
    required this.lighting5,
    required this.lighting4,
    required this.refrigerator,
    required this.microwave,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      time: DateTime.fromMillisecondsSinceEpoch((json['time'] as int) * 1000),
      lighting2: json['lighting2'] as int,
      lighting5: json['lighting5'] as int,
      lighting4: json['lighting4'] as int,
      refrigerator: json['refrigerator'] as int,
      microwave: json['microwave'] as int,
    );
  }
}

/// A widget that fetches device data for the current user from Supabase
/// and displays an animated bar chart.
class HomePageBarPlot extends StatefulWidget {
  const HomePageBarPlot({Key? key}) : super(key: key);

  @override
  _HomePageBarPlotState createState() => _HomePageBarPlotState();
}

class _HomePageBarPlotState extends State<HomePageBarPlot> {
  List<DeviceData> _deviceData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeviceData();
  }

  Future<void> fetchDeviceData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print("No user logged in.");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final userId = user.id;
    print("Fetching data for user: $userId");

    try {
      final response = await Supabase.instance.client
          .from('user_device_data')
          .select()
          .eq('user_id', userId);
      print("Data fetched: $response");
      List<dynamic> dataList = response as List<dynamic>;
      List<DeviceData> fetchedData = dataList
          .map((e) => DeviceData.fromJson(e as Map<String, dynamic>))
          .toList();
      print("Parsed ${fetchedData.length} records.");
      setState(() {
        _deviceData = fetchedData;
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Build bar groups – each group represents one record (row) and shows five bars.
  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < _deviceData.length; i++) {
      final data = _deviceData[i];
      groups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 50, // space between bars in a group
          barRods: [
            // lighting2 bar (brown)
            BarChartRodData(
              toY: data.lighting2.toDouble(),
              color: Colors.brown,
              width: 30, // make bars wider
              borderRadius: BorderRadius.zero,
            ),
            // lighting5 bar (green)
            BarChartRodData(
              toY: data.lighting5.toDouble(),
              color: Colors.green,
              width: 30,
              borderRadius: BorderRadius.zero,
            ),
            // lighting4 bar (brown)
            BarChartRodData(
              toY: data.lighting4.toDouble(),
              color: Colors.brown,
              width: 30,
              borderRadius: BorderRadius.zero,
            ),
            // refrigerator bar (green)
            BarChartRodData(
              toY: data.refrigerator.toDouble(),
              color: Colors.green,
              width: 30,
              borderRadius: BorderRadius.zero,
            ),
            // microwave bar (brown)
            BarChartRodData(
              toY: data.microwave.toDouble(),
              color: Colors.brown,
              width: 30,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }
    return groups;
  }

  /// Compute a "nice" maximum y-value so that the tallest bar isn’t cut off.
  double _getNiceMaxY() {
    if (_deviceData.isEmpty) return 10;
    // Find the highest reading in any row.
    double rawMax = 0;
    for (var data in _deviceData) {
      final rowMax = [
        data.lighting2,
        data.lighting5,
        data.lighting4,
        data.refrigerator,
        data.microwave
      ]
          .map((e) => e.toDouble())
          .reduce((a, b) => a > b ? a : b);
      if (rowMax > rawMax) rawMax = rowMax;
    }
    // Scale up by 20% so there's extra space above the tallest bar.
    double scaledMax = rawMax * 1.2;
    // Round up to the nearest multiple of 5.
    double niceMax = (scaledMax / 5).ceil() * 5;
    // Ensure at least 10.
    return niceMax < 10 ? 10 : niceMax;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_deviceData.isEmpty) {
      return const Center(child: Text("No data found."));
    }

    // Build the groups and fix the maxY to maintain axis scaling.
    List<BarChartGroupData> groups = _buildBarGroups();
    double maxY = _getNiceMaxY();

    return SizedBox(
      height: 300, // More vertical space so bars and labels are visible.
      width: double.infinity,
      // Wrap the BarChart in a TweenAnimationBuilder to animate bars growing.
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
        builder: (context, factor, child) {
          // Multiply each bar’s height (toY) by the current animation factor.
          List<BarChartGroupData> animatedGroups = groups.map((group) {
            return BarChartGroupData(
              x: group.x,
              barsSpace: group.barsSpace,
              barRods: group.barRods.map((rod) {
                return BarChartRodData(
                  toY: rod.toY * factor,
                  color: rod.color,
                  width: rod.width,
                  borderRadius: rod.borderRadius,
                );
              }).toList(),
            );
          }).toList();

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              groupsSpace: 25, // spacing between groups
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= _deviceData.length) {
                        return const SizedBox.shrink();
                      }
                      final label =
                      DateFormat('MM-dd').format(_deviceData[index].time);
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(label,
                            style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
              barGroups: animatedGroups,
            ),
          );
        },
      ),
    );
  }
}
