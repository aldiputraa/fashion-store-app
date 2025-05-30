import 'package:flutter/material.dart';
import 'cart_screen.dart';

class FashionStore extends StatefulWidget {
  const FashionStore({Key? key}) : super(key: key);

  @override
  _FashionStoreState createState() => _FashionStoreState();
}

class _FashionStoreState extends State<FashionStore> {
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> wishlistItems = [];

  final List<Map<String, String>> menuItems = [
    {
      'imagePath': 'assets/baju.jpg',
      'title': 'Blouse',
      'description':
          'Baju Blouse wanita/blouse lengan pendek/Atasan wanita/fashion wanita - navy.',
      'price': 'Rp. 180.000',
    },
    {
      'imagePath': 'assets/celana.jpeg',
      'title': 'Celana Kulot',
      'description': 'Damai - Celana Kulot wanita premium quality.',
      'price': 'Rp. 200.000',
    },
    {
      'imagePath': 'assets/hem.jpg',
      'title': 'Kemeja',
      'description':
          'Kemeja Wanita NATUSHA SHIRT baju kemeja cewek lengan panjang polos.',
      'price': 'Rp. 190.000',
    },
    {
      'imagePath': 'assets/jaket.jpg',
      'title': 'Jaket Crop',
      'description':
          'TREND TERBARU AB - Floryn Jaket Crop Wanita Hoodie Zipper Korean Style Crop Hoodie Atasan Wanita.',
      'price': 'Rp. 300.000',
    },
    {
      'imagePath': 'assets/outer.jpeg',
      'title': 'Blazer Vest',
      'description':
          'Carla blazer vest black white luaran wanita outer vest kekinian blazer hitam putih.',
      'price': 'Rp. 200.000',
    },
    {
      'imagePath': 'assets/rok.jpg',
      'title': 'Rok Linen',
      'description':
          'Bora Skirt - Rok Linen - Rok Murah - Rok Wanita - Rok kekinian - Rok Korea - Rok Panjang - Rok Adem - Rok Sehari hari.',
      'price': 'Rp. 150.000',
    },
  ];

  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += int.parse(item['price'].replaceAll(RegExp(r'[^\d]'), '')) *
          item['quantity'];
    }
    return total;
  }

  void toggleWishlist(String title) {
    setState(() {
      bool found = false;
      for (var item in wishlistItems) {
        if (item['title'] == title) {
          wishlistItems.removeWhere((item) => item['title'] == title);
          found = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title dihapus dari wishlist')),
          );
          break;
        }
      }
      if (!found) {
        final product = menuItems.firstWhere((item) => item['title'] == title);
        wishlistItems.add({
          'title': product['title'],
          'price': product['price'],
          'imagePath': product['imagePath'],
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title ditambahkan ke wishlist')),
        );
      }
    });
  }

  bool isInWishlist(String title) {
    return wishlistItems.any((item) => item['title'] == title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fashion Store'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 248, 0, 182),
              Color.fromARGB(255, 252, 250, 249),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.asset(
                                item['imagePath']!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.error, color: Colors.red, size: 50),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  isInWishlist(item['title']!)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isInWishlist(item['title']!)
                                      ? Colors.red
                                      : Colors.white,
                                ),
                                onPressed: () => toggleWishlist(item['title']!),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(item['description']!),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['price']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 248, 0, 182),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 248, 0, 182),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          bool found = false;
                                          for (var cartItem in cartItems) {
                                            if (cartItem['title'] == item['title']) {
                                              cartItem['quantity'] += 1;
                                              found = true;
                                              break;
                                            }
                                          }
                                          if (!found) {
                                            cartItems.add({
                                              'title': item['title'],
                                              'price': item['price'],
                                              'quantity': 1,
                                            });
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Produk ditambahkan ke keranjang'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        });
                                      },
                                      child: const Text('Tambah ke Keranjang'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen(cartItems)),
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rp. ${getTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              '${cartItems.length} Item',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}