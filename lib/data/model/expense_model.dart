import 'package:expenses/data/model/category_model.dart';

class ExpenseModel {
  final String? id;
  final CategoryModel category;
  final String date;
  final String amount;
  final String receipt;

  ExpenseModel({
    this.id,
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

class ExpensesWrapper {
  bool? success;
  String? message;
  List<ExpenseModel>? data;
  num? page;
  num? limit;
  num? total;

  ExpensesWrapper({
    this.success,
    this.message,
    this.data,
    this.page,
    this.limit,
    this.total,
  });

  ExpensesWrapper.fromJson(Map<dynamic, dynamic> json) {
    success = json['success'];
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <ExpenseModel>[];
      json['data'].forEach((v) {
        data!.add(new ExpenseModel.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    return data;
  }
}
