// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stbbankapplication1/screens/map_page.dart';
import 'package:stbbankapplication1/screens/admin.dart';
import 'package:stbbankapplication1/screens/signup.dart';
import 'package:stbbankapplication1/screens/liste-agents.dart';
import 'package:stbbankapplication1/screens/user.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  void navigateBasedOnRole(String userRole, BuildContext context) {
    if (userRole == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => admin()), // Adjust to your admin screen
      );
    } else if (userRole == 'superAdmin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => super_admin()),
      );
    } else if (userRole == 'user') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserScreen()),
      );
    }else
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }
//chadwadridi6100@gmail.com
//"chadwa123"
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderContainer(w, h),
            _buildTextFieldsContainer(),
            _buildCreateAccountLink(),
            _buildForgotPasswordLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContainer(double w, double h) {
    return Container(
      width: w,
      height: h * 0.4,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("img/header.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "RapidBankBooking",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 16, 79, 161),
            ),
          ),
          Image.asset(
            'img/stb.png',
            width: 300,
            height: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldsContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          _buildEmailTextField(),
          SizedBox(height: 10),
          _buildPasswordTextField(),
          SizedBox(height: 10),
          _buildSignInButton(),
          SizedBox(height: 10),
          _buildErrorMessage(),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      );
    } else {
      return Container(); // Return an empty container if no error message
    }
  }

  Widget _buildEmailTextField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(1, 1),
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Form(
        key: _emailFormKey,
        child: TextFormField(
          controller: _emailController,
          obscureText: false,
          decoration: InputDecoration(
            labelText: "Adresse E-mail",
            prefixIcon: Icon(Icons.email),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 250, 251, 252),
                width: 1.0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 249, 250, 252),
                width: 1.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer une adresse e-mail valide.';
            }
            if (!value.contains('@')) {
              return 'L\'adresse e-mail doit contenir un "@"';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(1, 1),
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Form(
        key: _passwordFormKey,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Mot de passe",
            prefixIcon: Icon(Icons.lock),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 250, 251, 252),
                width: 1.0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 249, 250, 252),
                width: 1.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un mot de passe.';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit avoir au moins 6 caractères.';
            }
            return null;
          },
        ),
      ),
    );
  }

  String? _validateEmail() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      return 'Veuillez entrer une adresse e-mail.';
    }
    if (!email.contains('@')) {
      return 'L\'adresse e-mail doit contenir un "@"';
    }
    return null;
  }

  String? _validatePassword() {
    String password = _passwordController.text.trim();
    if (password.isEmpty) {
      return 'Veuillez entrer un mot de passe.';
    }
    if (password.length < 6) {
      return 'Le mot de passe doit avoir au moins 6 caractères.';
    }
    return null;
  }

  Widget _buildSignInButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.lightBlue,
            Color.fromARGB(255, 8, 57, 143),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: signIn,
        style: ElevatedButton.styleFrom(
          foregroundColor: Color.fromARGB(49, 33, 182, 202), backgroundColor: Color.fromARGB(6, 18, 60, 177),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Connexion",
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 253, 250, 250),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    if (_emailFormKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        try{
          // Fetch user data from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userSnapshot.exists) {
          
            final userData = userSnapshot.data() as Map<String, dynamic>;
          
          final userRole = userData['role'] as String?;

          if (userRole != null) {
            navigateBasedOnRole(userRole, context);
          } else {
            setState(() {
              _errorMessage = "Error: User role not available";
            });
            
          }
          
        }
        }catch(err){
          setState(() {
          _errorMessage =
              "User Account Is deleted !";
        });
        }

      } catch (e) {
        setState(() {
          _errorMessage =
              "Erreur de connexion. Veuillez vérifier vos informations.";
        });
        print("Sign-in error: $e");
      }
    }
  }

  Widget _buildCreateAccountLink() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signup()),
        );
      },
      child: const Text(
        "Pas inscrit ? Créer un compte",
        style:
            TextStyle(fontSize: 16, color: Color.fromARGB(255, 147, 175, 197)),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/forgot_password');
      },
      child: const Text(
        "Mot de passe oublié",
        style:
            TextStyle(fontSize: 16, color: Color.fromARGB(255, 124, 156, 182)),
      ),
    );
  }
}
