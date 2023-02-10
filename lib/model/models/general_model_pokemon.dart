
import 'dart:convert';

GeneralModelPokemon generalModelPokemonFromJson(String str) => GeneralModelPokemon.fromJson(json.decode(str));

String generalModelPokemonToJson(GeneralModelPokemon data) => json.encode(data.toJson());

class GeneralModelPokemon {
    GeneralModelPokemon({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    final int count;
    final String next;
    final String previous;
    final List<PokemonData> results;

    factory GeneralModelPokemon.fromJson(Map<String, dynamic> json) => GeneralModelPokemon(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<PokemonData>.from(json["results"].map((x) => PokemonData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class PokemonData {
    PokemonData({
        required this.name,
        required this.url,
    });

    final String name;
    final String url;

    factory PokemonData.fromJson(Map<String, dynamic> json) => PokemonData(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}
