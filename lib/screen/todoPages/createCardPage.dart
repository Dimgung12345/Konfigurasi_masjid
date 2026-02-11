import 'package:flutter/material.dart';
import '../../core/services/finance_service.dart';
import '../widgets/formCard.dart';
import '../widgets/saveButton.dart';

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({super.key});

  @override
  State<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  final _formKey = GlobalKey<FormState>();
  final FinanceService _service = FinanceService();

  final TextEditingController _nameCtrl = TextEditingController();
  int? _initialBalance;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await _service.createCard(
        _nameCtrl.text,
        initial_balance: _initialBalance ?? 0,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Rekening"),
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
            title: "Data Rekening",
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Rekening",
                  hintText: "Contoh: Rekening BRI",
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: "Saldo Awal",
                  hintText: "Masukkan saldo awal",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => _initialBalance = int.tryParse(val),
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