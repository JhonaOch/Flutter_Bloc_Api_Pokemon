import 'package:api_bloc_pokemon/model/models/general_model_pokemon.dart';
import 'package:api_bloc_pokemon/model/models/pokemon_models.dart';
import 'package:api_bloc_pokemon/model/repositories/pokemon_repository_dio.dart';
import 'package:dio/dio.dart';

class PokemonServiceDio implements PokemonRepositoryDio {
  PokemonServiceDio()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://pokeapi.co/api/v2/',
          ),
        );

  final Dio _dio;

  @override
  Future<GeneralModelPokemon> fetchPokemons(int? offset, int limit) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'pokemon',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = response.data;
      return GeneralModelPokemon.fromJson(data!);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<PokemonModel> getPokemonName({required String name}) async {
    try {
      final response = await _dio.get(
        'pokemon/$name',
      );
      final data = response.data;
      return PokemonModel.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }
}
