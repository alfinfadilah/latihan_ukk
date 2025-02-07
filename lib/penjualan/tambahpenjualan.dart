import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:latihan_ukk/penjualan/penjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalesPage extends StatefulWidget {
  final Map login;
  final List produk;
  final List pelanggan;

  const SalesPage({Key? key, required this.produk, required this.pelanggan, required this.login})
      : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final _formKeyPenjualan = GlobalKey<FormState>();
  List<Map<String, dynamic>> _selectedProduk = [];
  List<Map<String, dynamic>> _detailSales = [];
  int _totalHarga = 0;
  final _pelangganController = SingleValueDropDownController();
  Map<String, dynamic>? _selectedProduct;

  Future<void> _executeSales() async {
    if (_pelangganController.dropDownValue?.name == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih pelanggan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1500),
      ));
    } else if (_selectedProduk.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Isi data barang yang dibeli',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    } else {
      try {
        final penjualan = await Supabase.instance.client
            .from('penjualan')
            .insert({
              'PelangganId': _pelangganController.dropDownValue!.value,
              'TotalHarga': _totalHarga
            }).select().single();
            // print(penjualan);
            

        if (penjualan.isNotEmpty) {
          print(penjualan);
          print(_selectedProduk);
          for (var produk in _selectedProduk) {
            _detailSales.add({
              'PenjualanId': penjualan['PenjualanId'],
              'ProdukId': produk['ProdukId'],
              'JumlahProduk': (produk['JumlahProduk'] ?? 0) as int,
              'Subtotal': (produk['Subtotal'] ?? 0) as int
            });
          }
        

          final detail = await Supabase.instance.client
              .from('detailpenjualan')
              .insert(_detailSales)
              ;

          if (detail == null) {

            for (var produk in _selectedProduk) {
              produk.remove('Subtotal');
              produk['Stok'] = produk['Stok'] - produk['JumlahProduk'];
              produk.remove('JumlahProduk');
            }
            // print(_selectedProduk);

            

            final produkUpdate = await Supabase.instance.client
                .from('barang')
                .upsert(_selectedProduk);

            if (produkUpdate == null) {
              Navigator.pop(context, 'success');
            }
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // Function to show the dialog to select product and quantity
  void _showAddProductDialog() {
    TextEditingController jumlahController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Barang dan Jumlah'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Pilih Barang'),
                items: widget.produk.map((produk) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: produk,
                    child: Text(produk['NamaProduk']),
                  );
                }).toList(),
                onChanged: (Map<String, dynamic>? value) {
                  setState(() {
                    _selectedProduct = value;  // Update the selected product
                  });
                },
              ),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Barang'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (_selectedProduct != null) {
                  final jumlah = int.parse(jumlahController.text);
                  final subtotal = _selectedProduct!['Harga'] * jumlah;

                  setState(() {
                    _selectedProduk.add({
                      'ProdukId': _selectedProduct!['ProdukId'],
                      'NamaProduk': _selectedProduct!['NamaProduk'],
                      'Stok':_selectedProduct!['Stok'],
                      'JumlahProduk': jumlah,
                      'Subtotal': subtotal,
                    });
                    _totalHarga += (subtotal) as int;
                    // print(_selectedProduk);
                  });

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Tambah'),
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
        title: const Text('Tambah Penjualan'),
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 255, 252, 221),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKeyPenjualan,
                    child: DropDownTextField(
                      enableSearch: true,
                      controller: _pelangganController,
                      dropDownList: [
                        DropDownValueModel(
                            name: 'Pelanggan non member', value: null),
                        ...List.generate(widget.pelanggan.length, (index) {
                          return DropDownValueModel(
                              name:
                                  '${widget.pelanggan[index]['NamaPelanggan']} (${widget.pelanggan[index]['NomorTelepon']})',
                              value: widget.pelanggan[index]['PelangganId']);
                        })
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 249, 246, 222),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: _selectedProduk.isNotEmpty
                          ? ListView.builder(
                              itemCount: _selectedProduk.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 15,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                _selectedProduk[index]['NamaProduk']),
                                            Text(
                                                'Jumlah dibeli:${_selectedProduk[index]['JumlahProduk']}'),
                                            Text(
                                                'Subtotal:${_selectedProduk[index]['Subtotal']}')
                                          ],
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _totalHarga -=
                                                  (_selectedProduk[index] ['Subtotal'] as int);
                                              _selectedProduk.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                  'Tambahkan barang dan jumlah yang dibeli')),

                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total harga: $_totalHarga',
                        style: const TextStyle(color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: _showAddProductDialog,
                        child: const Text('Tambah Barang'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _executeSales();
                      // print(_selectedProduct);
                    },
                    child: const Text('Simpan penjualan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
