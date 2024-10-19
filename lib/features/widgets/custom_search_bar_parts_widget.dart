import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/features/production/controller/machine_state.dart';
import 'package:vision_app/features/production/controller/parts_state.dart';
import 'package:vision_app/features/production/model/machine_model.dart';
import 'package:vision_app/features/production/model/part_model.dart';

import '../../core/app/decorations/active_neumorphist_decoration.dart';
import '../production/controller/line_state.dart';
import '../production/model/line_model.dart';
import '../production/view/parts_machine_screen.dart';
import 'custom_icon_button.dart';
import 'custom_line_machine_widget.dart';

class CustomSearchBarPartsWidget extends SearchDelegate {

  PartsState partsState;

  CustomSearchBarPartsWidget({
    required this.partsState
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
      future: partsState.searchPartsWithNumber(query),
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

        List<PartModel> lista = snapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 20, top: 40, right: 20, left: 20),
          physics: BouncingScrollPhysics(),
          itemCount: lista.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10,);
          },
          itemBuilder: (context, index) {
            PartModel partModel = lista[index];
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
        );
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }

}