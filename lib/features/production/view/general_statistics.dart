import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/features/production/controller/general_statistics_state.dart';
import 'package:vision_app/features/widgets/custom_icon_button.dart';
import 'package:vision_app/features/widgets/legend_item_widget.dart';

import '../../widgets/custom_bar_chart.dart';
import '../../widgets/custom_pie_chart.dart';
import '../../widgets/statistics_container_widget.dart';

const color = Color(0xffECF0F4);

class GeneralStatistics extends StatelessWidget {

  GeneralStatistics._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GeneralStatisticsState(firestore: context.read())..getAllData(),
      builder: (context, child) => GeneralStatistics._(),
    );
  }


  @override
  Widget build(BuildContext context) {
    GeneralStatisticsState generalStatisticsState = context.watch();

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            // Botón de regreso
            Expanded(
              child: Row(
                children: [
                  CustomIconButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    icon: Icons.arrow_back_ios_outlined
                  )
                ],
              )
            ),
            // Titulo
            const Expanded(
              flex: 3,
              child: Text(
                "Estadísticas Generales",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ),
            // Espacio vacío
            const Expanded(child: SizedBox())
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50),
        child: Center(
          child: Column(
            children: [
        
              /// Legend Items
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LegendItemWidget(color: Colors.green, title: "Ok"),
                  const SizedBox(width: 30,),
                  LegendItemWidget(color: Colors.red, title: "No Ok"),
                ],
              ),
        
              const SizedBox(height: 30,),
        
              /// Pie Chart
              CustomPieChart(
                okParts: generalStatisticsState.okParts,
                notOkParts: generalStatisticsState.notOkParts
              ),
        
              const SizedBox(height: 20,),
        
              /// CustomBarChart
              /// Hora | Ok | Not Ok
              CustomBarChart(
                data: generalStatisticsState.partBySixHourIntervals
              ),
        
              const SizedBox(height: 20,),
        
              /// Contenedores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    StatisticsContainerWidget(
                      title: "Piezas",
                      icon: Icons.inventory_2_outlined,
                      value: generalStatisticsState.okParts + generalStatisticsState.notOkParts,
                    ),
                    const SizedBox(height: 20,),
                    StatisticsContainerWidget(
                      title: "Líneas",
                      icon: Icons.inventory_2_outlined,
                      value: generalStatisticsState.linesQuantity,
                    ),
                    const SizedBox(height: 20,),
                    StatisticsContainerWidget(
                      title: "Maquinas",
                      icon: Icons.inventory_outlined,
                      value: generalStatisticsState.machinesQuantity,
                    )
                  ],
                )
              )
        
            ],
          ),
        ),
      ),
    );
  }
}
