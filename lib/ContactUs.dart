import 'package:flutter/material.dart';

class Contactus extends StatelessWidget {
  const Contactus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Contact_Us());
  }
}

class Contact_Us extends StatefulWidget {
  const Contact_Us({super.key});

  @override
  State<Contact_Us> createState() => _Contact_UsState();
}

class _Contact_UsState extends State<Contact_Us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://w0.peakpx.com/wallpaper/744/548/HD-wallpaper-whatsapp-ma-doodle-pattern.jpg'))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hey there',
                      style: TextStyle(color: Colors.brown, fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.brown, size: 20),
                        Text(
                          '  Our Email: ',
                          style: TextStyle(color: Colors.brown, fontSize: 18),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'info@novalume.life',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.brown, size: 20),
                        Text(
                          ' Our Number: ',
                          style: TextStyle(color: Colors.brown, fontSize: 18),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            '+91 8052407029',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ],
                ))));
  }
}
