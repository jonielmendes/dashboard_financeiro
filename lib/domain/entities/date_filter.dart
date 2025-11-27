import 'package:equatable/equatable.dart';

/// Filtro de data para relatórios
class DateFilter extends Equatable {
  final DateFilterType type;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const DateFilter({
    required this.type,
    this.customStartDate,
    this.customEndDate,
  });

  /// Calcula a data de início baseada no tipo de filtro
  DateTime get startDate {
    final now = DateTime.now();
    switch (type) {
      case DateFilterType.last7Days:
        return DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
      case DateFilterType.last30Days:
        return DateTime(now.year, now.month, now.day).subtract(const Duration(days: 29));
      case DateFilterType.currentMonth:
        return DateTime(now.year, now.month, 1);
      case DateFilterType.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return lastMonth;
      case DateFilterType.currentYear:
        return DateTime(now.year, 1, 1);
      case DateFilterType.custom:
        return customStartDate ?? DateTime(now.year, now.month, 1);
    }
  }

  /// Calcula a data de fim baseada no tipo de filtro
  DateTime get endDate {
    final now = DateTime.now();
    switch (type) {
      case DateFilterType.last7Days:
      case DateFilterType.last30Days:
      case DateFilterType.currentMonth:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case DateFilterType.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
        return firstDayOfCurrentMonth.subtract(const Duration(seconds: 1));
      case DateFilterType.currentYear:
        return DateTime(now.year, 12, 31, 23, 59, 59);
      case DateFilterType.custom:
        return customEndDate ?? DateTime(now.year, now.month, now.day, 23, 59, 59);
    }
  }

  String get label {
    switch (type) {
      case DateFilterType.last7Days:
        return 'Últimos 7 dias';
      case DateFilterType.last30Days:
        return 'Últimos 30 dias';
      case DateFilterType.currentMonth:
        return 'Mês Atual';
      case DateFilterType.lastMonth:
        return 'Mês Anterior';
      case DateFilterType.currentYear:
        return 'Ano Atual';
      case DateFilterType.custom:
        return 'Personalizado';
    }
  }

  @override
  List<Object?> get props => [type, customStartDate, customEndDate];
}

enum DateFilterType {
  last7Days,
  last30Days,
  currentMonth,
  lastMonth,
  currentYear,
  custom,
}
