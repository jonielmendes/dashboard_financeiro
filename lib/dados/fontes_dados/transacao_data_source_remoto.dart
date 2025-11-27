import 'package:graphql_flutter/graphql_flutter.dart';
import '../modelos/transacao_model.dart';

/// Data Source Remoto para Transações usando Hasura GraphQL
class TransacaoDataSourceRemoto {
  final GraphQLClient _client;

  TransacaoDataSourceRemoto(this._client);

  /// Query para buscar todas as transações
  static const String _queryBuscarTodas = r'''
    query BuscarTransacoes {
      transacoes(order_by: {data: desc}) {
        id
        titulo
        valor
        categoria_id
        data
        tipo
        descricao
        criado_em
        atualizado_em
      }
    }
  ''';

  /// Query para buscar transações por período
  static const String _queryBuscarPorPeriodo = r'''
    query BuscarTransacoesPorPeriodo($dataInicio: timestamptz!, $dataFim: timestamptz!) {
      transacoes(
        where: {
          data: {_gte: $dataInicio, _lte: $dataFim}
        }
        order_by: {data: desc}
      ) {
        id
        titulo
        valor
        categoria_id
        data
        tipo
        descricao
        criado_em
        atualizado_em
      }
    }
  ''';

  /// Mutation para criar transação
  static const String _mutationCriar = r'''
    mutation CriarTransacao($transacao: transacoes_insert_input!) {
      insert_transacoes_one(object: $transacao) {
        id
      }
    }
  ''';

  /// Mutation para atualizar transação
  static const String _mutationAtualizar = r'''
    mutation AtualizarTransacao($id: String!, $transacao: transacoes_set_input!) {
      update_transacoes_by_pk(pk_columns: {id: $id}, _set: $transacao) {
        id
      }
    }
  ''';

  /// Mutation para deletar transação
  static const String _mutationDeletar = r'''
    mutation DeletarTransacao($id: String!) {
      delete_transacoes_by_pk(id: $id) {
        id
      }
    }
  ''';

  /// Busca todas as transações do servidor
  Future<List<TransacaoModel>> buscarTodas() async {
    final QueryOptions options = QueryOptions(
      document: gql(_queryBuscarTodas),
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw Exception('Erro ao buscar transações: ${result.exception}');
    }

    final List<dynamic> data = result.data?['transacoes'] ?? [];
    return data.map((json) => TransacaoModel.deJson(json)).toList();
  }

  /// Busca transações por período do servidor
  Future<List<TransacaoModel>> buscarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(_queryBuscarPorPeriodo),
      variables: {
        'dataInicio': dataInicio.toIso8601String(),
        'dataFim': dataFim.toIso8601String(),
      },
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw Exception('Erro ao buscar transações por período: ${result.exception}');
    }

    final List<dynamic> data = result.data?['transacoes'] ?? [];
    return data.map((json) => TransacaoModel.deJson(json)).toList();
  }

  /// Cria uma transação no servidor
  Future<void> criar(TransacaoModel transacao) async {
    final MutationOptions options = MutationOptions(
      document: gql(_mutationCriar),
      variables: {
        'transacao': transacao.paraJson(),
      },
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception('Erro ao criar transação: ${result.exception}');
    }
  }

  /// Atualiza uma transação no servidor
  Future<void> atualizar(TransacaoModel transacao) async {
    final MutationOptions options = MutationOptions(
      document: gql(_mutationAtualizar),
      variables: {
        'id': transacao.id,
        'transacao': transacao.paraJson(),
      },
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception('Erro ao atualizar transação: ${result.exception}');
    }
  }

  /// Deleta uma transação no servidor
  Future<void> deletar(String id) async {
    final MutationOptions options = MutationOptions(
      document: gql(_mutationDeletar),
      variables: {
        'id': id,
      },
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception('Erro ao deletar transação: ${result.exception}');
    }
  }
}
