import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_uts/home_screen.dart';
import 'package:project_uts/model/model_add_sejarawan.dart';
import 'package:project_uts/model/model_update_sejarawan.dart';
import 'package:project_uts/utils/ip.dart';
import '../main.dart';
import 'berita_list_screen.dart';
import 'model/model_list_sejarawan.dart';



class SejarawanScreen extends StatefulWidget {
  const SejarawanScreen({super.key});

  @override
  State<SejarawanScreen> createState() => _SejarawanScreenState();
}

class _SejarawanScreenState extends State<SejarawanScreen> {
  bool isLoading = true;
  List<Datum> listSejarawan = [];
  List<Datum> filteredSejarawan = [];
  TextEditingController txtCari = TextEditingController();

  Future<List<Datum>> getSejarawan() async {
    try {
      http.Response response = await http.get(
          Uri.parse('$ip/listSejarawan.php'));
      if (response.statusCode == 200) {
        return modelListSejarawanFromJson(response.body).data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
      return []; // Return an empty list in case of an error
    }
  }

  Future deleteSejarawan(String? id) async {
    try {
      if (id != null) {
        http.Response response = await http.post(
          Uri.parse('$ip/deleteSejarawan.php'),
          body: {
            "id": id,
          },
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('ID is null');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    getSejarawan().then((sejarawans) {
      setState(() {
        listSejarawan = sejarawans;
        isLoading = false;
      });
    });

    // Tambahkan listener untuk text field pencarian
    txtCari.addListener(() {
      setState(() {
        // Update status pencarian sesuai dengan keberadaan teks pada TextField
        isCari = txtCari.text.isNotEmpty;
      });
    });
  }

  bool isCari = false; // Set default value isCari menjadi false

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Sejarawan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 41, 83, 154),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: txtCari,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.lightBlue)),
              ),
            ),
            // Tampilkan daftar lengkap jika tidak ada pencarian atau tidak ada teks pencarian
            if (!isCari || txtCari.text.isEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: listSejarawan.length,
                  itemBuilder: (context, index) {
                    Datum data = listSejarawan[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to PageDetailSejarawan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PageDetailSejarawan(data),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Card(
                          child: ListTile(
                            title: Text(data.nama),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              PageUpdateSejarawan(data)),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: const Text('Hapus data ?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              deleteSejarawan(data.id)
                                                  .then((value) {
                                                if (value) {
                                                  setState(() {
                                                    listSejarawan.removeAt(
                                                        index);
                                                  });
                                                  Navigator.pop(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            BeritaListScreen()),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Failed to delete data'),
                                                      ));
                                                }
                                              });
                                            },
                                            child: Text('Hapus'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Batal'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            // Tampilkan hasil pencarian jika ada teks pencarian
            else if (isCari)
              CreateFilterList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageAddSejarawan()),
          );
        },
      ),
    );
  }

  Widget CreateFilterList() {
    // Filter listSejarawan sesuai dengan teks pencarian
    filteredSejarawan = listSejarawan
        .where((sejarawans) =>
        sejarawans.nama
            .toLowerCase()
            .contains(txtCari.text.toLowerCase()))
        .toList();
    return HasilSearch(filteredSejarawan);
  }

  Widget HasilSearch(List<Datum> filteredList) {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          Datum data = filteredList[index];
          return GestureDetector(
            onTap: () {
              // Navigate to PageDetailSejarawan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PageDetailSejarawan(data),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: ListTile(
                  title: Text(
                    data.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigate to update page
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text('Hapus data ?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    deleteSejarawan(data.id).then((value) {
                                      if (value) {
                                        setState(() {
                                          listSejarawan.removeAt(index);
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BeritaListScreen()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                'Failed to delete data')));
                                      }
                                    });
                                  },
                                  child: Text('Hapus'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Batal'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


//Page Insert sejarawan
class PageAddSejarawan extends StatefulWidget {
  const PageAddSejarawan({Key? key}) : super(key: key);

  @override
  State<PageAddSejarawan> createState() => _PageAddSejarawanState();
}

class _PageAddSejarawanState extends State<PageAddSejarawan> {
  TextEditingController nama = TextEditingController();
  TextEditingController tanggal_lahir = TextEditingController();
  TextEditingController asal = TextEditingController();
  TextEditingController jenis_kelamin = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  XFile? _imageFile; // Variable to store the selected image file

  bool isLoading = false;

  Future<ModelAddSejarawan?> createSejarawan() async {
    try {
      // Read image file as bytes
      Uint8List bytes = await _imageFile!.readAsBytes();
      // Convert bytes to base64 string
      String base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("$ip/addSejarawan.php"),
        body: {
          "nama": nama.text,
          "tanggal_lahir": tanggal_lahir.text,
          "asal": asal.text,
          "jenis_kelamin": jenis_kelamin.text,
          "deskripsi": deskripsi.text,
          "foto": base64Image, // Include the base64 string of the image
        },
      );

      if (response.statusCode == 200) {
        final data = modelAddSejarawanFromJson(response.body);
        if (data.message == "success") {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return data;
      } else {
        throw Exception('Gagal menambahkan data sejarawan');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Gagal menambahkan data sejarawan",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return null;
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? XFile(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Tambah Sejarawan',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 41, 83, 154),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: nama,
                validator: (val) =>
                val!.isEmpty ? "Nama tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Nama Sejarawan",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),

              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: Text('Pilih Gambar'),
              ),

              SizedBox(height: 8),
              TextFormField(
                controller: tanggal_lahir,
                validator: (val) =>
                val!.isEmpty ? "Tanggal tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Tanggal Lahir",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),

              SizedBox(height: 8),
              TextFormField(
                controller: asal,
                validator: (val) =>
                val!.isEmpty ? "Asal tidak boleh kosong!" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Asal",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),

              SizedBox(height: 8),
              TextFormField(
                controller: jenis_kelamin,
                validator: (val) =>
                val!.isEmpty ? "Jenis Kelamin can't be empty" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Jenis Kelamin",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),

              SizedBox(height: 8),
              TextFormField(
                controller: deskripsi,
                validator: (val) =>
                val!.isEmpty ? "Deskripsi tidak boleh kosong!" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Deskripsi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),

              SizedBox(height: 25),
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : MaterialButton(
                  minWidth: 150,
                  height: 45,
                  color: Colors.white,
                  onPressed: () async {
                    if (_imageFile != null && keyForm.currentState!.validate()) {
                      await createSejarawan(); // Wait for createSejarawan to complete
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BeritaListScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Mohon pilih gambar"),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),


              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageUpdateSejarawan extends StatelessWidget {
  final Datum data;

  const PageUpdateSejarawan(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController id = TextEditingController();
    TextEditingController nama = TextEditingController();
    TextEditingController tanggal_lahir = TextEditingController();
    TextEditingController asal = TextEditingController();
    TextEditingController jenis_kelamin = TextEditingController();
    TextEditingController deskripsi = TextEditingController();
    GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    bool isLoading = false;

    Future updateSejarawan() async {
      final response = await http.post(
        Uri.parse("$ip/updateSejarawan.php"),
        body: {
          "id": id.text,
          "nama": nama.text,
          "tanggal_lahir": tanggal_lahir.text,
          "asal": asal.text,
          "jenis_kelamin": jenis_kelamin.text,
          "deskripsi": deskripsi.text,
        },
      );
      if (response.statusCode == 200) {
        return true; // Return true indicating success
      }
      return false; // Return false indicating failure
    }

    id.text = data.id;
    nama.text = data.nama;
    tanggal_lahir.text = data.tanggalLahir;
    asal.text = data.asal;
    jenis_kelamin.text = data.jenisKelamin;
    deskripsi.text = data.deskripsi;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Update Sejarawan',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              SizedBox(height: 8),
              TextFormField(
                controller: nama,
                validator: (val) =>
                val!.isEmpty ? "Nama tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Nama Sejarawan",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: tanggal_lahir,
                validator: (val) =>
                val!.isEmpty ? "Tanggal tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Tanggal Lahir",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: asal,
                validator: (val) =>
                val!.isEmpty ? "Asal tidak boleh kosong!" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Asal",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: jenis_kelamin,
                validator: (val) =>
                val!.isEmpty ? "jenis Kelamin tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Jenis Kelamin",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: deskripsi,
                validator: (val) =>
                val!.isEmpty ? "Deskripsi tidak boleh kosong!" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Deskripsi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : MaterialButton(
                  minWidth: 150,
                  height: 45,
                  color: Colors.white,
                  onPressed: () {
                    if (keyForm.currentState!.validate()) {
                      updateSejarawan();
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BeritaListScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Page Detail Ssjarawan
class PageDetailSejarawan extends StatelessWidget {
  final Datum? data;

  const PageDetailSejarawan(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Detail Sejarawan',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color.fromARGB(255, 41, 83, 154),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile picture
                // Image.network('$ip/foto/${data?.foto}`'),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    '$ip/foto/${data?.foto}`',
                    scale: 10,
                  ),
                ),
                const SizedBox(height: 20),

                // Details in cards
                Card(
                  child: SizedBox(
                    width: double.infinity, // Set width to full screen
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center( // Center the text
                        child: Text(
                          'Nama : ${data?.nama}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity, // Set width to full screen
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center( // Center the text
                        child: Text(
                          'Tanggal lahir : ${data?.tanggalLahir}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity, // Set width to full screen
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center( // Center the text
                        child: Text(
                          'Asal : ${data?.asal}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity, // Set width to full screen
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center( // Center the text
                        child: Text(
                          'Jenis Kelamin : ${data?.jenisKelamin}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity, // Set width to full screen
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center( // Center the text
                        child: Text(
                          'Deskripsi : ${data?.deskripsi}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
