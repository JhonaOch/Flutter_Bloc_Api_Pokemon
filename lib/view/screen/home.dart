import 'package:api_bloc_pokemon/model/services/pokemon_service_dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:toggle_switch/toggle_switch.dart';

import '../../model/models/general_model_pokemon.dart';
import '../../model/models/pokemon_models.dart';
import '../../view_model/bloc/home_bloc.dart';
import '../const.dart';

class Homee extends StatefulWidget {
  const Homee({super.key});

  @override
  State<Homee> createState() => _HomeeState();
}

class _HomeeState extends State<Homee> {
  List<String> vector = [];
  int hp = 0;
  int at = 0;
  int df = 0;
  int ve = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeBloc(PokemonServiceDio())
          ..init()
          ..add(HomeEvent.onFecthPokemon()),
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state.pokemon == null) {
                    Container();
                  }
                },
                builder: (context, state) {
                  if (state.pokemon != null) {
                    final text = state.pokemon!.name;
                    return Text(text[0].toUpperCase() +
                        text.substring(1).toLowerCase());
                  }
                  return Container();
                },
              ),
            ),
            body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.error) {
                return const Center(
                  child: Text('Error data'),
                );
              } else {
                final data = state.pokemonData;

                if (state.pokemon != null) {
                  hp = state.pokemon!.stats[0].baseStat + state.hp;
                  at = state.pokemon!.stats[1].baseStat + state.at;
                  df = state.pokemon!.stats[2].baseStat + state.df;
                  ve = state.pokemon!.stats[5].baseStat + state.ve;
                }

                // for (var element in data) {
                //     vector.add(element.name[0].toUpperCase() +
                //         element.name.substring(1).toLowerCase());

                // }

                return data.isNotEmpty
                    ? Body(
                        data: data,
                        state: state,
                        at: at,
                        df: df,
                        hp: hp,
                        ve: ve,
                      )
                    : Container();
              }
            })));
  }
}

class Body extends StatefulWidget {
  const Body(
      {super.key,
      required this.data,
      required this.state,
      required this.hp,
      required this.at,
      required this.df,
      required this.ve});
  final List<PokemonData> data;
  final HomeState state;
  final int hp;
  final int at;
  final int df;
  final int ve;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int i = 0;
  List<String> dataRaw = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    validator();
    final homeBloc = context.read<HomeBloc>();
    return RefreshIndicator(
        onRefresh: () {
          return Future.value();
        },
        child: ListView(controller: homeBloc.scrollController, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Toggle(dataRaw: dataRaw),
              const SizedBox(
                height: 20,
              ),
              const Ability(),
              ImageSrc(pokemonModel: widget.state.pokemon),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              const SizedBox(height: 10,),
              IndicatorCaracters(name: 'Vida', percent: widget.hp),
              IndicatorCaracters(name: 'Ataque', percent: widget.at),
              IndicatorCaracters(name: 'Defensa', percent: widget.df),
              IndicatorCaracters(name: 'Velocidad', percent: widget.ve),
            ],
          )
        ]));
  }

  void validator() {
    setState(() {
      for (var element in widget.data) {
        if (dataRaw.length == 3) {
          dataRaw.clear();
          dataRaw = dataRaw..add(element.name);
          final remove = [
            ...{...dataRaw}
          ];
          dataRaw = remove;
          // if(dataRaw.length==1){
          //   dataRaw.addAll(["",""]);
          // }
        } else {
          dataRaw = dataRaw..add(element.name);
          final remove = [
            ...{...dataRaw}
          ];
          dataRaw = remove;
        }

        //print(dataRaw);
      }
    });
  }
}

class Toggle extends StatefulWidget {
  const Toggle({super.key, required this.dataRaw});
  final List<String> dataRaw;

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ToggleSwitch(
            borderColor: const [Colors.black],
            dividerColor: Colors.black,
            activeBgColor: const [Colors.blue],
            activeFgColor: Colors.white,
            cornerRadius: 40.0,
            inactiveBgColor: Colors.cyan[50],
            inactiveFgColor: Colors.black,
            totalSwitches: 3,
            minWidth: 100,
            initialLabelIndex: i,
            labels: widget.dataRaw,
            onToggle: (index) {
              setState(() {
                if (widget.dataRaw.length == 3) {
                  i = index!;
                  BlocProvider.of<HomeBloc>(context).add(HomeEvent.onGetName(
                      name: widget.dataRaw[i].toLowerCase()));
                } else {
                  BlocProvider.of<HomeBloc>(context).add(HomeEvent.onGetName(
                      name: widget.dataRaw[0].toLowerCase()));
                }
              });
            }),
      ),
    );
  }
}

class IndicatorCaracters extends StatelessWidget {
  final String name;
  final int percent;
  const IndicatorCaracters({
    Key? key,
    required this.name,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double porcentaje = percent * 1.0 / 250;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: LinearPercentIndicator(
            barRadius: const Radius.circular(8),
            alignment: MainAxisAlignment.spaceBetween,
            width: 200.0,
            animation: true,
            animationDuration: 1000,
            lineHeight: 25.0,
            leading: Text(
              name,
              style: const TextStyle(color: Colors.black, fontSize: 25),
            ),
            percent: porcentaje,
            center: Text(
              "${(porcentaje * 100).toStringAsFixed(2)} U.",
            ),
            progressColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class Ability extends StatefulWidget {
  const Ability({
    Key? key,
  }) : super(key: key);

  @override
  State<Ability> createState() => _AbilityState();
}

class _AbilityState extends State<Ability> {
  List<String> valores = [];
  List<dynamic> habilidad = [];
  final data = ConstData.ability.abilities;
  bool val = false;

  @override
  void initState() {
    super.initState();
    for (var element in data) {
      habilidad.add(element.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Habilidades',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GroupButton(
            options: GroupButtonOptions(
                spacing: 18,
                buttonWidth: 114,
                buttonHeight: 40,
                unselectedBorderColor: Colors.black,
                borderRadius: BorderRadius.circular(15),
                unselectedColor: Colors.cyan[50],
                direction: Axis.horizontal,
                mainGroupAlignment: MainGroupAlignment.center,
                crossGroupAlignment: CrossGroupAlignment.center,
                selectedTextStyle: const TextStyle(fontSize: 15),
                groupingType: GroupingType.wrap),
            maxSelected: 2,
            isRadio: false,
            onSelected: ((value, index, isSelected) {
              setState(() {
                if (valores.contains(value)) {
                  valores.remove(value);
                  bloc.add(HomeEvent.onReduceAbility(name: value.toString()));
                } else if (valores.length < 2) {
                  valores.add(value.toString());
                  bloc.add(HomeEvent.onMoreAbility(name: value.toString()));
                } else {}
              });
            }),
            //

            buttons: habilidad),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.info_outlined),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  'Informacion de las habilidades seleccionadas',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  valores.isEmpty
                      ? '"Datos de la habilidad selecionada"'
                      : valores.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageSrc extends StatelessWidget {
  final PokemonModel? pokemonModel;

  const ImageSrc({super.key, required this.pokemonModel});

  @override
  Widget build(BuildContext context) {
    var src = '';
    var data = pokemonModel;

    if (data != null) {
      src = data.sprites.frontDefault;
    }

    return src.toString().isNotEmpty
        ? SizedBox(
            width: 300,
            height: 260,
            child: Image.network(
              src,
              scale: 0.05,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          )
        : Container();
  }
}
