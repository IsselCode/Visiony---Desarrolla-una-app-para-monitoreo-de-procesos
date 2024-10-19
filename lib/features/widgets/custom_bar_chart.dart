import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';

class CustomBarChart extends StatelessWidget {

  List<List<int>> data;

  CustomBarChart({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {

    int valorMasAlto = obtenerValorMasAlto(data);

    // Retornar un Widget contenedor que envuelve el gráfico
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 200,
      width: double.infinity,
      decoration: activeNeumorphistDecoration(radius: 25),
      child: BarChart(
        swapAnimationCurve: Curves.linear,
        swapAnimationDuration: Duration(milliseconds: 500),
        BarChartData( // Configura los datos y el diseño del gráfico
          maxY: valorMasAlto.toDouble(),
          minY: 0,
          titlesData: FlTitlesData( // Configurar los títulos de los ejes
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => bottomTitles(value, meta, data),
                reservedSize: 30
              )
            )
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),

          barGroups: List.generate( // Genera un grupo de barras basado en la longitud de los datos
            data.length,
                (index) {
              return customBarChartGroupData(
                data[index][1].toDouble(), // Valor Ok
                data[index][2].toDouble(), // Valor Not Ok
                index, // Índice actual del grupo de barras
              );
            },
          )
        )
      )
    );
  }

  /// Método que obtiene el valor más alto de los datos
  int obtenerValorMasAlto(List<List<int>> listas) {

    // Obtener una lista que contenga sublistas con solamente los valores a comprar (indices 1 y 2)
    List<List<int>> subLista = listas.map((lista) => lista.sublist(1, 3),).toList();

    List<int> maximosPorSublista = subLista.map((lista) => lista.reduce((a, b) => a > b ? a : b,),).toList();

    // Encontrar el valor máximo entre todos los máximos obtenidos
    int maximoFinal = maximosPorSublista.reduce((a, b) => a > b ? a : b,);

    // Retornamos el valor máximo final
    return maximoFinal;
  }

  BarChartGroupData customBarChartGroupData(double toYOk, toYNotOk, index) {
    return BarChartGroupData(
      x: index, // define la posicion de las barras en el eje x,
      barsSpace: 4,
      barRods: [
        BarChartRodData(toY: toYOk, color: Colors.green, width: 20),
        BarChartRodData(toY: toYNotOk, color: Colors.red, width: 20),
      ]
    );
  }

  Widget bottomTitles(double value, TitleMeta meta, List<List<int>> data) {

    // Crear una lista de titulos basados en la primera columna de datos
    List<String> titles = data.map((lista) => "${lista[0].toString()}:00",).toList();

    // Widget de texto que representa el titulo en el eje X
    final Widget text = Text(
      titles[value.toInt()].padLeft(5, "0"), // Formatea el titulo (hora) con ceros a la izquierda
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

}







