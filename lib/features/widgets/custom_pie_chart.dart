import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';

class CustomPieChart extends StatefulWidget {

  int okParts;
  int notOkParts;

  CustomPieChart({
    super.key,
    required this.okParts,
    required this.notOkParts
  });

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {

  // Variable para mostrar el número de partes "Ok"
  bool showOkParts = true;
  // Variable para mostrar los porcentajes en el gráfico
  bool showPercents = false;

  @override
  Widget build(BuildContext context) {

    // Calcula el total de partes sumando "okParts" y "notOkParts"
    int totalParts = widget.okParts + widget.notOkParts;

    // Calcula el porcentaje de partes "Ok"
    double okPercent = (100 / totalParts) * widget.okParts;

    // Calcula el porcentaje de partes "Not Ok"
    double notOkPercent = (100 / totalParts) * widget.notOkParts;


    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.width * 0.6,
      width: size.width * 0.6,
      decoration: activeNeumorphistDecoration(activeRadius: false).copyWith(
        shape: BoxShape.circle
      ),
      child: Stack(
        children: [
          // Centro del gráfico: PieChart
          Center(
            child: SizedBox(
              // Define las dimensiones del gráfico circular
              height: size.width * 0.5,
              width: size.width * 0.5,
              // Widget PieChart que muestra las partes "Ok" y "no ok"
              child: PieChart(
                // Duración de la animación para la transición del gráfico
                swapAnimationDuration: const Duration(milliseconds: 500),
                // Curva de animación
                swapAnimationCurve: Curves.linear,
                // Datos para el gráfico circular
                PieChartData(
                  // Espacio entre las secciones del gráfico
                  sectionsSpace: 0,
                  sections: [
                    // Sección para "Not Ok"
                    PieChartSectionData(
                      title: "${notOkPercent.toStringAsFixed(1)}%",
                      showTitle: showPercents,
                      // Estilo del titulo (texto) dentro del gráfico
                      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),

                      // Color de la seccion "Not Ok"
                      color: Colors.red,

                      // Radio del gráfico (qué tan grande será la seccion)
                      radius: size.width * 0.15,

                      // Sin bordes en la sección
                      borderSide: BorderSide.none,

                      // Valor que representa la cantidad de partes "Not Ok"
                      value: widget.notOkParts.toDouble()
                    ),
                    // Sección para "Ok"
                    PieChartSectionData(
                        title: "${okPercent.toStringAsFixed(1)}%",
                        showTitle: showPercents,
                        // Estilo del titulo (texto) dentro del gráfico
                        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),

                        // Color de la seccion "Not Ok"
                        color: Colors.green,

                        // Radio del gráfico (qué tan grande será la seccion)
                        radius: size.width * 0.15,

                        // Sin bordes en la sección
                        borderSide: BorderSide.none,

                        // Valor que representa la cantidad de partes "Not Ok"
                        value: widget.okParts.toDouble()
                    )
                  ]
                )
              ),
            ),
          ),

          // Decoración adicional en el centro del gráfico circular
          Center(
            child: InkWell(
              // Cuando se detecta una pulsación larga, cambia el estado para mostrar/ocultar los porcentajes
              onLongPress: () {
                showPercents = !showPercents;
                setState(() {});
              },
              // Cuando se detecta un toque corto, cambia el estado para mostrar/ocultar partes "Ok"
              onTap: () {
                showOkParts = !showOkParts;
                setState(() {});
              },
              // Contenedor en el centro del gráfico circular con diseño neumórfico
              child: Container(
                height: size.width * 0.25,
                width: size.width * 0.25,
                decoration: activeNeumorphistDecoration(activeRadius: false).copyWith(
                  shape: BoxShape.circle
                ),
                // Texto que muestra el número de partes "Ok" o "Not Ok" según el estado de showOkParts
                child: Center(
                  child: Text(
                    showOkParts ? widget.okParts.toString() : widget.notOkParts.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.07,
                      color: showOkParts ? Colors.black : Colors.red
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}










