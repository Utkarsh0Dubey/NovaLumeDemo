// dashboard_plots.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// DashboardBarPlot widget:
/// - Fetches all data from the 'energy_readings' table.
/// - Computes "now" as the maximum timestamp in the data (or DateTime.now() if no data).
/// - Sets a time window based on widget.period:
///   • "today": 24 hours (grouped in 4-hour intervals; 6 bins)
///   • "week": Last 7 days (grouped daily)
///   • "month": Last 30 days (grouped in 7-day intervals)
/// - Aggregates the five device columns into bins and displays a grouped bar chart
///   with rectangular bars and a left axis titled "Energy (kWh)".
/// - Uses a TweenAnimationBuilder to animate the bars “growing” from 0.
class DashboardBarPlot extends StatefulWidget {
  final String period; // "today", "week", or "month"
  const DashboardBarPlot({Key? key, required this.period}) : super(key: key);

  @override
  _DashboardBarPlotState createState() => _DashboardBarPlotState();
}

class _DashboardBarPlotState extends State<DashboardBarPlot> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;
  DateTime? _startWindow;
  DateTime? _endWindow;
  Duration? _groupDuration;

  @override
  void initState() {
    super.initState();
    fetchDataAndComputeWindow();
  }

  /// Fetch all rows from Supabase and then compute "now" as the maximum timestamp from the data.
  /// The time window and grouping duration are then set based on widget.period.
  Future<void> fetchDataAndComputeWindow() async {
    final response = await Supabase.instance.client.from('energy_readings').select();
    print("[${widget.period}] Raw response from Supabase: $response");
    if (response is List) {
      _data = response.map((e) => e as Map<String, dynamic>).toList();
      print("[${widget.period}] Fetched ${_data.length} rows.");
    } else {
      print("[${widget.period}] Unexpected response type: ${response.runtimeType}");
    }
    // Compute "now" as the maximum timestamp in the data (if available), otherwise use current time.
    DateTime computedNow;
    if (_data.isNotEmpty) {
      List<DateTime> timestamps = _data.map((row) => DateTime.parse(row['timestamp'])).toList();
      timestamps.sort();
      computedNow = timestamps.last;
    } else {
      computedNow = DateTime.now();
    }
    print("[${widget.period}] Computed now = $computedNow");

    // Set time window and grouping based on period.
    if (widget.period == 'today') {
      _startWindow = DateTime(computedNow.year, computedNow.month, computedNow.day);
      _endWindow = _startWindow!.add(const Duration(days: 1));
      _groupDuration = const Duration(hours: 4); // 4-hour intervals for today → 6 bins
    } else if (widget.period == 'week') {
      _startWindow = computedNow.subtract(const Duration(days: 7));
      _endWindow = computedNow;
      _groupDuration = const Duration(days: 1); // daily groups
    } else {
      // "month"
      _startWindow = computedNow.subtract(const Duration(days: 30));
      _endWindow = computedNow;
      _groupDuration = const Duration(days: 7); // weekly groups
    }
    print("[${widget.period}] Using time window: ${_startWindow!.toIso8601String()} to ${_endWindow!.toIso8601String()}");

    setState(() {
      _isLoading = false;
    });
  }

  /// Build bar groups by grouping data into bins based on the computed time window.
  /// Each bin will have five bars (one per device).
  List<BarChartGroupData> buildBarGroups() {
    Map<int, Map<String, double>> grouped = {};
    for (var row in _data) {
      DateTime ts = DateTime.parse(row['timestamp']);
      int bin = ts.difference(_startWindow!).inSeconds ~/ _groupDuration!.inSeconds;
      if (!grouped.containsKey(bin)) {
        grouped[bin] = {
          'lighting2': 0.0,
          'lighting5': 0.0,
          'lighting4': 0.0,
          'refrigerator': 0.0,
          'microwave': 0.0,
        };
      }
      grouped[bin]!['lighting2'] = grouped[bin]!['lighting2']! + (row['lighting2'] as int).toDouble();
      grouped[bin]!['lighting5'] = grouped[bin]!['lighting5']! + (row['lighting5'] as int).toDouble();
      grouped[bin]!['lighting4'] = grouped[bin]!['lighting4']! + (row['lighting4'] as int).toDouble();
      grouped[bin]!['refrigerator'] = grouped[bin]!['refrigerator']! + (row['refrigerator'] as int).toDouble();
      grouped[bin]!['microwave'] = grouped[bin]!['microwave']! + (row['microwave'] as int).toDouble();
    }
    print("[${widget.period}] Grouped Data: $grouped");
    int totalBins = _endWindow!.difference(_startWindow!).inSeconds ~/ _groupDuration!.inSeconds;
    print("[${widget.period}] Total bins: $totalBins");
    List<BarChartGroupData> groups = [];
    // For "today", we want exactly 6 bins; for others, include the boundary.
    int loopEnd = widget.period == 'today' ? totalBins : totalBins + 1;
    for (int i = 0; i < loopEnd; i++) {
      var sums = grouped[i] ?? {
        'lighting2': 0.0,
        'lighting5': 0.0,
        'lighting4': 0.0,
        'refrigerator': 0.0,
        'microwave': 0.0,
      };
      groups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 10,
          barRods: [
            BarChartRodData(
                toY: sums['lighting2']!, color: Colors.brown, width: 20, borderRadius: BorderRadius.zero),
            BarChartRodData(
                toY: sums['lighting5']!, color: Colors.green, width: 20, borderRadius: BorderRadius.zero),
            BarChartRodData(
                toY: sums['lighting4']!, color: Colors.brown, width: 20, borderRadius: BorderRadius.zero),
            BarChartRodData(
                toY: sums['refrigerator']!, color: Colors.green, width: 20, borderRadius: BorderRadius.zero),
            BarChartRodData(
                toY: sums['microwave']!, color: Colors.brown, width: 20, borderRadius: BorderRadius.zero),
          ],
        ),
      );
    }
    print("[${widget.period}] Total groups created: ${groups.length}");
    return groups;
  }

  double getNiceMaxY(List<BarChartGroupData> groups) {
    double maxY = 0;
    for (var group in groups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxY) {
          maxY = rod.toY;
        }
      }
    }
    return (maxY * 1.2).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
    }
    // Compute the original groups and maxY value.
    List<BarChartGroupData> groups = buildBarGroups();
    double maxY = getNiceMaxY(groups);
    double leftInterval = maxY / 5;
    if (leftInterval == 0) leftInterval = 1;

    // Wrap the BarChart in a TweenAnimationBuilder to animate the bars growing.
    return SizedBox(
      height: 300,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
        builder: (context, factor, child) {
          // Build new groups with each bar's height multiplied by the current factor.
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
              maxY: maxY, // Fixed maxY to keep axis scaling constant.
              groupsSpace: 25,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 50, interval: leftInterval),
                  axisNameWidget: const Text('Energy (kWh)', style: TextStyle(fontSize: 12, color: Colors.black)),
                  axisNameSize: 24,
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String label = '';
                      if (widget.period == 'today') {
                        // For 4-hour intervals, label the starting hour of the bin.
                        label = '${value.toInt() * 4}:00';
                      } else if (widget.period == 'week') {
                        label = 'Day ${value.toInt() + 1}';
                      } else {
                        label = 'Wk ${value.toInt() + 1}';
                      }
                      return Text(label, style: const TextStyle(fontSize: 12));
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
