import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildHelpSection(
            context,
            'Akun & Profil',
            [
              'Cara mendaftar akun baru',
              'Cara mengubah informasi profil',
              'Cara mengubah kata sandi',
              'Cara menghapus akun',
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            context,
            'Belanja',
            [
              'Cara mencari produk',
              'Cara menambahkan produk ke keranjang',
              'Cara menambahkan produk ke wishlist',
              'Cara menggunakan filter dan kategori',
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            context,
            'Pesanan & Pembayaran',
            [
              'Cara melakukan checkout',
              'Metode pembayaran yang tersedia',
              'Cara melacak pesanan',
              'Cara membatalkan pesanan',
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            context,
            'Pengiriman & Pengembalian',
            [
              'Informasi biaya pengiriman',
              'Estimasi waktu pengiriman',
              'Cara mengembalikan produk',
              'Kebijakan pengembalian dana',
            ],
          ),
          const SizedBox(height: 24),
          _buildContactSupport(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari bantuan...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => _buildHelpItem(context, item)).toList(),
      ],
    );
  }

  Widget _buildHelpItem(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HelpDetailScreen(title: title),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Butuh bantuan lebih lanjut?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('Live Chat'),
                    onPressed: () {
                      // Implementasi live chat
                      _showContactDialog(context, 'Live Chat');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                    onPressed: () {
                      // Implementasi email support
                      _showContactDialog(context, 'Email');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('Hubungi Kami'),
                onPressed: () {
                  // Implementasi telepon support
                  _showContactDialog(context, 'Telepon');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, String method) {
    String message;
    String contactInfo;

    switch (method) {
      case 'Live Chat':
        message = 'Layanan live chat tersedia setiap hari dari jam 08.00 - 21.00 WIB.';
        contactInfo = 'Mulai chat sekarang';
        break;
      case 'Email':
        message = 'Kirim email ke alamat di bawah ini. Kami akan merespons dalam 1x24 jam.';
        contactInfo = 'support@fashionstore.com';
        break;
      case 'Telepon':
        message = 'Hubungi customer service kami di nomor berikut:';
        contactInfo = '0800-1234-5678 (Bebas pulsa)';
        break;
      default:
        message = '';
        contactInfo = '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hubungi Kami via $method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 8),
            Text(
              contactInfo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          if (method == 'Live Chat')
            ElevatedButton(
              onPressed: () {
                // Implementasi mulai live chat
                Navigator.pop(context);
              },
              child: const Text('Mulai Chat'),
            ),
        ],
      ),
    );
  }
}

class HelpDetailScreen extends StatelessWidget {
  final String title;

  const HelpDetailScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHelpContent(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Apakah artikel ini membantu?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.thumb_up),
                  label: const Text('Ya'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terima kasih atas feedback Anda!'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.thumb_down),
                  label: const Text('Tidak'),
                  onPressed: () {
                    _showFeedbackDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masih butuh bantuan?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implementasi kontak customer service
                        },
                        child: const Text('Hubungi Customer Service'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpContent() {
    // Contoh konten bantuan berdasarkan judul
    String content = '';

    if (title == 'Cara mendaftar akun baru') {
      content = '''
1. Buka aplikasi Fashion Store.
2. Klik tombol "Masuk" di halaman utama.
3. Pilih opsi "Daftar" di bagian bawah layar.
4. Isi formulir pendaftaran dengan informasi yang diminta:
   - Nama lengkap
   - Alamat email
   - Nomor telepon
   - Kata sandi
5. Centang kotak persetujuan syarat dan ketentuan.
6. Klik tombol "Daftar".
7. Verifikasi akun Anda melalui email yang dikirimkan.
8. Setelah verifikasi, Anda dapat masuk ke akun baru Anda.

Tips: Gunakan kata sandi yang kuat dengan kombinasi huruf, angka, dan simbol untuk keamanan akun Anda.
''';
    } else if (title == 'Cara melakukan checkout') {
      content = '''
1. Pastikan Anda sudah login ke akun Anda.
2. Tambahkan produk yang ingin dibeli ke keranjang belanja.
3. Klik ikon keranjang di pojok kanan atas untuk melihat keranjang belanja Anda.
4. Periksa produk di keranjang dan pastikan jumlah dan ukuran sudah sesuai.
5. Klik tombol "Checkout" untuk melanjutkan.
6. Pilih alamat pengiriman atau tambahkan alamat baru jika belum ada.
7. Pilih metode pengiriman yang tersedia.
8. Pilih metode pembayaran yang diinginkan.
9. Tinjau pesanan Anda, termasuk rincian produk, alamat pengiriman, dan total pembayaran.
10. Klik tombol "Bayar Sekarang" untuk menyelesaikan pesanan.
11. Ikuti instruksi pembayaran sesuai metode yang dipilih.
12. Setelah pembayaran berhasil, Anda akan menerima konfirmasi pesanan melalui email dan notifikasi di aplikasi.

Catatan: Pastikan stok produk tersedia sebelum melakukan checkout.
''';
    } else if (title == 'Cara mengembalikan produk') {
      content = '''
1. Masuk ke akun Anda di aplikasi Fashion Store.
2. Buka menu "Pesanan Saya" di profil Anda.
3. Pilih pesanan yang berisi produk yang ingin dikembalikan.
4. Klik tombol "Ajukan Pengembalian".
5. Pilih produk yang ingin dikembalikan dan jumlahnya.
6. Pilih alasan pengembalian dari daftar yang tersedia.
7. Unggah foto produk yang menunjukkan masalah (jika diperlukan).
8. Pilih metode pengembalian dana yang diinginkan.
9. Klik "Kirim Permintaan".
10. Tunggu konfirmasi dari tim kami (biasanya dalam 1-2 hari kerja).
11. Setelah permintaan disetujui, Anda akan menerima instruksi untuk mengirimkan produk kembali.
12. Kemas produk dengan baik dalam kemasan aslinya jika memungkinkan.
13. Kirimkan produk sesuai instruksi yang diberikan.
14. Setelah produk diterima dan diperiksa, pengembalian dana akan diproses dalam 3-5 hari kerja.

Kebijakan Pengembalian:
- Pengembalian hanya dapat diajukan dalam waktu 7 hari setelah produk diterima.
- Produk harus dalam kondisi asli, belum dipakai, dengan label dan kemasan utuh.
- Produk diskon atau produk sale mungkin tidak dapat dikembalikan (lihat detail produk).
''';
    } else {
      content = 'Informasi detail tentang "$title" akan segera tersedia. Silakan hubungi customer service kami untuk bantuan lebih lanjut.';
    }

    return Text(
      content,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController _feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantu Kami Meningkatkan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Apa yang kurang dari artikel bantuan ini?'),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                hintText: 'Tulis feedback Anda di sini...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementasi kirim feedback
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terima kasih atas feedback Anda!'),
                ),
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}