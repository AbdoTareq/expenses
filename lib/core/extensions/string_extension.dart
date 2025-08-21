import 'package:flutter/material.dart';

extension StringExtension on String {
  Color getColorFromHex() =>
      Color(int.parse(toString().replaceAll('#', '0xff')));

  IconData? getIconFromString() {
    switch (this) {
      case 'home':
        return Icons.home;
      case 'movie':
        return Icons.movie;
      case 'rent':
        return Icons.house_siding;
      case 'news':
        return Icons.list;
      case 'gas':
        return Icons.car_rental_outlined;
      case 'shopping_cart':
        return Icons.shopping_cart;
      default:
        return Icons.directions_car;
    }
  }
}
