import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uts/model/login_response.dart';
import 'package:project_uts/nav_bar.dart';
import 'package:project_uts/register_screen.dart';
import 'package:project_uts/utils/cek_session.dart';
import 'package:project_uts/utils/ip.dart';
import 'package:project_uts/widget/text.form.global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Tambahkan GlobalKey untuk Form

  Future<LoginResponse?> loginUser() async {
    final String username = emailController.text;
    final String password = passwordController.text;

    final url = Uri.parse('$ip/login.php');

    try {
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
        },
      );

      LoginResponse data = loginResponseFromJson(response.body);

      if (response.statusCode == 200) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavBar()),
          );
        });
        session.saveSession(
            data.value ?? 0, data.id ?? "", data.username ?? "");
      } else if (response.statusCode == 401) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email atau password salah')),
          );
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal melakukan login')),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey, // Assign Form Key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Selamat Datang',
                      style: TextStyle(
                        color: Color.fromARGB(255, 41, 83, 154),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Silakan masuk untuk masuk ke aplikasi',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormGlobal(
                    controller: emailController,
                    text: 'Nama pengguna',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextFormGlobal(
                    controller: passwordController,
                    text: 'Kata sandi',
                    textInputType: TextInputType.text,
                    obscure: true,
                  ),
                  const SizedBox(height: 195),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Jika form valid, jalankan loginUser
                          loginUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 155, vertical: 10),
                        backgroundColor: Color.fromARGB(255, 41, 83, 154),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 110),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        'Belum punya punya akun? silakan daftar disini',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
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
}
