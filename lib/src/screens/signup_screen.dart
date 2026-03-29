import 'package:carolie_tracking_app/src/presentation/controllers/auth_controller.dart';
import 'package:carolie_tracking_app/src/utils/auth_error_message.dart';
import 'package:carolie_tracking_app/src/utils/auth_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const _SignupHeader(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF111111),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join thousands tracking nutrition their way',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF666666),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLabel('Full Name'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'Your name',
                          prefixIcon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          validator: AuthValidators.fullName,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Email Address'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'your.email@example.com',
                          prefixIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: AuthValidators.email,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Password'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Create a strong password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          isVisible: _isPasswordVisible,
                          textInputAction: TextInputAction.next,
                          validator: AuthValidators.password,
                          onToggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Confirm Password'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Re-enter your password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          isVisible: _isConfirmPasswordVisible,
                          textInputAction: TextInputAction.done,
                          validator: (value) => AuthValidators.confirmPassword(
                            value,
                            _passwordController.text,
                          ),
                          onFieldSubmitted: (_) => _submit(context),
                          onToggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4EC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF666666),
                                fontSize: 12,
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'By signing up, you agree to our ',
                                ),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD96C2C),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD96C2C),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: authController.isBusy
                                ? null
                                : () => _submit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD96C2C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: authController.isBusy
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Create Account',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: authController.isBusy
                                ? null
                                : () => _continueWithGoogle(context),
                            icon: const Icon(
                              Icons.g_mobiledata_rounded,
                              size: 26,
                            ),
                            label: const Text('Continue with Google'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF111111),
                              side: const BorderSide(color: Color(0xFFDDDDDD)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Color(0xFFEEEEEE)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'OR',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF999999),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Color(0xFFEEEEEE)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF666666),
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFD96C2C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final authController = context.read<AuthController>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final email = _emailController.text.trim();

    try {
      await authController.signUpWithEmailPassword(
        name: _nameController.text,
        email: email,
        password: _passwordController.text,
      );
    } on Exception catch (error) {
      if (!mounted) return;
      _showError(scaffoldMessenger, error);
      return;
    }

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Verify your email'),
        content: Text(
          'A verification link has been sent to $email.\n\n'
          'Please check your inbox (and spam folder) and tap the link to activate your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _continueWithGoogle(BuildContext context) async {
    final authController = context.read<AuthController>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await authController.signInWithGoogle();
      navigator.popUntil((route) => route.isFirst);
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Google sign-in successful')),
      );
    } on Exception catch (error) {
      _showError(scaffoldMessenger, error);
    }
  }

  void _showError(ScaffoldMessengerState scaffoldMessenger, Object error) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(authErrorMessage(error))),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        color: const Color(0xFF111111),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: const Color(0xFF111111),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF999999),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFF666666),
            size: 20,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF999999),
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0C0F0D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'CarAI',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your culturally relevant nutrition journey',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
