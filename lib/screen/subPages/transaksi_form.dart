// import 'package:dashboard_masjid/screen/subPages/card_page.dart';
import 'package:flutter/material.dart';
import '../../core/services/finance_service.dart';
import '../../core/models/rekening.dart';
import '../widgets/saveButton.dart';
// import '../widgets/finance/navbar.dart';
// import '../subPages/rekap_page.dart';
import '../widgets/formCard.dart'; // pastikan path sesuai

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final FinanceService _service = FinanceService();

  List<FinanceCard> _cards = [];
  String? _selectedCardName;
  DateTime _selectedDate = DateTime.now();
  String _type = "pengeluaran";
  int? _amount;
  String? _description;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _service.getCards();
    setState(() => _cards = cards);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedCardName != null) {
      await _service.createTransaction(
        cardName: _selectedCardName!,
        type: _type,
        amount: _amount!,
        description: _description,
      );
      Navigator.pop(context, true); // kembali ke halaman sebelumnya dengan hasil sukses
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Transaksi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: FormCard(
            title: "Input Transaksi",
            children: [
              // Rekening
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Rekening",
                  prefixIcon: const Icon(Icons.account_balance),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: _cards.map((card) {
                  return DropdownMenuItem(
                    value: card.cardName,
                    child: Text(card.cardName),
                  );
                }).toList(),
                onChanged: (val) => _selectedCardName = val,
              ),
              const SizedBox(height: 16),

              // Tanggal
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                controller: TextEditingController(
                  text: "${_selectedDate.day.toString().padLeft(2, '0')}-"
                        "${_selectedDate.month.toString().padLeft(2, '0')}-"
                        "${_selectedDate.year}",
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 16),

              // Jenis Transaksi
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Jenis Transaksi",
                  prefixIcon: const Icon(Icons.swap_horiz),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                value: _type,
                items: const [
                  DropdownMenuItem(value: "penerimaan", child: Text("Penerimaan")),
                  DropdownMenuItem(value: "pengeluaran", child: Text("Pengeluaran")),
                ],
                onChanged: (val) => _type = val!,
              ),
              const SizedBox(height: 16),

              // Nominal
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nominal (Rp)",
                  hintText: "Masukkan jumlah",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
                onChanged: (val) => _amount = int.tryParse(val),
              ),
              const SizedBox(height: 16),

              // Keterangan
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Keterangan",
                  hintText: "Contoh: Infaq Harian",
                  prefixIcon: const Icon(Icons.text_fields),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (val) => _description = val,
              ),
              const SizedBox(height: 20),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SaveButton(onSave: _submit),
                ),
              ),
            ],
          ),
        ),
      ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: 1,
        //   selectedItemColor: Colors.orange,
        //   unselectedItemColor: Colors.grey,
        //   onTap: (index) {
        //     if (index == 0) {
        //       Navigator.pushReplacement(context,
        //         MaterialPageRoute(builder: (_) => const FinanceCardsPage()));
        //     } else if (index == 2) {
        //       Navigator.pushReplacement(context,
        //         MaterialPageRoute(builder: (_) => const MonthlyRecapPage()));
        //     }
        //   },
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Rekening"),
        //     BottomNavigationBarItem(icon: Icon(Icons.add), label: "Transaksi"),
        //     BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Rekap"),
        //   ],
        // ),
    );
  }
}