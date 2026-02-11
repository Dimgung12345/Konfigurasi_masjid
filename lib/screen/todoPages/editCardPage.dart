import 'package:flutter/material.dart';
import '../../core/services/finance_service.dart';
import '../../core/models/rekening.dart';
import '../widgets/formCard.dart';
import '../widgets/saveButton.dart';

class EditCardPage extends StatefulWidget {
  final FinanceCard card;

  const EditCardPage({super.key, required this.card});

  @override
  State<EditCardPage> createState() => _EditCardPageState();
}

class _EditCardPageState extends State<EditCardPage> {
  final _formKey = GlobalKey<FormState>();
  final FinanceService _service = FinanceService();

  late TextEditingController _nameCtrl;
  late TextEditingController _balanceCtrl;
  String? _statusValue; // ⬅️ ganti controller dengan variabel

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.card.cardName);
    _balanceCtrl = TextEditingController(text: widget.card.currentBalance.toString());

    // pastikan status cocok dengan salah satu item
    final status = widget.card.status.toLowerCase();
    if (["aktif", "nonaktif"].contains(status)) {
      _statusValue = status;
    } else {
      _statusValue = "aktif"; // fallback
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await _service.updateCard(
        widget.card.id,
        cardName: _nameCtrl.text,
        status: _statusValue,
        current_balance: int.tryParse(_balanceCtrl.text),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Rekening"),
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
            title: "Edit Data Rekening",
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Rekening",
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _statusValue,
                decoration: InputDecoration(
                  labelText: "Status",
                  prefixIcon: const Icon(Icons.check_circle),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: const [
                  DropdownMenuItem(value: "aktif", child: Text("Aktif")),
                  DropdownMenuItem(value: "nonaktif", child: Text("Nonaktif")),
                ],
                onChanged: (val) {
                  setState(() => _statusValue = val);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _balanceCtrl,
                decoration: InputDecoration(
                  labelText: "Saldo",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.number,
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
    );
  }
}