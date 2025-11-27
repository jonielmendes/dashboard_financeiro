import 'package:equatable/equatable.dart';

/// Filtro de data para relatórios
class FiltroData extends Equatable {
  final TipoFiltroData tipo;
  final DateTime? dataInicioPersonalizada;
  final DateTime? dataFimPersonalizada;

  const FiltroData({
    required this.tipo,
    this.dataInicioPersonalizada,
    this.dataFimPersonalizada,
  });

  /// Calcula a data de início baseada no tipo de filtro
  DateTime get dataInicio {
    final agora = DateTime.now();
    switch (tipo) {
      case TipoFiltroData.ultimos7Dias:
        return DateTime(agora.year, agora.month, agora.day).subtract(const Duration(days: 6));
      case TipoFiltroData.ultimos30Dias:
        return DateTime(agora.year, agora.month, agora.day).subtract(const Duration(days: 29));
      case TipoFiltroData.mesAtual:
        return DateTime(agora.year, agora.month, 1);
      case TipoFiltroData.mesAnterior:
        return DateTime(agora.year, agora.month - 1, 1);
      case TipoFiltroData.anoAtual:
        return DateTime(agora.year, 1, 1);
      case TipoFiltroData.personalizado:
        return dataInicioPersonalizada ?? DateTime(agora.year, agora.month, 1);
    }
  }

  /// Calcula a data de fim baseada no tipo de filtro
  DateTime get dataFim {
    final agora = DateTime.now();
    switch (tipo) {
      case TipoFiltroData.ultimos7Dias:
      case TipoFiltroData.ultimos30Dias:
      case TipoFiltroData.mesAtual:
        return DateTime(agora.year, agora.month, agora.day, 23, 59, 59);
      case TipoFiltroData.mesAnterior:
        final primeiroDiaMesAtual = DateTime(agora.year, agora.month, 1);
        return primeiroDiaMesAtual.subtract(const Duration(seconds: 1));
      case TipoFiltroData.anoAtual:
        return DateTime(agora.year, 12, 31, 23, 59, 59);
      case TipoFiltroData.personalizado:
        return dataFimPersonalizada ?? DateTime(agora.year, agora.month, agora.day, 23, 59, 59);
    }
  }

  String get rotulo {
    switch (tipo) {
      case TipoFiltroData.ultimos7Dias:
        return 'Últimos 7 dias';
      case TipoFiltroData.ultimos30Dias:
        return 'Últimos 30 dias';
      case TipoFiltroData.mesAtual:
        return 'Mês Atual';
      case TipoFiltroData.mesAnterior:
        return 'Mês Anterior';
      case TipoFiltroData.anoAtual:
        return 'Ano Atual';
      case TipoFiltroData.personalizado:
        return 'Personalizado';
    }
  }

  @override
  List<Object?> get props => [tipo, dataInicioPersonalizada, dataFimPersonalizada];
}

enum TipoFiltroData {
  ultimos7Dias,
  ultimos30Dias,
  mesAtual,
  mesAnterior,
  anoAtual,
  personalizado,
}
