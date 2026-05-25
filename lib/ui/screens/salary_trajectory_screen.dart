import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SalaryTrajectoryScreen extends StatelessWidget {
  const SalaryTrajectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final sim = vm.simulation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Salary Trajectory',
            subtitle: '5-year income projection across all paths',
          ),
          const SizedBox(height: 20),

          if (sim == null)
            const CyberGlassCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Run a simulation first to see salary data.',
                      style: TextStyle(color: kCyberGray)),
                ),
              ),
            )
          else ...[
            // Chart
            CyberGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Income Growth (\$k/yr)',
                      style: TextStyle(
                          color: kStellarWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: LineChart(_buildChart(sim.optimisticSalaryList,
                        sim.realisticSalaryList, sim.riskSalaryList)),
                  ),
                  const SizedBox(height: 16),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _legend('Optimistic', kSuccessGreen),
                      _legend('Realistic', kNeonTeal),
                      _legend('High Risk', kNeonPurple),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Year-by-year breakdown
            const SectionHeader(title: 'Year-by-Year Breakdown'),
            const SizedBox(height: 14),
            ...List.generate(5, (i) {
              final opt = sim.optimisticSalaryList.elementAtOrNull(i) ?? 0;
              final real = sim.realisticSalaryList.elementAtOrNull(i) ?? 0;
              final risk = sim.riskSalaryList.elementAtOrNull(i) ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CyberGlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: kNeonTeal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('Y${i + 1}',
                              style: const TextStyle(
                                  color: kNeonTeal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Year ${i + 1}',
                                style: const TextStyle(
                                    color: kStellarWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _salaryChip('\$${opt.toInt()}k', kSuccessGreen),
                                const SizedBox(width: 6),
                                _salaryChip('\$${real.toInt()}k', kNeonTeal),
                                const SizedBox(width: 6),
                                _salaryChip('\$${risk.toInt()}k', kNeonPurple),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  LineChartData _buildChart(
      List<double> opt, List<double> real, List<double> risk) {
    FlLine gridLine = FlLine(
        color: Colors.white.withOpacity(0.06), strokeWidth: 1);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => gridLine,
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (v, _) => Text('\$${v.toInt()}k',
                style: const TextStyle(color: kCyberGray, fontSize: 9)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) => Text('Y${v.toInt() + 1}',
                style: const TextStyle(color: kCyberGray, fontSize: 9)),
          ),
        ),
        topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        _line(opt, kSuccessGreen),
        _line(real, kNeonTeal),
        _line(risk, kNeonPurple),
      ],
    );
  }

  LineChartBarData _line(List<double> data, Color color) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 2.5,
      dotData: FlDotData(
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
            radius: 3, color: color, strokeWidth: 0),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.06),
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 3,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(color: kCyberGray, fontSize: 11)),
      ],
    );
  }

  Widget _salaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
