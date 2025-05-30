import 'package:flutter/material.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': 1,
      'name': 'Rumah',
      'recipient': 'John Doe',
      'phone': '081234567890',
      'address': 'Jl. Contoh No. 123, Kecamatan Contoh, Kota Contoh, 12345',
      'isDefault': true,
    },
    {
      'id': 2,
      'name': 'Kantor',
      'recipient': 'John Doe',
      'phone': '081234567891',
      'address': 'Jl. Bisnis No. 456, Kecamatan Bisnis, Kota Bisnis, 67890',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Pengiriman'),
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              address['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (address['isDefault'])
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Text(
                                  'Utama',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          address['recipient'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(address['phone']),
                        const SizedBox(height: 4),
                        Text(address['address']),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _editAddress(address),
                              child: const Text('Edit'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => _deleteAddress(address['id']),
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAddress,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada alamat tersimpan',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _addNewAddress,
            child: const Text('Tambah Alamat Baru'),
          ),
        ],
      ),
    );
  }

  void _addNewAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressFormScreen(isEditing: false),
      ),
    );
  }

  void _editAddress(Map<String, dynamic> address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressFormScreen(
          isEditing: true,
          address: address,
        ),
      ),
    );
  }

  void _deleteAddress(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Alamat'),
        content: const Text('Apakah Anda yakin ingin menghapus alamat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeWhere((address) => address['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alamat berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class AddressFormScreen extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? address;

  const AddressFormScreen({
    Key? key,
    required this.isEditing,
    this.address,
  }) : super(key: key);

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _recipientController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.isEditing ? widget.address!['name'] : '',
    );
    _recipientController = TextEditingController(
      text: widget.isEditing ? widget.address!['recipient'] : '',
    );
    _phoneController = TextEditingController(
      text: widget.isEditing ? widget.address!['phone'] : '',
    );
    _addressController = TextEditingController(
      text: widget.isEditing ? widget.address!['address'] : '',
    );
    _isDefault = widget.isEditing ? widget.address!['isDefault'] : false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Alamat' : 'Tambah Alamat Baru'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Label Alamat',
                hintText: 'Contoh: Rumah, Kantor, dll.',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Label alamat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Nama Penerima',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama penerima tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor telepon tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat Lengkap',
                hintText: 'Jalan, Nomor Rumah, RT/RW, Kecamatan, Kota, Kode Pos',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Jadikan sebagai alamat utama'),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveAddress,
              child: Text(widget.isEditing ? 'Simpan Perubahan' : 'Simpan Alamat'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      // Implementasi penyimpanan alamat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Alamat berhasil diperbarui'
                : 'Alamat baru berhasil ditambahkan',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}