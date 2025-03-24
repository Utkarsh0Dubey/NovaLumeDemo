import 'package:flutter/material.dart';

class Quiz_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<String> questions = [
    'How many people live in your home?',
    'How many rooms does your home have?',
    'What is your average monthly electricity bill?',
    'Do you use smart home devices for energy monitoring?',
    'When is your home typically occupied?',
    'What is your primary source of electricity?'
  ];

  int currentQuestion = 0;
  TextEditingController answerController = TextEditingController();

  void nextQuestion() {
    if (answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an answer!')),
      );
      return;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        answerController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz Completed!')),
      );
    }
  }

  void prevQuestion() {

    if (currentQuestion != 0 ) {
      setState(() {
        currentQuestion--;
        answerController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This is the first question. ')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.7,
                image: NetworkImage(
                    'https://w0.peakpx.com/wallpaper/744/548/HD-wallpaper-whatsapp-ma-doodle-pattern.jpg'))),
        padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 30),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                key: ValueKey<int>(currentQuestion),
                questions[currentQuestion],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'Your Answer',
              ),
            ),
            SizedBox(height: 20),
            Row ( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ InkWell(
                onTap: prevQuestion,
                child: Text(
                  '<-',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                )),
            InkWell(
              onTap: nextQuestion,
                child: Text(
              '->',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            )), ]),
            SizedBox(height: 40),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.brown[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: (currentQuestion + 1) / questions.length,
                      backgroundColor: Colors.brown,
                      color: Colors.white,
                    ),
                    SizedBox(height: 15),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 2),
                Text(
                  ' ${currentQuestion + 1}/${questions.length}      ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}
