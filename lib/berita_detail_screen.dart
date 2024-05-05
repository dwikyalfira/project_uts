import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uts/model/model_berita.dart';
import 'package:project_uts/utils/ip.dart';

class BeritaDetailScreen extends StatelessWidget {
  final Datum? data;
  const BeritaDetailScreen(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 41, 83, 154),
        title: Text(
          data!.judul,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '$ip/gambar_berita/${data?.gambarBerita}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Text(
              data?.judul ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle:
                Text(DateFormat().format(data?.tglBerita ?? DateTime.now())),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              data?.isiBerita ?? "",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
