// To parse this JSON data, do
//
//     final modelListSejarawan = modelListSejarawanFromJson(jsonString);

import 'dart:convert';

ModelListSejarawan modelListSejarawanFromJson(String str) => ModelListSejarawan.fromJson(json.decode(str));

String modelListSejarawanToJson(ModelListSejarawan data) => json.encode(data.toJson());

class ModelListSejarawan {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListSejarawan({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListSejarawan.fromJson(Map<String, dynamic> json) => ModelListSejarawan(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String nama;
  String foto;
  String tanggalLahir;
  String asal;
  String jenisKelamin;
  String deskripsi;

  Datum({
    required this.id,
    required this.nama,
    required this.foto,
    required this.tanggalLahir,
    required this.asal,
    required this.jenisKelamin,
    required this.deskripsi,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nama: json["nama"],
    foto: json["foto"],
    tanggalLahir: json["tanggal_lahir"],
    asal: json["asal"],
    jenisKelamin: json["jenis_kelamin"],
    deskripsi: json["deskripsi"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "foto": foto,
    "tanggal_lahir": tanggalLahir,
    "asal": asal,
    "jenis_kelamin": jenisKelamin,
    "deskripsi": deskripsi,
  };
}
