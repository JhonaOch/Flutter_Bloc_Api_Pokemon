part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();

  factory HomeEvent.onFecthPokemon() => _FetchPokemon();
  factory HomeEvent.onGetName({required String name}) => _GetName(name: name);
  factory HomeEvent.onMoreAbility({required String name}) =>
      _MoreAbility(name: name);
  factory HomeEvent.onReduceAbility({required String name}) =>
      _ReduceAbility(name: name);
}

class _FetchPokemon implements HomeEvent {}

class _GetName implements HomeEvent {
  String name;
  _GetName({required this.name});
}

class _MoreAbility implements HomeEvent {
  String name;
  _MoreAbility({required this.name});
}

class _ReduceAbility implements HomeEvent {
  String name;
  _ReduceAbility({required this.name});
}
