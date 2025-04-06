/* import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'NotificationsService.dart';

// Monthly forecast for the energy and savings
// Usage trends for the locality and personal " 14% less usage "
// Add the day week month tabBar

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init(); // Initialize notifications
  runApp(Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dash_Board(),
      theme: ThemeData(
        // Set the default font for all text widgets globally
        textTheme: GoogleFonts.notoSerifTextTheme(
          Theme.of(context).textTheme, // Inherit from the existing theme
        ),
      ),
    );
  }
}

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
        backgroundColor: Color( 0xFFD8BEAD),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            // Back button icon
            onPressed: () {
              Navigator.pop(context); // Go back to previous screen
            },
          ),
          backgroundColor: Colors.brown,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Dashboard',
                style: GoogleFonts.notoSerif(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                )),
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
                  color: Color( 0xFFEBDDD0),
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
                         Text(
                          "XYZ Kwh",
                          style: GoogleFonts.notoSerif(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children:  [
                            Icon(Icons.arrow_circle_down_rounded, size: 20),
                            Text(
                              "14% less usage ",
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
                                    style:  GoogleFonts.notoSerif(fontSize: 12),
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
                    color: Color( 0xFFEBDDD0),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {  NotificationService().showNotification(); },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.ac_unit_outlined,
                                  size: 23, color: Colors.black),
                              Text(
                                ' Air Conditioning ( Living )  ',
                                style: GoogleFonts.notoSerif(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black, size: 23)
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
                                  size: 23, color: Colors.black),
                              Text(
                                ' Air Conditioning ( Dining ) ',
                                style: GoogleFonts.notoSerif(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black, size: 23)
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
                              Icon(Icons.local_fire_department,
                                  size: 23, color: Colors.black),
                              Text(
                                ' Geyser ( Common )  ',
                                style: GoogleFonts.notoSerif(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black, size: 23)
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
                                  size: 23, color: Colors.black),
                              Text(
                                ' Refrigerator  ',
                                style: GoogleFonts.notoSerif(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black, size: 23)
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
                                  size: 23, color: Colors.black),
                              Text(
                                '  Washing Machine ',
                                style: GoogleFonts.notoSerif(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ]),
                            Icon(Icons.navigate_next,
                                color: Colors.black, size: 23)
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
} */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'NotificationsService.dart';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  runApp(Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dash_Board(),
      theme: ThemeData(
        textTheme: GoogleFonts.notoSerifTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}

class Dash_Board extends StatefulWidget {
  const Dash_Board({super.key});

  @override
  State<Dash_Board> createState() => _Dash_BoardState();
}

class _Dash_BoardState extends State<Dash_Board> {
  int _selectedTab = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  List<BarChartGroupData> _getChartData() {
    if (_selectedTab == 0) {
      return [
        makeComparisonGroup(0, 70, 50, Colors.brown, const Color(0xFFD1AF94)),
        makeComparisonGroup(1, 80, 60, Colors.brown, const Color(0xFFD1AF94)),
        makeComparisonGroup(2, 40, 30, Colors.brown, const Color(0xFFD1AF94)),
      ];
    } else if (_selectedTab == 1) {
      return [
        makeComparisonGroup(0, 90, 70, Colors.brown, const Color(0xFFD1AF94)),
        makeComparisonGroup(1, 85, 65, Colors.brown, const Color(0xFFD1AF94)),
        makeComparisonGroup(2, 60, 40, Colors.brown, const Color(0xFFD1AF94)),
      ];
    } else {
      return [
        makeComparisonGroup(0, 100, 90, Colors.brown, const Color(0xFFD1AF94)),
        makeComparisonGroup(1, 95, 80, Colors.brown, const Color(0xFFD1AF94)),
        makeComparisonGroup(2, 75, 60, Colors.brown, const Color(0xFFD1AF94)),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFD8BEAD),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFEBDDD0),
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
                        Icon(Icons.arrow_circle_down_rounded, size: 20),
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

                // Animated Chart Switching
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder: (widget, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: widget,
                    );
                  },
                  child: SizedBox(
                    height: 200,
                    key: ValueKey<int>(_selectedTab),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  "Bar ${value ~/ 2 + 1}",
                                  style: GoogleFonts.notoSerif(fontSize: 12),
                                );
                              },
                            ),
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

          // Navbar for Day, Week, Month
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
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
                color: Color(0xFFEBDDD0),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      _showComparisonSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.ac_unit_outlined,
                              size: 23, color: Colors.black),
                          Text(
                            ' Air Conditioning ( Living )  ',
                            style: GoogleFonts.notoSerif(
                                color: Colors.black, fontSize: 17),
                          ),
                        ]),
                        Icon(Icons.navigate_next, color: Colors.black, size: 23)
                      ],
                    )),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                InkWell(
                    onTap: () {
                      _showComparisonSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.ac_unit_outlined,
                              size: 23, color: Colors.black),
                          Text(
                            ' Air Conditioning ( Dining ) ',
                            style: GoogleFonts.notoSerif(
                                color: Colors.black, fontSize: 17),
                          ),
                        ]),
                        Icon(Icons.navigate_next, color: Colors.black, size: 23)
                      ],
                    )),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                InkWell(
                    onTap: () {
                      _showComparisonSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.local_fire_department,
                              size: 23, color: Colors.black),
                          Text(
                            ' Geyser ( Common )  ',
                            style: GoogleFonts.notoSerif(
                                color: Colors.black, fontSize: 17),
                          ),
                        ]),
                        Icon(Icons.navigate_next, color: Colors.black, size: 23)
                      ],
                    )),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                InkWell(
                    onTap: () {
                      _showComparisonSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.severe_cold,
                              size: 23, color: Colors.black),
                          Text(
                            ' Refrigerator  ',
                            style: GoogleFonts.notoSerif(
                                color: Colors.black, fontSize: 17),
                          ),
                        ]),
                        Icon(Icons.navigate_next, color: Colors.black, size: 23)
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
                      _showComparisonSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.water_drop, size: 23, color: Colors.black),
                          Text(
                            '  Washing Machine ',
                            style: GoogleFonts.notoSerif(
                                color: Colors.black, fontSize: 17),
                          ),
                        ]),
                        Icon(Icons.navigate_next, color: Colors.black, size: 23)
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

  Widget _buildNavBarItem(String text, int index) {
    return GestureDetector(
      onTap: () {
        _onTabSelected(index);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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

  BarChartGroupData makeComparisonGroup(
      int x, double y1, double y2, Color color1, Color color2) {
    return BarChartGroupData(
      x: x,
      barsSpace: 1,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: color1,
          width: 20,
          borderRadius: BorderRadius.circular(0),
        ),
        BarChartRodData(
          toY: y2,
          color: color2,
          width: 20,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    );
  }
}

void _showComparisonSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the sheet to take more space
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height *
            0.5, // Change 0.5 to adjust height
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures it wraps content
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comparison Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24, color: Colors.black54),
                  onPressed: () => Navigator.pop(context), // Close the sheet
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              'Here you can compare energy consumption over time.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Close button
              child: Text('Close'),
            ),
          ],
        ),
      );
    },
  );
}
