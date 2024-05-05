// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) =>
    List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  String gambarBerita;
  String judul;
  String isiBerita;
  DateTime tglBerita;

  Welcome({
    required this.gambarBerita,
    required this.judul,
    required this.isiBerita,
    required this.tglBerita,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        gambarBerita: json["gambar_berita"],
        judul: json["judul"],
        isiBerita: json["isi_berita"],
        tglBerita: DateTime.parse(json["tgl_berita"]),
      );

  Map<String, dynamic> toJson() => {
        "gambar_berita": gambarBerita,
        "judul": judul,
        "isi_berita": isiBerita,
        "tgl_berita": tglBerita.toIso8601String(),
      };
}
