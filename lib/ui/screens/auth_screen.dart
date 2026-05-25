import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;
  const AuthScreen({super.key, required this.onAuthSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCyberBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Header
              const Text('Welcome Back',
                  style: TextStyle(
                      color: kStellarWhite,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                _isLogin
                    ? 'Sign in to continue your journey'
                    : 'Create your FuturePath account',
                style: const TextStyle(color: kCyberGray, fontSize: 14),
              ),
              const SizedBox(height: 40),
              // Form card
              CyberGlassCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: kStellarWhite),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email_outlined, color: kCyberGray),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      style: const TextStyle(color: kStellarWhite),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: kCyberGray),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: kCyberGray),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onAuthSuccess,
                        child: Text(_isLogin ? 'Sign In' : 'Create Account'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Toggle
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                          text: _isLogin
                              ? "Don't have an account? "
                              : 'Already have an account? ',
                          style: const TextStyle(color: kCyberGray),
                        ),
                        TextSpan(
                          text: _isLogin ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(
                              color: kNeonTeal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Guest
              Center(
                child: TextButton(
                  onPressed: widget.onAuthSuccess,
                  child: const Text('Continue as Guest',
                      style: TextStyle(color: kCyberGray, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
