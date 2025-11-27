import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entidade representando uma categoria financeira
class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final CategoryType type;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.type,
  });

  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

  @override
  List<Object?> get props => [id, name, icon, colorHex, type];

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? colorHex,
    CategoryType? type,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
    );
  }
}

enum CategoryType {
  income,
  expense;

  String get name {
    switch (this) {
      case CategoryType.income:
        return 'Receita';
      case CategoryType.expense:
        return 'Despesa';
    }
  }
}
