import 'package:api_bloc_pokemon/model/models/ability_model.dart';

class ConstData {
  static final ability = AbilityModel(abilities: [
    Ability(name: 'Intimidacion', hp: -5, attack: 10, defense: -10, speed: 15),
    Ability(name: 'Inmunidad', hp: 20, attack: -20, defense: 20, speed: -10),
    Ability(name: 'Potencia', hp: -20, attack: 15, defense: -10, speed: 15),
    Ability(name: 'Regeneracion', hp: 10, attack: 20, defense: 5, speed: 5),
    Ability(name: 'Impasible', hp: -10, attack: 3, defense: -10, speed: 20),
    Ability(name: 'Toxico', hp: -15, attack: 0, defense: 20, speed: -3),
  ]);


   
}
