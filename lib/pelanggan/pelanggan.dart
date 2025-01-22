import 'package:flutter/material.dart';
import 'package:latihan_ukk/pelanggan/editpelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latihan_ukk/registerpelanggan.dart';

class PelangganListPage extends StatefulWidget {
  const PelangganListPage({super.key});

  @override
  State<PelangganListPage> createState() => _PelangganListPageState();
}

class _PelangganListPageState extends State<PelangganListPage> {
  List<Map<String, dynamic>> Pelanggan = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      // print('Response from Supabase: $response');
      setState(() {
        Pelanggan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  Future<void> tambahpelanggan(String NamaPelanggan, String Alamat, String NomorTelepon) async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').insert([
        {
          'NamaPelanggan': NamaPelanggan,
          'Alamat': Alamat,
          'NomorTelepon' : NomorTelepon
        }
      ]);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi tidak berhasil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $Error')),
      );
    }
  }

  Future<void> hapuspelanggan(int PelangganId) async {
    try {
      final response = await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganId', PelangganId);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil dihapus')),
        );
        fetch();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Daftar Pelanggan',
          style: TextStyle(
            color: Color(0xFFFAF3E0),
          ),
        ),
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            onPressed: fetch,
            icon: const Icon(Icons.refresh),
            color: Color(0xFFFAF3E0),
          ),
        ],
      ),
      body: Pelanggan.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: Pelanggan.length,
              itemBuilder: (context, index) {
                final pelanggan = Pelanggan[index]; 
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.white, // White card background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                        color: Color(0xFF003366), width: 1), // Navy blue border
                  ),
                  child: ListTile(
                    title: Text(
                      pelanggan['NamaPelanggan'] ?? 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pelanggan['Alamat'] ?? 'No Alamat',
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          pelanggan['NomorTelepon'] ?? 'No Nomor',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                                var result =
                                    await Navigator.push(context, MaterialPageRoute(builder: (context)=> Editpelanggan(pelanggan: pelanggan)));
                                if (result == 'success') {
                                  fetch();
                                }
                              },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text(
                                          'Apakah Anda yakin ingin menghapus produk ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                              fetch();
                                              Navigator.pop(context, true);
                                          },
                                              
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirm == true) {
                                  hapuspelanggan(pelanggan['PelangganId']);
                                }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _AddPelanggan(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          ),
        backgroundColor: const Color(0xFF003366),
      ),
    );
  }
 void _AddPelanggan(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Registerpelanggan(onAddpelanggan: (NamaPelanggan, Alamat, NomorTelepon) {
          tambahpelanggan(NamaPelanggan, Alamat, NomorTelepon);
          Navigator.pop(context, true);
        });
      },
    );
    if (result == true) {
      fetch();
    }
  }
}

