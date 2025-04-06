import 'package:auth_demo/check.dart';
import 'package:auth_demo/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'sign_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  // Toggle show/hide password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Normal Email/Password login
  Future<void> _login() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // For supabase_flutter >=2.x, AuthResponse provides user, session, etc.
      if (response.session != null) {
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // If session is null, login likely failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login failed. Please check credentials.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $e')),
      );
    }
  }

  // Google OAuth login
  Future<void> _loginWithGoogle() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'authdemo://login-callback',
      );

      // Listen for auth state changes and redirect to HomeScreen
      supabase.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Don't resize the widget when keyboard appears
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.6,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://w0.peakpx.com/wallpaper/744/548/HD-wallpaper-whatsapp-ma-doodle-pattern.jpg'))),
            ),
          ),

          // Foreground scrollable content
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              padding: const EdgeInsets.only(top: 220, left: 40, right: 40),
              child: Column(
                children: [
                  // Title
                   Text(
                    'Sign In',
                    style: GoogleFonts.notoSerif(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Email Field
                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email,
                    hint: 'Enter your Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 30),

                  // Password Field
                  _buildPasswordField(
                    label: 'Password',
                    icon: Icons.key,
                    hint: 'Enter your Password',
                    controller: _passwordController,
                  ),

                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        // Forgot Password logic
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // LOGIN button
                  _buildLoginButton(),

                  const SizedBox(height: 30),

                  // Google and Twitter Login buttons
                  _buildTwitterGoogleButtons(),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Google ',
                          style:  GoogleFonts.notoSerif(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      SizedBox(width: 20),
                      Text('Twitter',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ],
                  ),

                  const SizedBox(height: 30),

                  InkWell(
                      child: Text('Quizpage'),
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Quiz_Screen()))
                      }),
                   SizedBox(height: 20),
                  InkWell(
                      child: Text('UserHomePage'),
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomeScreen()))
                      }),
                  SizedBox(height: 20),
                  InkWell(
                      child: Text('CheckPage'),
                      onTap: () => { Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Check()))
                      }),
                  SizedBox(height: 20),

                  const SizedBox(height: 40),

                  // Sign Up prompt
                   Text(
                    "Don't have an account?",
                    style:  GoogleFonts.notoSerif(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Elevated Sign Up Button
                  _buildSignUpButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // Below are the helper widgets needed by the build()
  // ------------------------------------------------------

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 5,
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: _obscureText,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 5,
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
            size: 20,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return InkWell(
      splashColor: Colors.black,
      onTap: _login,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 50,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          'LOGIN',
          style:  GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Google Login Button
  Widget _buildTwitterGoogleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google login button
        InkWell(
            onTap: _loginWithGoogle,
            child: Icon(
              Icons.public,
              color: Colors.black,
            )),

        const SizedBox(width: 50), // Add spacing between buttons

        // Twitter login button (or any other)
        InkWell(
            onTap: () {
              // Add Twitter login or other action
            },
            child: Icon(Icons.public, color: Colors.black)),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child:  Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Text(
          'Sign Up',
          style:  GoogleFonts.notoSerif(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
