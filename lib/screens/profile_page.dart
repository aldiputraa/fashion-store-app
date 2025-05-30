import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/anissa.jpg'),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle error
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Anissa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'anissa@email.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              _buildProfileMenuItem(
                icon: Icons.shopping_bag,
                title: 'Pesanan Saya',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Pesanan Saya akan segera hadir')),
                  );
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.location_on,
                title: 'Alamat Pengiriman',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Alamat Pengiriman akan segera hadir')),
                  );
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.payment,
                title: 'Metode Pembayaran',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Metode Pembayaran akan segera hadir')),
                  );
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.settings,
                title: 'Pengaturan',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Pengaturan akan segera hadir')),
                  );
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.help,
                title: 'Bantuan',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Bantuan akan segera hadir')),
                  );
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 248, 0, 182),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Tampilkan dialog konfirmasi sebelum logout
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Konfirmasi Keluar'),
                          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Batal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Keluar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Kembali ke halaman login dan hapus semua halaman sebelumnya
                                Navigator.pushNamedAndRemoveUntil(
                                  context, 
                                  '/', 
                                  (route) => false
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 248, 0, 182)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}