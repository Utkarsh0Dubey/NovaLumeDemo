import 'package:auth_demo/checking.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_screen.dart';
// Monthly forecast for the energy and savings
// Usage trends for the locality and personal " 14% less usage "
// Add the day week month tabBar

class Dash_Board extends StatefulWidget {
  const Dash_Board({super.key});

  @override
  State<Dash_Board> createState() => _Dash_BoardState();
}

class _Dash_BoardState extends State<Dash_Board> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300], // Grey background for Scaffold
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DashBoard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align everything to the left
                children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                // 90% width
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                // Positioned below the AppBar
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // White background for content container
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
                    const Text(
                      "Avg Consumption",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "XYZ Kwh",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.arrow_circle_down_rounded, size: 20),
                            Text(
                              "14% less usage ",
                              style: TextStyle(
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
                    // Space between text and chart
                    SizedBox(
                      height: 200, // Fixed height for the chart
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 30),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  return Text(
                                    "Bar ${value ~/ 2 + 1}",
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          groupsSpace: 10,
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 0,
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            ],
                            verticalLines: [
                              VerticalLine(
                                x: 0,
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            ],
                          ),
                          barGroups: [
                            makeComparisonGroup(0, 70, 50, Colors.brown,
                                const Color(0xFF808000)),
                            makeComparisonGroup(1, 80, 60, Colors.brown,
                                const Color(0xFF808000)),
                            makeComparisonGroup(2, 40, 30, Colors.brown,
                                const Color(0xFF808000)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.ac_unit_outlined,
                                  size: 23, color: Colors.black54),
                              Text(
                                ' Air Conditioning ( Living )  ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black54, size: 23)
                          ],
                        )),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.ac_unit_outlined,
                                  size: 23, color: Colors.black54),
                              Text(
                                ' Air Conditioning ( Dining ) ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black54, size: 23)
                          ],
                        )),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                        onTap: () {
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.local_fire_department,
                                  size: 23, color: Colors.black54),
                              Text(
                                ' Geyser ( Common )  ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black54, size: 23)
                          ],
                        )),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.severe_cold,
                                  size: 23, color: Colors.black54),
                              Text(
                                ' Refrigerator  ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black54, size: 23)
                          ],
                        )),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),

                    // The following inkwell navigates to the home page for checking purposes

                    InkWell(
                        splashColor: Colors.black,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.water_drop,
                                  size: 23, color: Colors.black54),
                              Text(
                                '  Washing Machine ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black54, size: 23)
                          ],
                        )),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ])));
  }

  BarChartGroupData makeComparisonGroup(
      int x, double y1, double y2, Color color1, Color color2) {
    return BarChartGroupData(
      x: x,
      barsSpace: 1, // Space between bars within the group
      barRods: [
        BarChartRodData(
          toY: y1,
          color: color1,
          width: 20, // Width of first bar
          borderRadius: BorderRadius.circular(0),
        ),
        BarChartRodData(
          toY: y2,
          color: color2,
          width: 20, // Width of second bar
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    );
  }
}
