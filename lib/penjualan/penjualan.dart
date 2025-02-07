import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latihan_ukk/login.dart';
import 'package:latihan_ukk/pelanggan/pelanggan.dart';
import 'package:latihan_ukk/penjualan/tambahpenjualan.dart';
import 'package:latihan_ukk/produk/produk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Penjualan extends StatefulWidget {
  final Map login;
  const Penjualan({super.key, required this.login});


  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> with TickerProviderStateMixin {
  TabController? myTabControl;
  List penjualan = [];
  List detailPenjualan = [];
  List produk=[];
  List pelanggan=[];
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  void fetchSales() async {
    var myProduk = await Supabase.instance.client
        .from('barang')
        .select()
        .order('ProdukId', ascending: true);
    var myCustomer = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .order('PelangganId', ascending: true);

    var responseSales = await Supabase.instance.client
        .from('penjualan')
        .select('*, pelanggan(*)');
    var responseSalesDetail = await Supabase.instance.client
        .from('detailpenjualan')
        .select('*, penjualan(*, pelanggan(*)), barang(*)');
    // print(responseSalesDetail);
    setState(() {
      penjualan = responseSales;
      detailPenjualan = responseSalesDetail;
      produk = myProduk;
      pelanggan = myCustomer;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSales();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    myTabControl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myTabControl?.dispose();
  }

  generateSales() {
    var filteredSales = penjualan.where((sale) {
    var tanggalPenjualan = DateFormat('yyyy-MM-dd').format(
      DateTime.parse(sale['TanggalPenjualan'])
    );
    return _searchQuery.isEmpty || tanggalPenjualan.contains(_searchQuery);
  }).toList();
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: [
        ...List.generate(filteredSales.length, (index) {
          var tanggalPenjualan = DateFormat(
            'dd MMMM yyyy',
          ).format(DateTime.parse(filteredSales[index]['TanggalPenjualan']));
          return Card(
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(penjualan[index]['PelangganId'] == null
                            ? 'Pelanggan tidak terdaftar'
                            : '${penjualan[index]['pelanggan']['NamaPelanggan']} (${penjualan[index]['pelanggan']['NomorTelepon']})')
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.rupiahSign,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text('${penjualan[index]['TotalHarga']}')
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.calendar,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text('${tanggalPenjualan}')
                      ],
                    ),
                  ],
                ),
              ));
        })
      ],
    );
  }

  generateSalesDetail() {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: [
        ...List.generate(detailPenjualan.length, (index) {
          var tanggalPenjualan = DateFormat('dd MMMM yyyy').format(
              DateTime.parse(
                  detailPenjualan[index]['penjualan']['TanggalPenjualan']));
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 10,
                    ),
                    Text(detailPenjualan[index]['penjualan']['PelangganId'] ==
                            null
                        ? 'Pelanggan tidak terdaftar'
                        : '${detailPenjualan[index]['penjualan']['pelanggan']['NamaPelanggan']} (${detailPenjualan[index]['penjualan']['pelanggan']['NomorTelepon']})'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.cartShopping),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        '${detailPenjualan[index]['barang']['NamaProduk']} (${detailPenjualan[index]['JumlahProduk']})'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.rupiahSign),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${detailPenjualan[index]['Subtotal']}'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.calendar),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${tanggalPenjualan}'),
                  ],
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   const Color(0xFFFAF3E0),
      appBar: AppBar(
        // ),
        centerTitle: true,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              hintText: "Cari Riwayat Penjualan",
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
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF003366),
        actions: [
          IconButton(
            onPressed: fetchSales,
            icon: const Icon(Icons.refresh),
            color: Color(0xFFFAF3E0),
          ),
        ],
      ),
      drawer: Drawer(
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
            accountName: Text(widget.login['username']  ?? 'Unknow User'),
            accountEmail: Text(
                '(${widget.login['prefilage']})'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 255, 252, 221),
              child: Text(
                widget.login['username'].toString().toUpperCase()[0],
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PelangganListPage(user: widget.login)));
              },
              leading: Icon(Icons.person_search),
              title: Text('Daftar Pelanggan')),
          ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Produk(user: widget.login)));
              },
              leading: Icon(Icons.shopping_cart),
              title: Text('Daftar Produk')),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Tutup Drawer
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      )),
      body: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Sales'),
              Tab(text: 'Sales Detail'),
            ],
            controller: myTabControl,
          ),
          Expanded(
            child: TabBarView(
              children: [
                penjualan.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : generateSales(),
                detailPenjualan.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : generateSalesDetail()
              ],
              controller: myTabControl,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var jual = await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => SalesPage( produk: produk,pelanggan: pelanggan,
                            login: widget.login,
                          ))
          );
          if (jual == 'success') {
            fetchSales();
          }
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: const Color(0xFF003366),
      )
    );
  }
}
