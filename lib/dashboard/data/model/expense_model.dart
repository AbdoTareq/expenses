import 'package:expenses/dashboard/data/model/category_model.dart';

class ExpenseModel {
  final String id;
  final String name;
  final String color;
  final CategoryModel category;
  final String date;
  final String amount;
  final String note;
  final String receipt;

  ExpenseModel({
    required this.id,
    required this.name,
    this.color = '',
    required this.category,
    required this.date,
    required this.amount,
    required this.note,
    required this.receipt,
  });

  ExpenseModel copyWith({
    String? id,
    String? name,
    String? color,
    CategoryModel? category,
    String? date,
    String? amount,
    String? note,
    String? receipt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      category: category ?? this.category,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      receipt: receipt ?? this.receipt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
      'category': category.toMap(),
      'date': date,
      'amount': amount,
      'note': note,
      'receipt': receipt,
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> map) {
    return ExpenseModel(
      id: (map['id'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      color: (map['color'] ?? '') as String,
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      date: (map['date'] ?? '') as String,
      amount: (map['amount'] ?? '') as String,
      note: (map['note'] ?? '') as String,
      receipt: (map['receipt'] ?? '') as String,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, name: $name, color: $color, category: $category, date: $date, amount: $amount, note: $note, receipt: $receipt)';
  }
}
