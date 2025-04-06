import 'package:auth_demo/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Meter());
}

class Meter extends StatelessWidget {
  const Meter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Set the default font for all text widgets globally
        textTheme:  GoogleFonts.notoSerifTextTheme(
          Theme.of(context).textTheme, // Inherit from the existing theme
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Row(
            children: [
              InkWell(
                  child:
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
                  }),
              // Optional: Adding an icon to the left
              SizedBox(width: 20),
              // Space between the icon and title
              Text(
                'Meter',
                style:  GoogleFonts.notoSerif(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const BatteryWidget(),
      ),
    );
  }
}

class BatteryWidget extends StatefulWidget {
  const BatteryWidget({super.key});

  @override
  _BatteryWidgetState createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  int _selectedTab = 0; // To track selected tab
  double batteryLevel = 0.4;

  @override
  Widget build(BuildContext context) {
    int totalBars = 15; // Number of vertical bars inside the battery
    int filledBars =
        (batteryLevel * totalBars).round(); // Calculate filled bars

    // Color selection based on battery level
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

    return Scaffold( backgroundColor: Colors.white, body:  Column(
      children: [
        // Battery and Current Usage Display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              padding: EdgeInsets.all(10),
              width: 190,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.brown, Color(0xFFC8AB99)],
                ),
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text('Current Usage',
                      style:
                          TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Divider(thickness: 2, color: Colors.black),
                  Text('75 KWh',
                      style:
                          TextStyle(  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
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
                    width: 8, // Width of each bar
                    height: 64, // Height of bars
                    decoration: BoxDecoration(
                      gradient: index < filledBars
                          ? LinearGradient(
                              colors: [batteryColorStart, batteryColorEnd],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      // If not filled, no gradient
                      color: index >= filledBars ? Colors.white : null,
                      // Gray for unfilled bars
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),

        SizedBox(height: 70), // Space between widgets

        // Heartbeat Graph
        Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              // Hide grid lines
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Show Y-axis labels
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(),
                          style: TextStyle(color: Colors.black, fontSize: 12));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, // Show X-axis labels
                    reservedSize: 20,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(),
                          style: TextStyle(color: Colors.black, fontSize: 12));
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: Colors.black, width: 2),
                  // Left axis
                  bottom: BorderSide(color: Colors.black, width: 2),
                  // Bottom axis
                  right: BorderSide.none,
                  // Hide right border
                  top: BorderSide.none, // Hide top border
                ),
              ),
              minX: 0,
              maxX: 20,
              minY: -2,
              maxY: 4,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 0),
                    FlSpot(1, 0),
                    FlSpot(2, 1),
                    FlSpot(3, -1),
                    FlSpot(4, 4), // Sharp peak
                    FlSpot(5, -1),
                    FlSpot(6, 0.5),
                    FlSpot(7, 0),
                    FlSpot(8, 0),
                    FlSpot(9, 1),
                    FlSpot(10, -1),
                    FlSpot(11, 4), // Another sharp peak
                    FlSpot(12, -1),
                    FlSpot(13, 0.5),
                    FlSpot(14, 0),
                    FlSpot(15, 0),
                    FlSpot(16, 1),
                    FlSpot(17, -1),
                    FlSpot(18, 4), // Third sharp peak
                    FlSpot(19, -1),
                    FlSpot(20, 0),
                  ],
                  isCurved: false,
                  // Keep edges sharp
                  color: Colors.brown,
                  // ECG color
                  barWidth: 3,
                  // Thicker line
                  isStrokeCapRound: false,
                  // Prevent rounding
                  dotData: FlDotData(show: false), // Hide dots
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 100), // Space between widgets

        // Rounded Navbar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.brown.shade300,
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

        SizedBox(height: 20), //  // Space before container switch

        // Animated Section Switching
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (widget, animation) {
            return FadeTransition(
              opacity: animation,
              child: widget,
            );
          },
          child: _buildTabContent(_selectedTab),
        ),
      ],
    )
    );
  }

  // Navbar Item Builder
  Widget _buildNavBarItem(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _selectedTab == index ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  // Tab Content Builder
  Widget _buildTabContent(int index) {
    List<String> energyValues = ["75 KWh", "500 KWh", "2000 KWh"];
    List<String> savingsValues = ["75 Rs", "450 Rs", "1800 Rs"];
    List<String> predictionValues = ["125 Rs", "600 Rs", "2200 Rs"];

    return Container(
      key: ValueKey<int>(index),
      // Ensures smooth animation
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
        color: Color(0xFFD8BEAD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildRow(
            Icons.bolt,
            "Energy",
            energyValues[index],
          ),
          Divider(thickness: 1, color: Colors.grey),
          _buildRow(Icons.attach_money, "Savings", savingsValues[index]),
          Divider(thickness: 1, color: Colors.grey),
          _buildRow(Icons.lightbulb, "Prediction", predictionValues[index]),
        ],
      ),
    );
  }

  // Row Builder for the Container
  Widget _buildRow(IconData icon, String label, String value) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, size: 23, color: Colors.black54),
            SizedBox(width: 5),
            Text(label, style: TextStyle(color: Colors.black54, fontSize: 23)),
          ]),
          Text(value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
