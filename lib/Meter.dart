import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

void main() {
  runApp(const Meter());
}

/// Main Meter widget.
class Meter extends StatelessWidget {
  const Meter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Global theme.
      theme: ThemeData(
        textTheme: GoogleFonts.notoSerifTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MeterScreen(),
    );
  }
}

/// Model representing one record from total_timeseries_data.
class TotalDataPoint {
  final DateTime timestamp;
  final double totalConsumption;
  TotalDataPoint({required this.timestamp, required this.totalConsumption});
}

/// MeterScreen displays the battery/current usage info and an animated
/// time-series line chart of total consumption.
class MeterScreen extends StatefulWidget {
  const MeterScreen({super.key});

  @override
  State<MeterScreen> createState() => _MeterScreenState();
}

class _MeterScreenState extends State<MeterScreen> {
  // 0: Day, 1: Week, 2: Month.
  int _selectedRangeIndex = 0;
  // This list holds raw high-frequency records from the table.
  List<TotalDataPoint> _rawDataPoints = [];
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Poll the table every 10 seconds.
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchData();
    });
  }

  /// Fetch raw data from the table and filter locally by the desired cutoff.
  Future<void> _fetchData() async {
    try {
      // Determine the cutoff for the selected range.
      Duration duration;
      if (_selectedRangeIndex == 0) {
        duration = const Duration(days: 1);
      } else if (_selectedRangeIndex == 1) {
        duration = const Duration(days: 7);
      } else {
        duration = const Duration(days: 30);
      }
      DateTime cutoff = DateTime.now().subtract(duration);

      final response = await Supabase.instance.client
          .from('total_timeseries_data')
          .select('*')
          .order('timestamp', ascending: true) as List<dynamic>?;

      if (response == null) {
        print('Error: Query returned null.');
        return;
      }

      List<TotalDataPoint> fetched = [];
      for (var row in response) {
        DateTime ts = DateTime.parse(row['timestamp'] as String);
        if (ts.isAfter(cutoff)) {
          fetched.add(TotalDataPoint(
              timestamp: ts,
              totalConsumption: (row['total_consumption'] as num).toDouble()));
        }
      }

      setState(() {
        _rawDataPoints = fetched;
      });
    } catch (e) {
      print("Error fetching total timeseries data: $e");
    }
  }

  /// Depending on the selected range, aggregate the raw data.
  /// For Day view: group records by hour.
  /// For Week view: group records by day.
  /// For Month view: group records by week (7-day chunks).
  List<TotalDataPoint> _aggregateData() {
    if (_rawDataPoints.isEmpty) return [];

    List<TotalDataPoint> aggregated = [];
    if (_selectedRangeIndex == 0) {
      // Day view: group by hour.
      Map<int, List<double>> hourGroups = {};
      for (var point in _rawDataPoints) {
        int hour = point.timestamp.hour;
        hourGroups.putIfAbsent(hour, () => []).add(point.totalConsumption);
      }
      hourGroups.forEach((hour, values) {
        double sum = values.reduce((a, b) => a + b);
        // You may choose average instead of sum. Here we use sum.
        DateTime dt = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, hour);
        aggregated.add(TotalDataPoint(timestamp: dt, totalConsumption: sum));
      });
      aggregated.sort((a, b) => a.timestamp.hour.compareTo(b.timestamp.hour));
    } else if (_selectedRangeIndex == 1) {
      // Week view: group by day.
      Map<String, List<double>> dayGroups = {};
      for (var point in _rawDataPoints) {
        String key = DateFormat('yyyy-MM-dd').format(point.timestamp);
        dayGroups.putIfAbsent(key, () => []).add(point.totalConsumption);
      }
      dayGroups.forEach((key, values) {
        double sum = values.reduce((a, b) => a + b);
        DateTime dt = DateTime.parse(key);
        aggregated.add(TotalDataPoint(timestamp: dt, totalConsumption: sum));
      });
      aggregated.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else {
      // Month view: group by week (chunks of 7 consecutive days).
      List<TotalDataPoint> sorted = List.from(_rawDataPoints);
      sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      for (int i = 0; i < sorted.length; i += 7) {
        int end = min(i + 7, sorted.length);
        double sum = sorted
            .sublist(i, end)
            .map((p) => p.totalConsumption)
            .reduce((a, b) => a + b);
        aggregated.add(TotalDataPoint(timestamp: sorted[i].timestamp, totalConsumption: sum));
      }
    }
    return aggregated;
  }

  /// Returns the animation duration based on the selected range.
  Duration get _animationDuration {
    if (_selectedRangeIndex == 0) return const Duration(seconds: 2);
    if (_selectedRangeIndex == 1) return const Duration(seconds: 4);
    return const Duration(seconds: 6);
  }

  /// Build a custom navigation item.
  Widget _buildNavItem(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRangeIndex = index;
        });
        _fetchData(); // Re-fetch data when the range changes.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _selectedRangeIndex == index ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  /// Build the animated line chart using TweenAnimationBuilder.
  Widget _buildLineChart() {
    List<TotalDataPoint> aggregatedData = _aggregateData();
    if (aggregatedData.isEmpty) return const Center(child: CircularProgressIndicator());
    int n = aggregatedData.length;
    double maxX = (n - 1).toDouble();
    double maxY = aggregatedData.map((e) => e.totalConsumption).reduce(max);
    double margin = maxY * 0.1;
    maxY = ((maxY + margin) / 10).ceil() * 10.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: _animationDuration,
      builder: (context, t, child) {
        List<FlSpot> spots = [];
        for (int i = 0; i < n; i++) {
          double animatedValue = aggregatedData[i].totalConsumption * t;
          spots.add(FlSpot(i.toDouble(), animatedValue));
        }
        return SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: true),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int idx = value.toInt();
                      if (idx < 0 || idx >= n) return const SizedBox.shrink();
                      String label = '';
                      if (_selectedRangeIndex == 0) {
                        // Day view: label with hour.
                        label = DateFormat.Hm().format(aggregatedData[idx].timestamp);
                      } else if (_selectedRangeIndex == 1) {
                        // Week view: label with month and day.
                        label = DateFormat.MMMd().format(aggregatedData[idx].timestamp);
                      } else {
                        // Month view: label as Week number.
                        label = 'Week ${idx + 1}';
                      }
                      return Text(label, style: GoogleFonts.notoSerif(fontSize: 12));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.2,
                  color: Colors.brown,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build battery/current usage section (unchanged).
  Widget _buildBatterySection() {
    double batteryLevel = 0.4;
    int totalBars = 15;
    int filledBars = (batteryLevel * totalBars).round();
    Color batteryColorStart;
    Color batteryColorEnd;
    if (batteryLevel > 0.6) {
      batteryColorStart = Colors.green;
      batteryColorEnd = Colors.lightGreen;
    } else if (batteryLevel > 0.3) {
      batteryColorStart = Colors.yellow;
      batteryColorEnd = Colors.orange;
    } else {
      batteryColorStart = Colors.red;
      batteryColorEnd = Colors.orangeAccent;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          padding: const EdgeInsets.all(10),
          width: 190,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.brown, Color(0xFFC8AB99)],
            ),
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: const [
              Text(
                'Current Usage',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(thickness: 2, color: Colors.black),
              Text(
                '75 KWh',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          width: 200,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(totalBars, (index) {
              return Container(
                width: 8,
                height: 64,
                decoration: BoxDecoration(
                  gradient: index < filledBars
                      ? LinearGradient(
                    colors: [batteryColorStart, batteryColorEnd],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : null,
                  color: index >= filledBars ? Colors.white : null,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Row(
          children: [
            InkWell(
              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            const SizedBox(width: 20),
            Text(
              'Meter',
              style: GoogleFonts.notoSerif(
                textStyle: const TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBatterySection(),
            const SizedBox(height: 30),
            // Time series graph section.
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    "Total Consumption",
                    style: GoogleFonts.notoSerif(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Custom navbar for Day/Week/Month.
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem("Day", 0),
                        _buildNavItem("Week", 1),
                        _buildNavItem("Month", 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLineChart(),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // (Optional) Additional UI, such as comparison sections, can follow.
          ],
        ),
      ),
    );
  }
}
