import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class Tambah extends StatefulWidget {
  const Tambah({super.key, required this.onAddBarang});

  final Function(String, String, String, String) onAddBarang;

  @override
  State<Tambah> createState() => _TambahState();
}

class _TambahState extends State<Tambah> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _namaprodukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final SingleValueDropDownController _jenisController =
      SingleValueDropDownController();

  Future<bool> cekNamaBarang(String namaBarang) async {
    final response = await Supabase.instance.client
        .from('barang')
        .select()
        .eq('NamaProduk', namaBarang).maybeSingle();
        return response != null;
  }

  Future<void> tambah(
      String NamaProduk, String Harga, String Stok, String Jenis) async {
    try {
    bool exists = await cekNamaBarang(NamaProduk);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama barang sudah ada, gunakan nama lain.')),
      );
      return;
    }

    final response = await Supabase.instance.client.from('barang').insert([
      {'NamaProduk': NamaProduk, 'Harga': Harga, 'Stok': Stok, 'Jenis': Jenis}
    ]).select();

    if (response.isNotEmpty) {
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan barang')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tambah Barang',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: 100,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      controller: _namaprodukController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Barang',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _hargaController,
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'harga tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _stokController,
                      decoration: const InputDecoration(
                        labelText: 'Stok',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: DropDownTextField(
                      controller: _jenisController,
                      textFieldDecoration: const InputDecoration(
                        labelText: 'Jenis',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jenis tidak boleh kosong';
                        }
                        return null;
                      },
                      dropDownItemCount: 3,
                      dropDownList: [
                        DropDownValueModel(name: 'makanan', value: 'makanan'),
                        DropDownValueModel(name: 'minuman', value: 'minuman'),
                        DropDownValueModel(name: 'dissert', value: 'dissert'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState?.validate() ?? false) {
                          tambah(
                              _namaprodukController.text,
                              _hargaController.text,
                              _stokController.text,
                              _jenisController.dropDownValue?.value);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                      ),
                      child: const Text(
                        'Tambah Produk',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFFFAF3E0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
