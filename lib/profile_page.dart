import 'package:auth_demo/ContactUs.dart';
import 'package:auth_demo/Personalnfo.dart';
import 'package:auth_demo/home_screen.dart';
import 'package:auth_demo/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// We'll store the fetched stories in this list.
  List<Map<String, dynamic>>? storiesList;

  /// For showing a loading indicator or an error state.
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  /// Fetch rows from the 'stories' table in Supabase and store them in [storiesList].
  Future<void> fetchStories() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      storiesList = null;
    });

    try {
      /// Retrieve the rows from 'stories' table, ordered by created_at descending (optional).
      final response = await Supabase.instance.client
          .from('stories')
          .select('*')
          .order('created_at', ascending: false);

      if (response == null) {
        setState(() {
          errorMessage = 'No response from server';
        });
      } else if (response is List) {
        // Each element in the list is a Map<String,dynamic> representing a row.
        setState(() {
          storiesList = List<Map<String, dynamic>>.from(response);
        });
      } else {
        // Unexpected response type
        setState(() {
          errorMessage = 'Unexpected data format from server.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching stories: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Helper widget to build a single post container, similar to your original style.
  Widget buildPostContainer(Map<String, dynamic> story) {
    // You can rename 'title' or 'content' or handle null checks as needed.
    final title = story['title'] ?? 'No Title';
    final content = story['content'] ?? 'No Content';
    final createdAt = story['created_at']?.toString() ?? ''; // raw date/time

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD8BEAD),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSerif(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Show the raw createdAt or format it if you prefer.
              Text(
                createdAt,
                style: GoogleFonts.notoSerif(
                  fontSize: 17,
                  color: Colors.black,
                ),
                softWrap: true,
              )
            ],
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  softWrap: true, // Allows wrapping
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFEBDDD0),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.brown,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              ' My Profile ',
              style: GoogleFonts.notoSerif(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align left
            children: [
              // 1) Existing Container: Profile Info
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8BEAD),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Profile_Page(innerProgress: 0.6),
                    const SizedBox(height: 30),
                    Text(
                      'Your savings : 3567 Rs ',
                      style: GoogleFonts.notoSerif(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 2) Existing Container: Personal Info, Devices, Streak, etc.
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
                  color: const Color(0xFFC8AB99),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Personalnfo()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.person, size: 23, color: Colors.black54),
                            Text(
                              ' Personal Info ',
                              style: GoogleFonts.notoSerif(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ]),
                          const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.phone_android, size: 23, color: Colors.black),
                            Text(
                              ' Devices ',
                              style: GoogleFonts.notoSerif(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ]),
                          const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text(
                              ' Streak ',
                              style: GoogleFonts.notoSerif(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ]),
                          Row(
                            children: [
                              const Icon(Icons.bolt, color: Colors.black, size: 23),
                              Text(
                                '7 ',
                                style: GoogleFonts.notoSerif(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.attach_money, size: 23, color: Colors.black),
                            Text(
                              ' Cost Goal ',
                              style: GoogleFonts.notoSerif(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ]),
                          Text(
                            '350 Rs',
                            style: GoogleFonts.notoSerif(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                    InkWell(
                      splashColor: Colors.black,
                      onTap: () {
                        _showComparisonSheet(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.stacked_line_chart_rounded,
                                size: 23, color: Colors.black),
                            Text(
                              '  Comparision ',
                              style: GoogleFonts.notoSerif(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ]),
                          const Icon(Icons.navigate_next, color: Colors.black, size: 23),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.grey),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3) The dynamic story containers
              // If data is still loading, show a small progress or text
              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.brown),
                  ),
                )
              else if (errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                )
              else if (storiesList == null || storiesList!.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "No posts found.",
                        style: GoogleFonts.notoSerif(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                else
                // We have at least one post. Display them in a Column.
                // Alternatively, you could wrap in a ListView.builder, but you're already in a SingleChildScrollView.
                  Column(
                    children: storiesList!.map((storyRow) {
                      return Column(
                        children: [
                          buildPostContainer(storyRow),
                          const SizedBox(height: 30), // spacing between posts
                        ],
                      );
                    }).toList(),
                  ),

              const SizedBox(height: 30),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Contactus(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      child: Text(
                        'Contact us',
                        style: GoogleFonts.notoSerif(
                          color: Colors.blue,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.notoSerif(
                          color: Colors.red,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void _showComparisonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take more space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // Adjust height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comparison Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24, color: Colors.black54),
                    onPressed: () => Navigator.pop(context), // Close the sheet
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Here you can compare energy consumption over time.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context), // Close button
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The profile circle widget as before
class Profile_Page extends StatefulWidget {
  final double innerProgress;

  const Profile_Page({
    Key? key,
    required this.innerProgress,
  }) : super(key: key);

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
