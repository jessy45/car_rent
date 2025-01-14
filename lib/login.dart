import 'package:carent/auth_service.dart';
import 'package:flutter/material.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService(); // Instance du service d'authentification

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  bool isLogin = true; // Basculer entre "Sign In" et "Sign Up"
  bool isLoading = false; // Pour afficher un indicateur de chargement

  // Méthode pour gérer la logique d'authentification
  void handleAuth() async {
    setState(() {
      isLoading = true;
    });

    if (isLogin) {
      // Connexion
      final response = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (response['success']) {
        // Redirigez l'utilisateur après une connexion réussie
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${response['data']['user']['name']}!')),
        );
        // Naviguez vers la page principale ou autre
      } else {
        // Affichez un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Invalid credentials')),
        );
      }
    } else {
      // Inscription
      final response = await _authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text,
        _addressController.text,
        _phoneController.text,
        _licenseController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (response['success']) {
        // Redirigez l'utilisateur après une inscription réussie
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created for ${response['data']['user']['name']}!')),
        );
        // Naviguez vers la page principale ou autre
      } else {
        // Affichez les erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['errors'].toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLogin
                      ? "Sign in to book your favorite car"
                      : "Create an account to start renting cars",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                if (!isLogin)
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                if (!isLogin) const SizedBox(height: 16),

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                if (!isLogin)
                  const SizedBox(height: 16),
                if (!isLogin)
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                if (!isLogin) const SizedBox(height: 16),
                if (!isLogin)
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Address",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                if (!isLogin) const SizedBox(height: 16),
                if (!isLogin)
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                if (!isLogin) const SizedBox(height: 16),
                if (!isLogin)
                  TextField(
                    controller: _licenseController,
                    decoration: InputDecoration(
                      hintText: "Driving License",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7DD3F7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Text(
                      isLogin ? "Sign In" : "Sign Up",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin
                          ? "Don't have an account?"
                          : "Already have an account?",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "Sign Up" : "Sign In",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7DD3F7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
