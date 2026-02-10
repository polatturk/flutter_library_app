import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  
  // Controller listesi
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    String? errorMessage;

    if (_isLogin) {
      errorMessage = await auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      errorMessage = await auth.register(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }

    if (errorMessage == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isLogin ? "Giriş Başarılı!" : "Kayıt Başarılı! Lütfen giriş yapın."), backgroundColor: Colors.green),
        );
        if (!_isLogin) {
          setState(() => _isLogin = true);
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.auto_stories_rounded, size: 90, color: Colors.indigo),
                  const SizedBox(height: 24),
                  Text(
                    _isLogin ? "Giriş Yap" : "Hesap Oluştur",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin ? "Kaldığın yerden devam et" : "Hemen aramıza katıl",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 40),

                  if (!_isLogin) ...[
                    _buildModernTextField(_nameController, "Ad", Icons.person),
                    const SizedBox(height: 16),
                    _buildModernTextField(_surnameController, "Soyad", Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildModernTextField(_usernameController, "Kullanıcı Adı", Icons.alternate_email),
                    const SizedBox(height: 16),
                  ],

                  _buildModernTextField(_emailController, "E-posta", Icons.email_outlined, isEmail: true),
                  const SizedBox(height: 16),
                  _buildModernTextField(_passwordController, "Şifre", Icons.lock_outline, isPass: true),
                  
                  const SizedBox(height: 32),

                  context.watch<AuthProvider>().isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                          ),
                          onPressed: _submit,
                          child: Text(
                            _isLogin ? "Giriş Yap" : "Kayıt Ol",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                        children: [
                          TextSpan(text: _isLogin ? "Hesabın yok mu? " : "Zaten hesabın var mı? "),
                          TextSpan(
                            text: _isLogin ? "Kayıt Ol" : "Giriş Yap",
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

  Widget _buildModernTextField(TextEditingController controller, String label, IconData icon, {bool isPass = false, bool isEmail = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPass,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.indigo.shade300),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none, 
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        validator: (val) => val!.isEmpty ? "$label boş bırakılamaz" : null,
      ),
    );
  }
}