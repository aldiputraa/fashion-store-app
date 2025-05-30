import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('aktif'),
          _buildOrderList('selesai'),
          _buildOrderList('dibatalkan'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    // Contoh data pesanan
    final List<Map<String, dynamic>> orders = [
      {
        'id': 'ORD-001',
        'date': '15 Mei 2023',
        'items': ['Kemeja Putih', 'Celana Jeans'],
        'total': 'Rp 450.000',
        'status': 'aktif',
      },
      {
        'id': 'ORD-002',
        'date': '10 Mei 2023',
        'items': ['Jaket Denim'],
        'total': 'Rp 350.000',
        'status': 'selesai',
      },
      {
        'id': 'ORD-003',
        'date': '5 Mei 2023',
        'items': ['Rok Mini', 'Blouse'],
        'total': 'Rp 275.000',
        'status': 'dibatalkan',
      },
    ];

    final filteredOrders = orders.where((order) => order['status'] == status).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pesanan $status',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(order['date']),
                  ],
                ),
                const Divider(),
                ...List.generate(
                  (order['items'] as List).length,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${order['items'][i]}'),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:'),
                    Text(
                      order['total'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(order['status']),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(orderId: order['id']),
                          ),
                        );
                      },
                      child: const Text('Lihat Detail'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'aktif':
        color = Colors.blue;
        text = 'Sedang Diproses';
        break;
      case 'selesai':
        color = Colors.green;
        text = 'Selesai';
        break;
      case 'dibatalkan':
        color = Colors.red;
        text = 'Dibatalkan';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contoh data detail pesanan
    final Map<String, dynamic> orderDetail = {
      'id': orderId,
      'date': '15 Mei 2023',
      'items': [
        {'name': 'Kemeja Putih', 'price': 'Rp 250.000', 'quantity': 1},
        {'name': 'Celana Jeans', 'price': 'Rp 200.000', 'quantity': 1},
      ],
      'subtotal': 'Rp 450.000',
      'shipping': 'Rp 20.000',
      'total': 'Rp 470.000',
      'status': 'Sedang Diproses',
      'address': 'Jl. Contoh No. 123, Kota Contoh, 12345',
      'payment': 'Transfer Bank BCA',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan #$orderId'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow('Nomor Pesanan', '#$orderId'),
                    _buildInfoRow('Tanggal Pemesanan', orderDetail['date']),
                    _buildInfoRow('Status', orderDetail['status']),
                    _buildInfoRow('Metode Pembayaran', orderDetail['payment']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alamat Pengiriman',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(orderDetail['address']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rincian Produk',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      orderDetail['items'].length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    orderDetail['items'][index]['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Jumlah: ${orderDetail['items'][index]['quantity']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    orderDetail['items'][index]['price'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow('Subtotal', orderDetail['subtotal']),
                    _buildInfoRow('Biaya Pengiriman', orderDetail['shipping']),
                    const Divider(),
                    _buildInfoRow('Total', orderDetail['total'], isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implementasi lacak pesanan
                },
                child: const Text('Lacak Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}