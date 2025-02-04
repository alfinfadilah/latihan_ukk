import 'package:flutter/material.dart';
import 'package:latihan_ukk/login.dart';
import 'package:latihan_ukk/pelanggan/editpelanggan.dart';
import 'package:latihan_ukk/produk/produk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latihan_ukk/pelanggan/registerpelanggan.dart';
import 'package:latihan_ukk/register.dart';

class PelangganListPage extends StatefulWidget {
  final Map user;
  const PelangganListPage({super.key, required this.user});

  @override
  State<PelangganListPage> createState() => _PelangganListPageState();
}

class _PelangganListPageState extends State<PelangganListPage> {
  List<Map<String, dynamic>> Pelanggan = [];
  List<Map<String, dynamic>> User = [];

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

  Future<void> initialis() async {
    try {
      final response = await Supabase.instance.client.from('user').select();
      // print('Response from Supabase: $response');
      setState(() {
        User = List<Map<String, dynamic>>.from(response);
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

  Future<void> tambahuser(String username, String password) async {
    try {
      final response = await Supabase.instance.client.from('user').insert([
        {
          'Username': username,
          'Password': password,
        }
      ]);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal: $e')),
      );
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 0, 26, 255),
              Colors.blue,
              Colors.lightBlue,
            ], begin: Alignment.topLeft)),
            accountName: Text(widget.user['username']  ?? 'Unknow User'),
            accountEmail: Text(
                '(${widget.user['prefilage']})'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 255, 252, 221),
              child: Text(
                widget.user['username'].toString().toUpperCase()[0],
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
            widget.user['prefilage'] == 'admin'
                ? ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('register petugas'),
                    onTap: () {
                      _AddUser(context);
                    },
                  )
                : SizedBox(),
                ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('daftar produk'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Produk(user: widget.user,)),
                      );
                    },
                  ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Daftar Pelanggan',
          style: TextStyle(
            color: Color(0xFFFAF3E0),
          ),
        ),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
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
                              fontSize: 14,
                            ),
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
                        widget.user['prefilage'] == 'admin'
                        ? IconButton(
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
                            ))
                          : SizedBox(),
                        widget.user['prefilage'] == 'admin'
                        ? IconButton(
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
                            )
                          )
                          : SizedBox(),
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: 
      widget.user['prefilage'] == 'admin' 
      ? FloatingActionButton(
        onPressed: () {
          _AddPelanggan(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          ),
        backgroundColor: const Color(0xFF003366),
      )
      : null
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
  void _AddUser(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Register(onAddUser: (
          Username,
          Password,
        ) {
          tambahuser(
            Username,
            Password,
          );
          Navigator.pop(context, true);
        });
      },
    );
    if (result == true) {
      initialis();
    }
  }
}

