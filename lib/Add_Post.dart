import 'package:auth_demo/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Add_Post extends StatelessWidget {
  const Add_Post({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddPost(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()),
                )),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "New Post",
            style: GoogleFonts.notoSerif(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFFEBDDD0),
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQI6XUaq1aT74XKoFfDEzyiCupdotlOSvZkBg&s')))),
                SizedBox(height: 30),
                Text('Title: ',
                    style: GoogleFonts.notoSerif(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.black), // Black outline
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2), // Thicker when focused
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                  cursorColor: Colors.black, // Makes cursor black
                  style: TextStyle(color: Colors.black), // Text color
                ),
                SizedBox(height: 30),
                Text(' Your LoomyTale: ',
                    style: GoogleFonts.notoSerif(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 30),
                SizedBox(
                  height: 100, // Adjust height as needed
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Your story",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.black), // Black outline
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 2), // Thicker when focused
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20), // More padding inside
                    ),
                    cursorColor: Colors.black, // Black cursor
                    style: TextStyle(
                        color: Colors.black, fontSize: 18), // Larger text
                  ),
                )
              ],
            ))),
            InkWell(
                onTap: () {},
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    color: Colors.brown,
                        borderRadius: BorderRadius.circular(20)),
                    height: 50,
                    width: double.infinity,
                    child: Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
