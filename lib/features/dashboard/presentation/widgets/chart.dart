import 'package:life_insurance/core/core.dart' show AppColors;
import 'package:fl_chart/fl_chart.dart'
    show
        LineChart,
        LineChartData,
        AxisTitles,
        FlLine,
        FlGridData,
        SideTitles,
        FlTitlesData,
        FlBorderData,
        FlSpot,
        FlDotCirclePainter,
        FlDotData,
        BarAreaData,
        LineChartBarData;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        EdgeInsets,
        Offset,
        Text,
        SizedBox,
        Color,
        Row,
        Colors,
        BorderRadius,
        BoxShadow,
        BoxDecoration,
        CrossAxisAlignment,
        MainAxisAlignment,
        FontWeight,
        TextStyle,
        Column,
        Icons,
        Icon,
        Container,
        Padding,
        LinearGradient;

class ChartCard extends StatelessWidget {
  const ChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Premium Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 21, 41, 88),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'May – Sep 2025',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.north_east, color: Color(0xFF16A34A), size: 12),
                    SizedBox(width: 4),
                    Text(
                      '+18.6%',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.border(context),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 15:
                            return Text(
                              '15k',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                              ),
                            );
                          case 20:
                            return Text(
                              '20k',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                              ),
                            );
                          case 25:
                            return Text(
                              '25k',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                              ),
                            );
                          case 28:
                            return Text(
                              '28k',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                              ),
                            );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['May', 'Jun', 'Jul', 'Aug', 'Sep'];
                        if (value.toInt() >= 0 &&
                            value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 4,
                minY: 12,
                maxY: 30,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 18.2),
                      FlSpot(1, 20.5),
                      FlSpot(2, 19.1),
                      FlSpot(3, 22.8),
                      FlSpot(4, 24.7),
                    ],
                    isCurved: true,
                    color: const Color(0xFF1E3A8A),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFF1E3A8A),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E3A8A).withValues(alpha: 0.15),
                          const Color(0xFF1E3A8A).withValues(alpha: 0.0),
                        ],
                        begin: .topCenter,
                        end: .bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
