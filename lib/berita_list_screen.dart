import 'package:flutter/material.dart';
import 'package:project_uts/login_screen.dart';
import 'package:project_uts/logout_screen.dart';
import 'package:project_uts/model/model_berita.dart';
import 'package:http/http.dart' as http;
import 'package:project_uts/berita_detail_screen.dart';
import 'package:project_uts/utils/cek_session.dart';
import 'package:project_uts/utils/ip.dart';

class BeritaListScreen extends StatefulWidget {
  const BeritaListScreen({Key? key});

  @override
  State<BeritaListScreen> createState() => _BeritaListScreenState();
}

class _BeritaListScreenState extends State<BeritaListScreen> {
  TextEditingController txtcari = TextEditingController();
  late Future<List<Datum>?> _futureBerita;
  late List<Datum> _beritaList = [];
  late List<Datum> _originalBeritaList = [];

  @override
  void initState() {
    super.initState();
    _futureBerita = getBerita();
  }

  Future<List<Datum>?> getBerita() async {
    try {
      http.Response res = await http.get(Uri.parse('$ip/getBerita.php'));
      return modelBeritaFromJson(res.body).data;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  void _searchBerita(String query) {
    setState(() {
      if (_originalBeritaList.isEmpty) {
        _originalBeritaList.addAll(_beritaList);
      }

      if (query.isEmpty) {
        _beritaList.clear();
        _beritaList.addAll(_originalBeritaList);
      } else {
        _beritaList.clear();
        _beritaList.addAll(_originalBeritaList.where((berita) =>
            berita.judul!.toLowerCase().contains(query.toLowerCase())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Halaman Utama',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 41, 83, 154),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: _searchBerita,
              decoration: InputDecoration(
                hintText: 'Cari Artikel',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _futureBerita,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 41, 83, 154)));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  _beritaList = snapshot.data!;
                  return ListView.builder(
                    itemCount: _beritaList.length,
                    itemBuilder: (context, index) {
                      Datum berita = _beritaList[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BeritaDetailScreen(berita)),
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      '$ip/gambar_berita/${berita.gambarBerita}',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    '${berita.judul}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 41, 83, 154),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${berita.isiBerita}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Tidak ada data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
