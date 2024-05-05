import 'dart:convert';

import 'package:project_uts/login_screen.dart';
import 'package:project_uts/logout_screen.dart';
import 'package:project_uts/utils/cek_session.dart';
import 'package:project_uts/utils/ip.dart';
import 'package:flutter/material.dart';
import 'package:project_uts/model/model_galery.dart';
import 'package:http/http.dart' as http;

class GaleryScreen extends StatefulWidget {
  const GaleryScreen({super.key});

  @override
  State<GaleryScreen> createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  bool isLoading = true;
  List<Welcome> listBerita = [];

  Future getBerita() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.get(Uri.parse('$ip/getGalery.php'));
      var data = jsonDecode(res.body);
      setState(() {
        for (Map<String, dynamic> i in data) {
          listBerita.add(Welcome.fromJson(i));
        }
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBerita();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Galeri',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 41, 83, 154),
      ),
      body: GridView.builder(
          itemCount: listBerita.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageDetilGall(
                              '${listBerita[index].gambarBerita}',
                            )));
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: GridTile(
                  footer: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 41, 83, 154),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                  child: Image.network(
                    '$ip/gambar_berita/${listBerita[index].gambarBerita}',
                    fit: BoxFit.contain,
                    height: 190,
                    width: 190,
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class PageDetilGall extends StatelessWidget {
  final String itemGambar;
  const PageDetilGall(this.itemGambar, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 83, 154),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.network(
                  '$ip/gambar_berita/$itemGambar',
                  fit: BoxFit.contain,
                  height: 300,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
