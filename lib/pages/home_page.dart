import 'package:flutter/material.dart';
import '../models/mamhasiswa.dart';
import '../service/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nimController = TextEditingController();
  final namaController = TextEditingController();

  List<Mahasiswa> mahasiswaList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  // get data
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      mahasiswaList = await ApiServices.getMahasiswa();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  // tambah data
  Future<void> tambahData() async {
    if (nimController.text.isEmpty || namaController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data wajib diisi')));
      return;
    }

    bool success = await ApiServices.tambahMahasiswa(
      nim: nimController.text,
      nama: namaController.text,
    );

    if (!mounted) return;

    // jika success
    if (success) {
      nimController.clear();
      namaController.clear();

      getData();
      // pesan
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan')));
    }
  }

  @override
  void dispose() {
    nimController.dispose();
    namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REST API FLUTTER"),
      ), // AppBar
      body: RefreshIndicator(
        onRefresh: getData,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // text input nim
              TextField(
                controller: nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ), // InputDecoration
              ), // TextField

              const SizedBox(height: 12,),

              // text input nma
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ), // InputDecoration
              ), // TextField
              const SizedBox(height: 12,),

              // button simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: tambahData, child: const Text('Simpan')),
              ), // SizedBox (ukuran button simpan)

              const SizedBox(height: 20,),
              // list
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Center
                    : ListView.builder(
                        itemCount: mahasiswaList.length,
                        itemBuilder: (context, index) {
                          final data = mahasiswaList[index];

                          // tampilan card
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(child: Text('${data.id}'),), 
                              title: Text(data.nama),
                              subtitle: Text(data.nim),
                            ), // ListTile
                          ); // Card
                        },
                      ) // ListView.builder
              ) // Expanded
            ],
          ), // Column
        ), // Padding
      ), // RefreshIndicator
    ); // Scaffold
  }
}