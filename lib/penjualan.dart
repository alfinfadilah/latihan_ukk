import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class Penjualan extends StatefulWidget {
  const Penjualan({super.key});

  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> {
  var nama=[
    {
      'nama':'alpin'
    },
        {
      'nama':'rafi'
    },
    {
      'nama':'ageng'
    },
    {
      'nama':'predi'
    },
    {
      'nama':'irpan'
    },
    {
      'nama':'eprim'
    },
    {
      'nama':'nopal'
    },
    {
      'nama':'rangga'
    },
    {
      'nama':'cahaya'
    },
    {
      'nama':'luiz'
    },
  ];
  GridView  card(List data) {return GridView.count(
                      crossAxisCount: 2,
                      children: [
                        ...List.generate(10, (index) {
                          return Card(
                            color: Colors.black,
                            child: Text(
                              data[index]['nama'],
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          );
                        })
                      ],
                    );
                  }
  var selectedIndex = 0;
  var _controller= PageController(initialPage: 0);
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
                Navigator.pop(context);
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
              _controller.animateToPage(
              selectedIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad
            );
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
                Container(
                  color: Colors.white,
                  child: Center(
                    child: card(nama)
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: card(nama)
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: card(nama)
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: card(nama)
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
