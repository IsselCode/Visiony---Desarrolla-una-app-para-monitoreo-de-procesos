import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';
import 'package:vision_app/features/production/controller/line_state.dart';
import 'package:vision_app/features/production/controller/machine_state.dart';
import 'package:vision_app/features/production/model/line_model.dart';
import 'package:vision_app/features/production/model/machine_model.dart';
import 'package:vision_app/features/production/view/parts_machine_screen.dart';
import 'package:vision_app/features/widgets/custom_icon_button.dart';
import 'package:vision_app/features/widgets/custom_line_machine_widget.dart';
import 'package:vision_app/features/widgets/custom_search_bar_lines_widget.dart';
import 'package:vision_app/features/widgets/custom_search_bar_machines_widget.dart';

// CTRL + W
// SHIFT + CTRL + ALT + J
// MAYUS + CTRL + ALT + J

class LineMachineScreen extends StatelessWidget {

  LineModel linea;

  LineMachineScreen._({
    required this.linea
  });

  static Widget init(BuildContext context, LineModel linea) {
    return ChangeNotifierProvider(
      create: (context) => MachineState(
          firestore: context.read(),
          uidLine: linea.uid
        )..getAllMachines(),
      builder: (context, child) => LineMachineScreen._(linea: linea,),
    );
  }

  @override
  Widget build(BuildContext context) {
    MachineState machineState = context.watch();

    return Scaffold(
        backgroundColor: const Color(0xffECF0F4),
        appBar: AppBar(
          backgroundColor: const Color(0xffECF0F4),
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 20,
          title: Row(
            children: [
              /// Botón para regresar
              Expanded(
                  child: Row(
                    children: [
                      CustomIconButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          icon: Icons.arrow_back_ios_outlined
                      ),
                    ],
                  )
              ),
              /// Titulo
              Expanded(
                  flex: 3,
                  child: Text(
                    linea.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
              ),

              /// Acciones
              Expanded(
                child: Row(
                  children: [
                    /// CREAR UNA MAQUINA NUEVA
                    CustomIconButton(
                        onTap: () {

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
                                    "Estás a punto de crear una nueva maquina",
                                    textAlign: TextAlign.center,
                                  ),
                                  actionsPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  actions: [
                                    Row(
                                      children: [
                                        /// Boton de cancelar
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10) ,
                                              decoration: activeNeumorphistDecoration(bottomLeft: 25),
                                              child: Text(
                                                "Cancelar",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 1),
                                        /// BOTON DE CREAR NUEVA MAQUINA
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              await machineState.addNewMachine();
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10) ,
                                              decoration: activeNeumorphistDecoration(bottomRight: 25),
                                              child: Text(
                                                "Aceptar",
                                                style: TextStyle(
                                                    color: Colors.black,
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
                        icon: Icons.add_outlined
                    ),
                    const SizedBox(width: 5,),
                    /// BUSCAR MAQUINAS POR NOMBRE
                    CustomIconButton(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearchBarMachinesWidget(
                              machineState: context.read()
                            )
                          );
                        },
                        icon: Icons.search_outlined
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.only(bottom: 20, top: 40, right: 20, left: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 20
          ),
          itemCount: machineState.machines.length,
          itemBuilder: (context, index) {
            MachineModel machine = machineState.machines[index];
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
        )
    );
  }
}


