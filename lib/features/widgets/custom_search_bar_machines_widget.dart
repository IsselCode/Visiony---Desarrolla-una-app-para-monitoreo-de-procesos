import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/features/production/controller/machine_state.dart';
import 'package:vision_app/features/production/model/machine_model.dart';

import '../../core/app/decorations/active_neumorphist_decoration.dart';
import '../production/controller/line_state.dart';
import '../production/model/line_model.dart';
import '../production/view/parts_machine_screen.dart';
import 'custom_icon_button.dart';
import 'custom_line_machine_widget.dart';

class CustomSearchBarMachinesWidget extends SearchDelegate {

  MachineState machineState;

  CustomSearchBarMachinesWidget({
    required this.machineState
  });

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => "Buscar";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xffECF0F4)
        ),
        scaffoldBackgroundColor: const Color(0xffECF0F4),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(fontSize: 13),
            border: const OutlineInputBorder(
                borderSide: BorderSide.none
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0)
        )
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20,),
        CustomIconButton(
            onTap: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back_ios_outlined
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return FutureBuilder(
      future: machineState.searchMachinesWithName(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text("Hubo un error"),);
        }

        if (snapshot.hasData && snapshot.data!.length == 0) {
          return Center(child: Text("No hay maquinas con ese nombre"),);
        }

        List<MachineModel> lista = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 20, top: 40, right: 20, left: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 20
          ),
          itemCount: lista.length,
          itemBuilder: (context, index) {
            MachineModel machine = lista[index];
            return CustomLineMachineWidget(
              image: "assets/images/maquina.png",
              name: machine.name,
              onLongPress: () {

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        titleTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20
                        ),
                        title: Text(
                          "Estás a punto de eliminar la maquina ${machine.numero}",
                          textAlign: TextAlign.center,
                        ),
                        actionsPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10) ,
                                    decoration: activeNeumorphistDecoration(bottomLeft: 25),
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 1),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await machineState.deleteMachine(machine.uid);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10) ,
                                    decoration: activeNeumorphistDecoration(bottomRight: 25),
                                    child: Text(
                                      "Eliminar",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                    );
                  },
                );

              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PartsMachineScreen.init(context, machine),)
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }

}