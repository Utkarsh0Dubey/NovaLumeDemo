import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auth_demo/home_screen.dart'; // Ensure this is valid

class Add_Post extends StatelessWidget {
  const Add_Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddPost(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  // Controllers for capturing user input
  final TextEditingController titleController = TextEditingController();
  final TextEditingController storyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    storyController.dispose();
    super.dispose();
  }

  /// Inserts a row into 'stories' and then selects it back to confirm.
  Future<void> postStory() async {
    final String title = titleController.text.trim();
    final String story = storyController.text.trim();

    if (title.isEmpty || story.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out both fields")),
      );
      return;
    }

    try {
      /// 1) Insert the new story row.
      /// 2) Chain `.select()` to fetch back the inserted row(s).
      ///
      /// This call directly returns the inserted data:
      ///   - Typically a List of inserted rows, e.g. [{id:..., title:..., content:..., created_at:...}]
      ///   - Or null / unexpected types if something went wrong.
      final insertedData = await Supabase.instance.client
          .from('stories')
          .insert({'title': title, 'content': story})
          .select();

      /// Let's do some type-checking on `insertedData`.
      if (insertedData == null) {
        // No data returned at all - unexpected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No data returned from server")),
        );
        return;
      }

      if (insertedData is List && insertedData.isNotEmpty) {
        // On success, 'insertedData' is typically a List of the inserted rows.
        // For example: [{'id': '...', 'title': '...', 'content': '...', 'created_at': '...'}]
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Story posted!")),
        );
        // Clear text fields on success
        titleController.clear();
        storyController.clear();
      } else if (insertedData is Map<String, dynamic>) {
        // If it's a single object, not an array
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Story posted (single row)!")),
        );
        titleController.clear();
        storyController.clear();
      } else {
        // It's neither a List nor a Map
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unexpected response from server")),
        );
      }
    } catch (error) {
      // This block catches any thrown exceptions (e.g. network issues).
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          ),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "New Post",
            style: GoogleFonts.notoSerif(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        decoration: const BoxDecoration(color: Color(0xFFEBDDD0)),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large image at the top
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQI6XUaq1aT74XKoFfDEzyiCupdotlOSvZkBg&s',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Title:',
                    style: GoogleFonts.notoSerif(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter title",
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        const BorderSide(color: Colors.black, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                    ),
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Your LoomyTale:',
                    style: GoogleFonts.notoSerif(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 100,
                    child: TextField(
                      controller: storyController,
                      decoration: InputDecoration(
                        hintText: "Your story",
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                      ),
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: postStory,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 50,
                width: double.infinity,
                child: const Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
