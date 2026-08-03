import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:life_insurance/core/core.dart'
    show AppRoute, LocalizationContext;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Top Logo Symbol (Pagoda style)
              Image.asset(
                'assets/logo_symbol.png', // Replace with your asset path
                height: 60,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.temple_buddhist,
                  size: 60,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              // School Title Text
              Text(
                '合德中文',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Life Insurance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              // const Text(
              //   'Chinese Language School',
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: Colors.grey,
              //     letterSpacing: 0.5,
              //   ),
              // ),
              const SizedBox(height: 32),

              // Welcome Back Heading
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.welcomeMessage('欢迎回来'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Start your carrier journey',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Email or Student ID TextField
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email or UserID',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              // Password TextField
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',

                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: _rememberMe,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Remember me', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password action
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle login action
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Divider Text
              Center(
                child: Text(
                  'or continue as guest',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Continue as Guest Outline Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onPressed: () {
                    // Handle guest layout action
                    context.go(AppRoute.home);
                  },
                  icon: Icon(Icons.person_outline, size: 18),
                  label: Text(
                    'Continue as Guest',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ListTile(
                title: Text('Language'),
                onTap: () => context.push(AppRoute.language),
              ),
              ListTile(
                title: Text('Theme'),
                onTap: () => context.push(AppRoute.theme),
              ),

              // Terms and Conditions footer
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey, // or use AppColors theme value
                    ),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).primaryColor, // or AppColors.lightPrimary
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle Terms & Conditions tap
                          },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).primaryColor, // or AppColors.lightPrimary
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle Privacy Policy tap
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
