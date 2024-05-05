// To parse this JSON data, do
//
//     final modelAddSejarawan = modelAddSejarawanFromJson(jsonString);

import 'dart:convert';

ModelAddSejarawan modelAddSejarawanFromJson(String str) => ModelAddSejarawan.fromJson(json.decode(str));

String modelAddSejarawanToJson(ModelAddSejarawan data) => json.encode(data.toJson());

class ModelAddSejarawan {
  bool isSuccess;
  String message;

  ModelAddSejarawan({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddSejarawan.fromJson(Map<String, dynamic> json) => ModelAddSejarawan(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
