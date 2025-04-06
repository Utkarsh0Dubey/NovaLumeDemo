import 'package:auth_demo/ContactUs.dart';
import 'package:auth_demo/Personalnfo.dart';
import 'package:auth_demo/home_screen.dart';
import 'package:auth_demo/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';
import 'ContactUs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFEBDDD0),
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // Pass a route, not a function
                );
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.brown,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(' My Profile ',
                  style: GoogleFonts.notoSerif(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
            )),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align everything to the left
                children: [
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      // 90% width
                      margin: const EdgeInsets.only(
                          top: 20, left: 20, right: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFD8BEAD),
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
                      // Positioned below the AppBar
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Profile_Page(
                              innerProgress: 0.6,
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Your savings : 3567 Rs ',
                              style: GoogleFonts.notoSerif(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ])),
                  SizedBox(height: 30),
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
                        color: Color(0xFFC8AB99),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () { Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Personalnfo()),
                            );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Icon(Icons.person,
                                      size: 23, color: Colors.black54),
                                  Text(
                                    ' Personal Info ',
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
                                  Icon(Icons.phone_android,
                                      size: 23, color: Colors.black),
                                  Text(
                                    ' Devices ',
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

                                  Text(
                                    ' Streak ',
                                    style: GoogleFonts.notoSerif(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ]),
                                Row(  children: [
                                  Icon(Icons.bolt,
                                    color: Colors.black, size: 23),
                                Text('7 ',style: GoogleFonts.notoSerif(
                                    color: Colors.black, fontSize: 20),)
                                  ]
                                ),
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
                                  Icon(Icons.attach_money,
                                      size: 23, color: Colors.black),
                                  Text(
                                    ' Cost Goal ',
                                    style: GoogleFonts.notoSerif(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                ]),
                                Text('350 Rs',style: GoogleFonts.notoSerif(
                                    color: Colors.black, fontSize: 20),)
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
                                  Icon(Icons.stacked_line_chart_rounded,
                                      size: 23, color: Colors.black),
                                  Text(
                                    '  Comparision ',
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
                  SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD8BEAD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Post 1 title',
                                style: GoogleFonts.notoSerif(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' 24 Mar  09:35am',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                softWrap: true, // Allows wrapping
                              )
                            ],
                          ),
                          Divider(thickness: 1, color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                    'I havent thought if i should fix the size of each post getting displayed or shall I let it be dynamic. ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    softWrap: true, // Allows wrapping
                                  ))
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD8BEAD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Post 2 title',
                                style: GoogleFonts.notoSerif(
                                    fontSize: 23,
                                    color: Colors.black, fontWeight: FontWeight
                                    .bold),
                              ),
                              Text(
                                ' 24 Mar  09:35am',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                softWrap: true, // Allows wrapping
                              )
                            ],
                          ),
                          Divider(thickness: 1, color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                    'This is a random paragraph which i am inserting to just check if the long messege is adjusting the height of the container on its own or not.  ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    softWrap: true, // Allows wrapping
                                  ))
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD8BEAD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Post 3 title',
                                style: GoogleFonts.notoSerif(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' 24 Mar  09:35am',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                softWrap: true, // Allows wrapping
                              )
                            ],
                          ),
                          Divider(thickness: 1, color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                    'This is a random paragraph which i am inserting to just check if the long messege is adjusting the height of the container on its own or not.  ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    softWrap: true, // Allows wrapping
                                  ))
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD8BEAD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Post 4 title',
                                style: GoogleFonts.notoSerif(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' 24 Mar  09:35am',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                softWrap: true, // Allows wrapping
                              )
                            ],
                          ),
                          Divider(thickness: 1, color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                    'This is a random paragraph which i am inserting to just check if the long messege is adjusting the height of the container on its own or not.  ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    softWrap: true, // Allows wrapping
                                  ))
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD8BEAD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Post 5 title',
                                style: GoogleFonts.notoSerif(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' 24 Mar  09:35am',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                softWrap: true, // Allows wrapping
                              )
                            ],
                          ),
                          Divider(thickness: 1, color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                    'This is a random paragraph which i am inserting to just check if the long messege is adjusting the height of the container on its own or not.  ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    softWrap: true, // Allows wrapping
                                  ))
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 30),
                  SizedBox(height: 30),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      margin: const EdgeInsets.only(
                          top: 0, left: 20, right: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (
                                          BuildContext context) => Contactus())
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: Text('Contact us',
                                    style: GoogleFonts.notoSerif(
                                      color: Colors.blue,
                                      fontSize: 23,
                                    )))
                          ])),
                  SizedBox(height: 20),
                  Container(
                      margin: const EdgeInsets.only(
                          top: 0, left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  await Supabase.instance.client.auth.signOut();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginScreen()));
                                  // Optionally, add navigation logic here if needed.
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: Text('Logout',
                                    style: GoogleFonts.notoSerif(
                                      color: Colors.red,
                                      fontSize: 23,
                                    )))
                          ])),
                  SizedBox(height: 50),
                ])),
      ),
    );
  }
}

class Profile_Page extends StatefulWidget {
  final double innerProgress;

  const Profile_Page({
    super.key,
    required this.innerProgress,
  });

  @override
  State<Profile_Page> createState() => _DualCircularProgressBarState();
}

class _DualCircularProgressBarState extends State<Profile_Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _innerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _innerAnimation = Tween<double>(begin: 0, end: widget.innerProgress)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Inner Circle
              SizedBox(
                width: 175,
                height: 175,
                child: CircularProgressIndicator(
                  value: _innerAnimation.value,
                  strokeWidth: 20,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.brown),
                  strokeCap: StrokeCap.round,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
  void _showComparisonSheet (BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take more space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // Change 0.5 to adjust height
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

