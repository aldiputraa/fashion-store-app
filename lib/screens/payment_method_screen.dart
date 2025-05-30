import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'bank_transfer',
      'name': 'Transfer Bank',
      'icon': Icons.account_balance,
      'options': [
        {
          'id': 'bca',
          'name': 'Bank BCA',
          'accountNumber': '1234567890',
          'accountName': 'PT Fashion Store',
        },
        {
          'id': 'bni',
          'name': 'Bank BNI',
          'accountNumber': '0987654321',
          'accountName': 'PT Fashion Store',
        },
        {
          'id': 'mandiri',
          'name': 'Bank Mandiri',
          'accountNumber': '1122334455',
          'accountName': 'PT Fashion Store',
        },
      ],
    },
    {
      'id': 'e_wallet',
      'name': 'E-Wallet',
      'icon': Icons.account_balance_wallet,
      'options': [
        {'id': 'gopay', 'name': 'GoPay'},
        {'id': 'ovo', 'name': 'OVO'},
        {'id': 'dana', 'name': 'DANA'},
      ],
    },
    {
      'id': 'cod',
      'name': 'Bayar di Tempat (COD)',
      'icon': Icons.local_shipping,
      'options': [],
    },
    {
      'id': 'credit_card',
      'name': 'Kartu Kredit/Debit',
      'icon': Icons.credit_card,
      'options': [],
    },
  ];

  String _selectedPaymentMethod = '';
  String _selectedPaymentOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildPaymentMethodsList(),
          const SizedBox(height: 24),
          if (_selectedPaymentMethod.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _confirmPaymentMethod,
              child: const Text('Konfirmasi Metode Pembayaran'),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildPaymentMethodsList() {
    List<Widget> widgets = [];

    for (var method in _paymentMethods) {
      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: Icon(method['icon']),
            title: Text(method['name']),
            children: _buildPaymentOptions(method),
            onExpansionChanged: (expanded) {
              if (expanded) {
                setState(() {
                  _selectedPaymentMethod = method['id'];
                  if (method['options'].isEmpty) {
                    _selectedPaymentOption = method['id'];
                  } else {
                    _selectedPaymentOption = '';
                  }
                });
              }
            },
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildPaymentOptions(Map<String, dynamic> method) {
    List<Widget> options = [];

    if (method['options'].isEmpty) {
      options.add(
        ListTile(
          title: const Text('Bayar langsung saat pesanan tiba'),
          trailing: Radio<String>(
            value: method['id'],
            groupValue: _selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                _selectedPaymentOption = value!;
              });
            },
          ),
        ),
      );
    } else {
      for (var option in method['options']) {
        options.add(
          ListTile(
            title: Text(option['name']),
            subtitle: option.containsKey('accountNumber')
                ? Text('${option['accountNumber']} (${option['accountName']})')
                : null,
            trailing: Radio<String>(
              value: option['id'],
              groupValue: _selectedPaymentOption,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentOption = value!;
                });
              },
            ),
          ),
        );
      }
    }

    return options;
  }

  void _confirmPaymentMethod() {
    // Implementasi konfirmasi metode pembayaran
    String methodName = '';
    String optionName = '';

    for (var method in _paymentMethods) {
      if (method['id'] == _selectedPaymentMethod) {
        methodName = method['name'];
        if (method['options'].isEmpty) {
          optionName = methodName;
        } else {
          for (var option in method['options']) {
            if (option['id'] == _selectedPaymentOption) {
              optionName = option['name'];
              break;
            }
          }
        }
        break;
      }
    }

    if (_selectedPaymentOption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih opsi pembayaran'),
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'method': _selectedPaymentMethod,
      'option': _selectedPaymentOption,
      'methodName': methodName,
      'optionName': optionName,
    });
  }
}

class PaymentConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> paymentDetails;
  final double amount;

  const PaymentConfirmationScreen({
    Key? key,
    required this.paymentDetails,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran'),
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
                      'Rincian Pembayaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Metode Pembayaran', paymentDetails['methodName']),
                    if (paymentDetails['methodName'] != paymentDetails['optionName'])
                      _buildInfoRow('Opsi Pembayaran', paymentDetails['optionName']),
                    _buildInfoRow('Total Pembayaran', 'Rp ${amount.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (paymentDetails['method'] == 'bank_transfer') ...[
              _buildBankTransferInstructions(paymentDetails),
            ] else if (paymentDetails['method'] == 'e_wallet') ...[
              _buildEWalletInstructions(paymentDetails),
            ] else if (paymentDetails['method'] == 'cod') ...[
              _buildCODInstructions(),
            ] else if (paymentDetails['method'] == 'credit_card') ...[
              _buildCreditCardForm(),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implementasi konfirmasi pembayaran
                  Navigator.pop(context, true);
                },
                child: const Text('Konfirmasi Pembayaran'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBankTransferInstructions(Map<String, dynamic> details) {
    String accountNumber = '';
    String accountName = '';

    // Contoh data untuk demo
    if (details['option'] == 'bca') {
      accountNumber = '1234567890';
      accountName = 'PT Fashion Store';
    } else if (details['option'] == 'bni') {
      accountNumber = '0987654321';
      accountName = 'PT Fashion Store';
    } else if (details['option'] == 'mandiri') {
      accountNumber = '1122334455';
      accountName = 'PT Fashion Store';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instruksi Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Bank: ${details['optionName']}'),
            const SizedBox(height: 8),
            Text('Nomor Rekening: $accountNumber'),
            const SizedBox(height: 8),
            Text('Atas Nama: $accountName'),
            const SizedBox(height: 16),
            const Text(
              'Catatan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Silakan transfer sesuai dengan jumlah yang tertera.\n'
              '2. Setelah transfer, simpan bukti pembayaran.\n'
              '3. Pesanan akan diproses setelah pembayaran dikonfirmasi.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEWalletInstructions(Map<String, dynamic> details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instruksi Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('E-Wallet: ${details['optionName']}'),
            const SizedBox(height: 16),
            const Text(
              'Langkah-langkah:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Buka aplikasi ${/* details['optionName'] */} di smartphone Anda.\n'
              '2. Scan QR code di bawah ini atau masukkan nomor tujuan.\n'
              '3. Masukkan jumlah pembayaran sesuai dengan total belanja.\n'
              '4. Konfirmasi dan selesaikan pembayaran.\n'
              '5. Simpan bukti pembayaran.',
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 200,
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('QR Code'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCODInstructions() {
    return Card(
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Bayar di Tempat (COD)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Pesanan Anda akan dikirim ke alamat yang telah ditentukan.\n'
              '2. Siapkan uang tunai sesuai dengan total belanja.\n'
              '3. Pembayaran dilakukan saat pesanan tiba.\n'
              '4. Pastikan Anda atau orang yang menerima pesanan dapat melakukan pembayaran.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Kartu Kredit/Debit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nomor Kartu',
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Kadaluarsa',
                      hintText: 'MM/YY',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nama pada Kartu',
                hintText: 'JOHN DOE',
              ),
            ),
          ],
        ),
      ),
    );
  }
}