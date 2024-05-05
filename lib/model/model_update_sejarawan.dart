// To parse this JSON data, do
//
//     final modelUpdateSejarawan = modelUpdateSejarawanFromJson(jsonString);

import 'dart:convert';

ModelUpdateSejarawan modelUpdateSejarawanFromJson(String str) => ModelUpdateSejarawan.fromJson(json.decode(str));

String modelUpdateSejarawanToJson(ModelUpdateSejarawan data) => json.encode(data.toJson());

class ModelUpdateSejarawan {
  bool isSuccess;
  int value;
  String message;
  String nama;
  String foto;
  String tanggalLahir;
  String asal;
  String jenisKelamin;
  String deskripsi;
  String id;

  ModelUpdateSejarawan({
    required this.isSuccess,
    required this.value,
    required this.message,
    required this.nama,
    required this.foto,
    required this.tanggalLahir,
    required this.asal,
    required this.jenisKelamin,
    required this.deskripsi,
    required this.id,
  });

  factory ModelUpdateSejarawan.fromJson(Map<String, dynamic> json) => ModelUpdateSejarawan(
    isSuccess: json["is_success"],
    value: json["value"],
    message: json["message"],
    nama: json["nama"],
    foto: json["foto"],
    tanggalLahir: json["tanggal_lahir"],
    asal: json["asal"],
    jenisKelamin: json["jenis_kelamin"],
    deskripsi: json["deskripsi"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "value": value,
    "message": message,
    "nama": nama,
    "foto": foto,
    "tanggal_lahir": tanggalLahir,
    "asal": asal,
    "jenis_kelamin": jenisKelamin,
    "deskripsi": deskripsi,
    "id": id,
  };
}
