import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String name;
  final String icon;
  final String color;
  final String id;
  const CategoryModel({
    this.name = '',
    this.icon = '',
    this.color = '',
    this.id = '',
  });

  CategoryModel copyWith({
    String? name,
    String? icon,
    String? color,
    String? id,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'icon': icon,
      'color': color,
      'id': id,
    };
  }

  factory CategoryModel.fromJson(Map<dynamic, dynamic> map) {
    return CategoryModel(
      name: (map['name'] ?? '') as String,
      icon: (map['icon'] ?? '') as String,
      color: (map['color'] ?? '') as String,
      id: (map['id'] ?? '') as String,
    );
  }

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [name, icon, color];
}
