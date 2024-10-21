import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_app/signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmpasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

// Inside _signUp function after successful Firestore data saving
try {
  // Sign up user
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text,
    password: _passwordController.text,
  );

  // Get the user Id
  String uid = userCredential.user!.uid;

  // Store user information in Firestore
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'fullName': _fullNameController.text,
    'email': _emailController.text,
    'uid': uid,
    'createdAt': DateTime.now(),
  });

  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Sign Up Successful')),
  );

  // Ensure the context is valid before navigating
  if (mounted) {
    // Navigate to the SignIn page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }
} catch (e) {
  String errorMessage;
  if (e is FirebaseAuthException) {
    if (e.code == 'weak-password') {
      errorMessage = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'The account already exists for that email.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'The email address is not valid.';
    } else {
      errorMessage = 'Failed to sign up: ${e.message}';
    }
  } else {
    errorMessage = 'An unknown error occurred.';
  }

  // Show error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
}

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              inputField(
                controller: _fullNameController,
                hint: "Full Name",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              inputField(
                controller: _emailController,
                hint: "Email",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add simple email validation
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              inputField(
                controller: _passwordController,
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              inputField(
                controller: _confirmpasswordController,
                hint: "Confirm Password",
                icon: Icons.lock,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
        ),
      ),
    );
  }

}