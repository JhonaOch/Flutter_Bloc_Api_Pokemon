import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:api_bloc_pokemon/model/models/general_model_pokemon.dart';
import 'package:api_bloc_pokemon/model/repositories/pokemon_repository_dio.dart';

import '../../model/models/pokemon_models.dart';
import '../../view/const.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(HomeState.initialState()) {
    on<_FetchPokemon>(_fetchPokemon);
    on<_GetName>(_getName);
    on<_MoreAbility>(_moreAbility);
    on<_ReduceAbility>(_reduceAbility);
  }

  final PokemonRepositoryDio _repository;
  late final ScrollController _scrollController;
  
  final _limit = 3;
  var _offset = 0;
  var _hasNextPage = true;
 
  int hp = 0;
  int at = 0;
  int df = 0;
  int ve = 0;

  ScrollController get scrollController => _scrollController;
   get hasNextPage => _hasNextPage;


  void init() {
    _scrollController = ScrollController()..addListener(_listener);
  }

  void _listener() {
    final position = _scrollController.position;
    final maxScrollExtend = position.maxScrollExtent;
    final pixel = position.pixels + 40;
    final hasPaginate = pixel > maxScrollExtend && _hasNextPage;
    if (hasPaginate && !state.pokemonLoading) {
     

        add(HomeEvent.onFecthPokemon());
       
      
    
      
    }
  }
  @override
  Future<void> close() {
    _scrollController
      ..removeListener(_listener)
      ..dispose();
    return super.close();
  }

  FutureOr<void> _fetchPokemon(
      _FetchPokemon event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
   

    try {
     
      final pokemonsResult = await _repository.fetchPokemons(_offset, _limit);
      _offset +=  3;
      _hasNextPage= _offset <= pokemonsResult.count;
   
      emit(state.copyWith(pokemonData: pokemonsResult.results, status: HomeStatus.success));
      add(HomeEvent.onGetName(name: pokemonsResult.results[0].name));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  Future<void> _getName(_GetName event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      if (event.name.isNotEmpty) {
        final pokemonsResult =
            await _repository.getPokemonName(name: event.name.toString());
        emit(state.copyWith(
            pokemon: pokemonsResult, status: HomeStatus.success));
      } else {
        final pokemonsResult =
            await _repository.getPokemonName(name: 'bulbasaur');
        emit(state.copyWith(
            pokemon: pokemonsResult, status: HomeStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  FutureOr<void> _moreAbility(
      _MoreAbility event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      if (event.name.isNotEmpty) {
        final data = ConstData.ability.abilities;

        for (var element in data) {
          if (element.name == event.name) {
            hp += element.hp;
            at += element.attack;
            df += element.defense;
            ve += element.speed;
            emit(state.copyWith(
                hp: hp, at: at, df: df, ve: ve, status: HomeStatus.success));
          }
        }
      }
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  FutureOr<void> _reduceAbility(_ReduceAbility event, Emitter<HomeState> emit) {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      if (event.name.isNotEmpty) {
        final data = ConstData.ability.abilities;

        for (var element in data) {
          if (element.name == event.name) {
            hp -= element.hp;
            at -= element.attack;
            df -= element.defense;
            ve -= element.speed;
            emit(state.copyWith(
                hp: hp, at: at, df: df, ve: ve, status: HomeStatus.success));
          }
        }
      }
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }
}
