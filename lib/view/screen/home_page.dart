import 'package:api_bloc_pokemon/model/services/pokemon_service_dio.dart';
import 'package:api_bloc_pokemon/view_model/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> text = [];
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

                for (var element in data) {
                  text = text..add(element.name);
                  final remove = [
                    ...{...text}
                  ];
                  text = remove;
                }

               

                return ListView.separated(
                  itemCount: text.length ~/ 3,
                  controller:
                      BlocProvider.of<HomeBloc>(context).scrollController,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 10,
                      color: Color.fromARGB(255, 136, 0, 255),
                    );
                  },
                  itemBuilder: (context, index) {

                    //final sm = data[index];



                   
                    print(data.length);

                    final List<String> previus=[];
                    final List<String> actual=[];


                   for (var d in data){
                    actual.add(d.name);
                    print(actual);
                   }

                    

                   

                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        ToggleSwitch(
                            borderColor: const [Colors.black],
                            dividerColor: Colors.black,
                            activeBgColor: const [Colors.blue],
                            activeFgColor: Colors.white,
                            cornerRadius: 40.0,
                            inactiveBgColor: Colors.cyan[50],
                            inactiveFgColor: Colors.black,
                            totalSwitches: 3,
                            minWidth: 100,
                            initialLabelIndex: 0,
                            labels: actual,
                            onToggle: (index) {

                            }),
                        
                        Container(
                          color: Colors.red,
                          height: 690,
                        )
                      ],
                    );
                  },
                );
              }
            })));
  }
}
