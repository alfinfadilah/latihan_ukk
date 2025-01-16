import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latihan_ukk/login.dart';
import 'package:latihan_ukk/tambah.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Penjualan extends StatefulWidget {
  const Penjualan({super.key});

  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> {
  List<Map<String, dynamic>> Barang = [];

  var jenis = [
    null,
    'makanan',
    'minuman',
    'dissert',
  ];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      final response = await Supabase.instance.client.from('barang').select();
      // print('Response from Supabase: $response');
      setState(() {
        Barang = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> tambah(
      String NamaProduk, String Harga, String Stok, String Jenis) async {
    final response = await Supabase.instance.client.from('barang').insert([
      {'NamaProduk': NamaProduk, 'Harga': Harga, 'Stok': Stok, 'Jenis': Jenis}
    ]);
    if (response == null) {
      initializeData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error add produk')),
      );
    }
  }

  GridView card([String? jenis]) {
    var filterData;
    if (jenis == null) {
      filterData = Barang;
    } else {
      filterData = Barang.where((item) => item['Jenis'] == jenis).toList();
    }

    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 3.2,
      children: [
        ...List.generate(filterData.length, (index) {
          final barang = filterData[index];
          var iconBarang;
          if (barang['Jenis']=='makanan') {
            iconBarang= Icons.food_bank;
          }else if(barang['Jenis']=='minuman'){
            iconBarang=Icons.local_cafe;
          }else{
            iconBarang=Icons.cake;
          }
          return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.grey.shade200,
              child: LayoutBuilder(builder: (context, constraint) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              barang['NamaProduk'],
                              style:
                                  TextStyle(fontSize: constraint.maxHeight / 4),
                            ),
                            Text(
                              'RP ${barang['Harga']}',
                              style:
                                  TextStyle(fontSize: constraint.maxHeight / 6),
                            ),
                            Text(
                              'Stok ${barang['Stok']}',
                              style:
                                  TextStyle(fontSize: constraint.maxHeight / 6),
                            )
                          ]),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                size: constraint.maxHeight / 4,
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              icon: Icon(
                                size: constraint.maxHeight / 4,
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(iconBarang)
                    ],
                  ),
                );
              }));
        })
      ],
    );
  }

  var selectedIndex = 0;
  var _controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'user@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
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
        backgroundColor: Colors.white,
        elevation: 1,
        title: TextField(
          decoration: InputDecoration(
              hintText: "Cari Produk",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              filled: true),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.grid_view,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.calculate,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SlidingClippedNavBar(
            onButtonPressed: (index) {
              setState(() {
                selectedIndex = index;
              });
              _controller.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad);
            },
            selectedIndex: selectedIndex,
            activeColor: Colors.orange,
            barItems: [
              BarItem(
                title: "Best Seller",
                icon: Icons.sell,
              ),
              BarItem(
                title: "Makanan",
                icon: Icons.food_bank,
              ),
              BarItem(
                title: "Minuman",
                icon: Icons.local_cafe,
              ),
              BarItem(
                title: "Dissert",
                icon: Icons.cake,
              ),
            ],
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: [
                card(),
                card('makanan'),
                card('minuman'),
                card('dissert'),
                // for (int i = 0; i < 4; i++)
                //   Container(
                //     color: Colors.white,
                //     child: Barang.isEmpty
                //         ? const Center(
                //             child: CircularProgressIndicator(),
                //           )
                //         : Center(
                //             child: card(Barang),
                //           ),
                //   ),
                // Container(
                //   color: Colors.white,
                //   child: Barang.isEmpty
                //       ? const Center(
                //           child: CircularProgressIndicator(),
                //         )
                //       : Center(
                //           child: card(Barang),
                //         ),
                // ),
                // Container(
                //   color: Colors.white,
                //   child: Barang.isEmpty
                //       ? const Center(
                //           child: CircularProgressIndicator(),
                //         )
                //       : Center(
                //           child: card(Barang),
                //         ),
                // ),
                // Container(
                //   color: Colors.white,
                //   child: Barang.isEmpty
                //       ? const Center(
                //           child: CircularProgressIndicator(),
                //         )
                //       : Center(
                //           child: card(Barang),
                //         ),
                // ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF003366),
      ),
    );
  }

  void _showAddDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Tambah(onAddBarang: (Namaproduk, Harga, Stok, Jenis) {
          tambah(Namaproduk, Harga, Stok, Jenis);
          Navigator.pop(context, true);
        });
      },
    );
    if (result == true) {
      initializeData();
    }
  }
}
