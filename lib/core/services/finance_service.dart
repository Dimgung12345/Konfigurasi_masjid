import 'package:dio/dio.dart';
import '../models/rekening.dart';
import '../models/data_transakasi.dart';
import '../models/balance.dart';
import '../models/rekap.dart';
import 'api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FinanceService {
  final Dio _dio = ApiService.instance.client;

  // ---------------- TRANSACTIONS ----------------

  // POST /tenant/finance/transactions
  Future<FinancialTransaction> createTransaction({
    required String cardName,
    required String type, // "penerimaan" / "pengeluaran"
    required int amount,
    String? description,
  }) async {
    final res = await _dio.post("/tenant/finance/transactions", data: {
      "card_name": cardName,
      "type": type,
      "amount": amount,
      "description": description,
    });
    return FinancialTransaction.fromJson(res.data);
  }

  // PUT /tenant/finance/transactions/:id
  Future<FinancialTransaction> updateTransaction(
    int id, {
    String? type,
    int? amount,
    String? description,
  }) async {
    final res = await _dio.put("/tenant/finance/transactions/$id", data: {
      if (type != null) "type": type,
      if (amount != null) "amount": amount,
      if (description != null) "description": description,
    });
    return FinancialTransaction.fromJson(res.data);
  }

  // GET /tenant/finance/transactions?month=YYYY-MM
  Future<List<FinancialTransaction>> getTransactions(String month) async {
    final res = await _dio.get("/tenant/finance/transactions?month=$month", options: Options(extra: {"forceRefresh": true}));

    final raw = res.data;
    List<dynamic> data;

    if (raw is List) {
      data = raw;
    } else if (raw is Map && raw['data'] is List) {
      data = raw['data'];
    } else {
      throw Exception("Unexpected response format: ${raw.runtimeType}");
    }

    // debug log
    print("✅ getTransactions raw length: ${data.length}");
    return data.map((e) => FinancialTransaction.fromJson(e)).toList();
  }

  // DELETE /tenant/finance/transactions/:id?month=YYYY-MM
  Future<void> deleteTransaction(int id, {String? month}) async {
    final query = month != null ? "?month=$month" : "";
    await _dio.delete("/tenant/finance/transactions/$id$query");
  }

  // ---------------- BALANCE ----------------

  // GET /tenant/finance/balance/realtime?month=YYYY-MM
  Future<Balance> getRealtimeBalance(String month) async {
    final res = await _dio.get("/tenant/finance/balance/realtime?month=$month", options: Options(extra: {"forceRefresh": true}));
    return Balance.fromJson(res.data);
  }

  // POST /tenant/finance/balance/close-month
  Future<MonthlyBalance> closeMonth(String month) async {
    final res = await _dio.post("/tenant/finance/balance/close-month", data: {
      "month": month,
    });
    return MonthlyBalance.fromJson(res.data);
  }

  // GET /tenant/finance/balance/monthly?limit=6
  Future<List<MonthlyBalance>> getMonthlyRecap({int limit = 6}) async {
    final res = await _dio.get("/tenant/finance/balance/monthly?limit=$limit", options: Options(extra: {"forceRefresh": true}));
    final raw = res.data;
    List<dynamic> data;

    if (raw is List) {
      data = raw;
    } else if (raw is Map && raw['data'] is List) {
      data = raw['data'];
    } else {
      throw Exception("Unexpected response format: ${raw.runtimeType}");
    }

    return data.map((e) => MonthlyBalance.fromJson(e)).toList();
  }

  // ---------------- CARDS -------------

  // POST /tenant/finance/cards
  Future<FinanceCard> createCard(String cardName, {int initial_balance = 0}) async {
    final res = await _dio.post("/tenant/finance/cards", data: {
      "card_name": cardName,
      "initial_balance": initial_balance,
    });
    return FinanceCard.fromJson(res.data);
  }

  // PUT /tenant/finance/cards/:id
  Future<FinanceCard> updateCard(int id, {String? cardName, String? status, int? current_balance}) async {
    final res = await _dio.put("/tenant/finance/cards/$id", data: {
      if (cardName != null) "card_name": cardName,
      if (status != null) "status": status,
      if (current_balance != null) "current_balance": current_balance,
    });
    return FinanceCard.fromJson(res.data);
  }

  // DELETE /tenant/finance/cards/:id
  Future<void> deleteCard(int id) async {
    await _dio.delete("/tenant/finance/cards/$id");
  }

  // GET /tenant/finance/cards
  Future<List<FinanceCard>> getCards() async {
    final res = await _dio.get("/tenant/finance/cards", options: Options(extra: {"forceRefresh": true}));
    final raw = res.data;
    List<dynamic> data;

    if (raw is List) {
      data = raw;
    } else if (raw is Map && raw['data'] is List) {
      data = raw['data'];
    } else {
      throw Exception("Unexpected response format: ${raw.runtimeType}");
    }

    return data.map((e) => FinanceCard.fromJson(e)).toList();
  }

  Future<MonthlyBalance> getMonthlyRecapDetail(String month) async {
    try {
      final res = await _dio.get("/tenant/finance/report/$month/detail", options: Options(extra: {"forceRefresh": true}));
      return MonthlyBalance.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception("Finance feature not enabled");
      }
      rethrow;
    }
  }

  // GET /tenant/finance/report/:month/pdf
  Future<File> downloadMonthlyRecapPDF(String month) async {
    try {
      final res = await _dio.get(
        "/tenant/finance/report/$month/pdf",
        options: Options(responseType: ResponseType.bytes),
      );

      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/recap_$month.pdf");
      await file.writeAsBytes(res.data);
      return file;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception("Finance feature not enabled");
      }
      rethrow;
    }
  }
}