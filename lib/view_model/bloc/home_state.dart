part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  const HomeState({
    this.pokemonData = const <PokemonData>[],
    this.status = HomeStatus.initial,
    this.pokemon ,
    this.hp = 0,
      this.at = 0,
      this.df = 0,
      this.ve = 0
  });

  final List<PokemonData> pokemonData;
  final HomeStatus status;
  final PokemonModel? pokemon;
  final int hp;
  final int at;
  final int df;
  final int ve;

  @override
  List<Object?> get props => [pokemonData, status,pokemon];

  factory HomeState.initialState() => const HomeState();

  HomeState copyWith({
    List<PokemonData>? pokemonData,
    HomeStatus? status,
    PokemonModel? pokemon,
     int? hp,
    int? at,
    int? df,
    int? ve,
  }) =>
      HomeState(
        pokemonData: pokemonData ?? this.pokemonData,
        status: status ?? this.status,
        pokemon: pokemon?? this.pokemon,
         hp: hp ?? this.hp,
          at: at ?? this.at,
          df: df ?? this.df,
          ve: ve ?? this.ve);
      
}

extension HomeStateX on HomeState {
  bool get _pokemomEmpty => pokemonData.isEmpty;
  bool get _error => status == HomeStatus.error;
  bool get pokemonLoading => status == HomeStatus.loading;
  bool get loading => pokemonLoading && _pokemomEmpty;
  bool get error => _error && _pokemomEmpty;
  bool get errorLoadMoreMovie => _error && !_pokemomEmpty;
}
