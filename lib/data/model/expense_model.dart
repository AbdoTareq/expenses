import 'package:expenses/data/model/category_model.dart';

class ExpenseModel {
  final String id;
  final CategoryModel category;
  final String date;
  final String amount;
  final String receipt;

  ExpenseModel({
    required this.id,
    required this.category,
    required this.date,
    required this.amount,
    required this.receipt,
  });

  ExpenseModel copyWith({
    String? id,
    CategoryModel? category,
    String? date,
    String? amount,
    String? receipt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      category: category ?? this.category,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      receipt: receipt ?? this.receipt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'category': category.toMap(),
      'date': date,
      'amount': amount,
      'receipt': receipt,
    };
  }

  factory ExpenseModel.fromJson(Map<dynamic, dynamic> map) {
    return ExpenseModel(
      id: (map['id'] ?? '') as String,
      category: CategoryModel.fromJson(
        map['category'] as Map<dynamic, dynamic>,
      ),
      date: (map['date'] ?? '') as String,
      amount: (map['amount'] ?? '') as String,
      receipt: (map['receipt'] ?? '') as String,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, category: $category, date: $date, amount: $amount, receipt: $receipt)';
  }
}
