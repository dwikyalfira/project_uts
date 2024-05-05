import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uts/login_screen.dart';
import 'package:project_uts/model/register_response.dart';
import 'package:project_uts/utils/ip.dart';
import 'package:project_uts/widget/text.form.global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailrController = TextEditingController();
  final TextEditingController passwordrController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Added form key

  Future<RegisterResponse?> registerUser() async {
    final String fullname = fullnameController.text;
    final String username = usernameController.text;
    final String email = emailrController.text;
    final String password = passwordrController.text;

    final url = Uri.parse('$ip/register.php');

    try {
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
          'email': email,
          'fullname': fullname,
        },
      );

      RegisterResponse data = registerResponseFromJson(response.body);

      if (data.value == 1) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data.message)),
        );
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Buat Akun Baru',
                      style: TextStyle(
                        color: Color.fromARGB(255, 41, 83, 154),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Buat akun baru untuk dapat menggunakan\naplikasi',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormGlobal(
                    controller: fullnameController,
                    text: 'Nama Panjang',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  TextFormGlobal(
                    controller: usernameController,
                    text: 'Nama Pengguna',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  TextFormGlobal(
                    controller: emailrController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextFormGlobal(
                    controller: passwordrController,
                    text: 'Kata sandi',
                    textInputType: TextInputType.text,
                    obscure: true,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 157, vertical: 10),
                        backgroundColor: Color.fromARGB(255, 41, 83, 154),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Sudah punya punya akun? silakan masuk disini ',
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
