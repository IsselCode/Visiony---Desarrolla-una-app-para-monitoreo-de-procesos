import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';
import 'package:vision_app/features/production/controller/line_state.dart';
import 'package:vision_app/features/production/model/line_model.dart';
import 'package:vision_app/features/production/view/general_statistics.dart';
import 'package:vision_app/features/production/view/line_machine_screen.dart';
import 'package:vision_app/features/widgets/custom_icon_button.dart';
import 'package:vision_app/features/widgets/custom_line_machine_widget.dart';
import 'package:vision_app/features/widgets/custom_search_bar_lines_widget.dart';

class LineProductionScreen extends StatelessWidget {
  const LineProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LineState lineState = context.watch();

    return Scaffold(
      backgroundColor: const Color(0xffECF0F4),
      appBar: AppBar(
        backgroundColor: const Color(0xffECF0F4),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: Row(
          children: [
            /// Botón de estastidisticas
            Expanded(
              child: Row(
                children: [
                  CustomIconButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralStatistics.init(context),));
                      },
                      icon: Icons.dashboard_outlined
                  ),
                ],
              )
            ),
            /// Titulo
            Expanded(
              flex: 3,
              child: Text(
                "Líneas de Producción",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ),

            /// Acciones
            Expanded(
              child: Row(
                children: [
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
                                "Estás a punto de crear una nueva línea",
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
                                              color: Colors.red,
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
                                          await lineState.addNewLine();
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
                  CustomIconButton(
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchBarLinesWidget()
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
        itemCount: lineState.productionLines.length,
        itemBuilder: (context, index) {
          LineModel line = lineState.productionLines[index];
          return CustomLineMachineWidget(
            image: "assets/images/linea.png",
            name: line.name,
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
                        "Estás a punto de eliminar la línea ${line.numero}",
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
                                  await lineState.deleteLine(line.uid);
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
                MaterialPageRoute(builder: (context) => LineMachineScreen.init(context, line),)
              );
            },
          );
        },
      )
    );
  }
}


