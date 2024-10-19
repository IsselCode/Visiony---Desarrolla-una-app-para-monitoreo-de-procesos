import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';
import 'package:vision_app/features/production/controller/parts_state.dart';
import 'package:vision_app/features/production/model/part_model.dart';
import 'package:vision_app/features/production/view/machine_statistics.dart';
import 'package:vision_app/features/widgets/custom_search_bar_parts_widget.dart';

import '../../widgets/custom_icon_button.dart';
import '../model/machine_model.dart';

class PartsMachineScreen extends StatelessWidget {

  MachineModel machine;

  PartsMachineScreen._({
    required this.machine
  });

  static Widget init(BuildContext context, MachineModel machine) {
    return ChangeNotifierProvider(
      create: (context) => PartsState(
        firestore: context.read(),
        uidMachine: machine.uid,
        uidLine: machine.lineaId
      )..startListening(),
      builder: (context, child) => PartsMachineScreen._(machine: machine,),
    );
  }


  @override
  Widget build(BuildContext context) {
    PartsState partsState = context.watch();

    return Scaffold(
      backgroundColor: const Color(0xffECF0F4),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999)
        ),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MachineStatistics.init(
                context,
                machine.lineaId,
                machine.uid,
                machine.numero
              ),));
        },
        child: Icon(Icons.dashboard_outlined),
      ),
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
                  "Partes de ${machine.name}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
            ),

            /// Acciones
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!partsState.filterActivated)
                    ...[
                      /// Seleccionar rango de fecha y hora
                      CustomIconButton(
                          onTap: () async {

                            List<DateTime>? result = await showOmniDateTimeRangePicker(
                                context: context,
                                // Inicio de primer fecha
                                startInitialDate: DateTime.now(),
                                // Maximo de primer fecha
                                startLastDate: DateTime.now(),
                                // Minimo de primer fecha
                                startFirstDate: DateTime.now().subtract(const Duration(days: 30)),

                                // Inicio de segunda fecha
                                endInitialDate: DateTime.now(),
                                // Maximo de segunda fecha
                                endLastDate: DateTime.now(),
                                // Minimo de segunda fecha
                                endFirstDate: DateTime.now().subtract(const Duration(days: 30)),

                                // Evitar que al presionar el barrier se quite el dialogo
                                barrierDismissible: false,
                                // Aplicar intervalos de 60 segundos en los minutos para que
                                // Solo se puedan cambiar las horas
                                minutesInterval: 60,
                                // Desactivar el modo de 24 horas
                                is24HourMode: true,
                                // Forzar los 2 digitos
                                isForce2Digits: true,
                                // Aplicar un radio de 25 total
                                borderRadius: const BorderRadius.all(Radius.circular(25))
                            );

                            if (result != null){
                              partsState.filterActivated = true;
                              await partsState.searchPartsByDateRange(result);
                            }

                          },
                          icon: Icons.calendar_month_outlined
                      ),
                      const SizedBox(width: 5,),
                      /// BUSCAR Partes POR numero de pieza
                      CustomIconButton(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: CustomSearchBarPartsWidget(partsState: partsState)
                            );
                          },
                          icon: Icons.search_outlined
                      ),
                    ],
                  if (partsState.filterActivated)
                    CustomIconButton(
                        onTap: () {
                          partsState.filterActivated = false;
                        },
                        icon: Icons.cancel_outlined
                    ),
                ],
              ),
            )

          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: 20, top: 40, right: 20, left: 20),
        physics: BouncingScrollPhysics(),
        itemCount: partsState.showParts.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10,);
        },
        itemBuilder: (context, index) {
          PartModel partModel = partsState.showParts[index];
          return ListTilePartWidget(
            onTap: () {
              showFlexibleBottomSheet(
                bottomSheetColor: Colors.transparent,
                initHeight: 0.25,
                maxHeight: 0.25,
                minHeight: 0.25,
                context: context,
                builder: (context, scrollController, bottomSheetOffset) {
                  return Container(
                    decoration: activeNeumorphistDecoration(topLeft: 25, topRight: 25),
                    child: Stack(
                      children: [
                        /// COLUMNA DE DATOS
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Row(
                              children: [
                                /// Imagen
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: activeNeumorphistDecoration(radius: 25),
                                  child: Image.asset("assets/images/partes.png"),
                                ),
                                /// ESPACIO
                                const SizedBox(width: 20,),
                                /// Columna para datos de la pieza analizada
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Hora
                                    RichText(
                                      text: TextSpan(
                                        text: "Hora: ",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: DateFormat("HH:mm").format(partModel.horaAnalisis),
                                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                          )
                                        ]
                                      )
                                    ),
                                    // Eestado
                                    RichText(
                                      text: TextSpan(
                                          text: "Estado: ",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: partModel.estado,
                                              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                            )
                                          ]
                                      )
                                    ),
                                    // Tiempo
                                    RichText(
                                        text: TextSpan(
                                            text: "Tiempo: ",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: "${partModel.tiempoAnalisis}s",
                                                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                              )
                                            ]
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        /// NUMERO DE PIEZA Y COLOR DEL ESTADO
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 20,),
                              Text(partModel.numeroPieza, style: TextStyle(fontWeight: FontWeight.bold),),
                              StateColorPartWidget(
                                isOk: partModel.estado == "ok" ? true : false,
                                radius: 10
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            partNumber: partModel.numeroPieza,
            isOk: partModel.estado == "ok" ? true : false,
          );
        },
      ),
    );
  }
}


class ListTilePartWidget extends StatelessWidget {

  VoidCallback onTap;
  String partNumber;
  bool isOk;

  ListTilePartWidget({
    super.key,
    required this.isOk,
    required this.partNumber,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Imagen de Pieza
          Container(
            decoration: activeNeumorphistDecoration(radius: 25),
            height: 90,
            width: 90,
            child: Image.asset("assets/images/partes.png"),
          ),
          /// Número de seríe de pieza
          Text(partNumber, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          /// Color del estado
          StateColorPartWidget(
            radius: 25,
            isOk: isOk,
          )
        ],
      ),
    );
  }
}

class StateColorPartWidget extends StatelessWidget {

  bool isOk;
  double radius;

  StateColorPartWidget({
    super.key,
    required this.isOk,
    required this.radius
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const CircleBorder(),
      child: CircleAvatar(
        backgroundColor: isOk ? Colors.green : Colors.red,
        radius: radius,
      ),
    );
  }
}










