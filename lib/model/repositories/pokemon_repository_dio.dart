

import 'package:api_bloc_pokemon/model/models/general_model_pokemon.dart';
import 'package:api_bloc_pokemon/model/models/pokemon_models.dart';

abstract class PokemonRepositoryDio {

  Future<GeneralModelPokemon> fetchPokemons(int? offset,int limit);
  Future<PokemonModel> getPokemonName({required String name});



}