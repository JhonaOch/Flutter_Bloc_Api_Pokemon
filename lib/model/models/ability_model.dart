import 'dart:convert';

AbilityModel abilityModelFromJson(String str) =>
    AbilityModel.fromJson(json.decode(str));

String abilityModelToJson(AbilityModel data) => json.encode(data.toJson());

class AbilityModel {
  AbilityModel({
    required this.abilities,
  });

  final List<Ability> abilities;

  factory AbilityModel.fromJson(Map<String, dynamic> json) => AbilityModel(
        abilities: List<Ability>.from(
            json["abilities"].map((x) => Ability.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "abilities": List<dynamic>.from(abilities.map((x) => x.toJson())),
      };
}

class Ability {
  Ability({
    required this.name,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.speed,
  });

  final String name;
  final int hp;
  final int attack;
  final int defense;
  final int speed;

  factory Ability.fromJson(Map<String, dynamic> json) => Ability(
        name: json["name"],
        hp: json["hp"],
        attack: json["attack"],
        defense: json["defense"],
        speed: json["speed"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "hp": hp,
        "attack": attack,
        "defense": defense,
        "speed": speed,
      };
}
