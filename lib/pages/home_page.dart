// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_lagu_daerah_app/models/province.dart';
import 'package:flutter_lagu_daerah_app/pages/detail_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _showAddDialog() async {
    final TextEditingController laguController = TextEditingController();
    final TextEditingController namaDaerahController = TextEditingController();
    final TextEditingController ibuKotaController = TextEditingController();
    final TextEditingController lirikController = TextEditingController();
    final TextEditingController photoController =
        TextEditingController(text: "https://picsum.photos/200/300");

    final formKey = GlobalKey<FormState>();

    Future<bool> isValidImageUrl(String url) async {
      try {
        final response = await http.get(Uri.parse(url));
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Lagu'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    controller: laguController,
                    decoration: const InputDecoration(labelText: 'Nama Lagu'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Lagu tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: namaDaerahController,
                    decoration: const InputDecoration(labelText: 'Nama Daerah'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Daerah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ibuKotaController,
                    decoration: const InputDecoration(labelText: 'Ibu Kota'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ibu Kota tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lirikController,
                    decoration: const InputDecoration(labelText: 'Lirik'),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lirik tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: photoController,
                    decoration: const InputDecoration(labelText: 'URL Foto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'URL Foto tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final photoUrl = photoController.text;
                  final isValidUrl = await isValidImageUrl(photoUrl);

                  if (!isValidUrl) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'URL Foto tidak valid atau tidak dapat diakses'),
                      ),
                    );
                  } else {
                    final newProvince = Province(
                      id: laguDaerahList.length + 1,
                      nama: namaDaerahController.text,
                      ibuKota: ibuKotaController.text,
                      photo: photoUrl,
                      laguDaerah: laguController.text,
                      lirikLaguDaerah: lirikController.text,
                    );

                    setState(() {
                      laguDaerahList.add(newProvince);
                    });

                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lagu Daerah',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: laguDaerahList.length,
        itemBuilder: (context, index) {
          final province = laguDaerahList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(province: province),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      province.photo,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Text('Gambar tidak tersedia'));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      province.laguDaerah,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${province.nama} - ${province.ibuKota}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.blueGrey.shade800,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
