import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../production/controller/line_state.dart';
import '../production/model/line_model.dart';
import 'custom_icon_button.dart';
import 'custom_line_machine_widget.dart';

class CustomSearchBarLinesWidget extends SearchDelegate {

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
    LineState lineState = context.read();

    return FutureBuilder(
      future: lineState.searchLinesWithName(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text("Hubo un error"),);
        }

        if (snapshot.hasData && snapshot.data!.length == 0) {
          return Center(child: Text("No hay líneas con ese nombre"),);
        }

        List<LineModel> lista = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 20, top: 40, right: 20, left: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 20
          ),
          itemCount: lista.length,
          itemBuilder: (context, index) {
            LineModel line = lista[index];
            return CustomLineMachineWidget(
              image: "assets/images/linea.png",
              name: line.name,
              onLongPress: () {
                print("desde la barra de busqueda se presiono durante un tiempo");
              },
              onTap: () {
                print(line.name);
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