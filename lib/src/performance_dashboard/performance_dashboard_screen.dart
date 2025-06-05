import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // For date formatting, add to pubspec.yaml if not already
import '../models/game_stat_model.dart';
import '../../../main.dart'; // For gameStatsBoxName

class PerformanceDashboardScreen extends StatefulWidget {
  const PerformanceDashboardScreen({super.key});

  @override
  State<PerformanceDashboardScreen> createState() => _PerformanceDashboardScreenState();
}

class _PerformanceDashboardScreenState extends State<PerformanceDashboardScreen> {
  late Box<GameStatModel> _gameStatsBox;
  List<GameStatModel> _gameStats = [];

  // Define specific game name for filtering, if needed
  final String _targetGameName = 'MemoryGame';

  @override
  void initState() {
    super.initState();
    _gameStatsBox = Hive.box<GameStatModel>(gameStatsBoxName);
    _loadStats();
    // Listen to box changes to update UI if new stats are added while screen is open
    _gameStatsBox.watch().listen((event) {
      _loadStats();
    });
  }

  void _loadStats() {
    // Load stats, filter by gameName, and sort by timestamp
    // If you want all games, remove .where clause
    final allStats = _gameStatsBox.values.toList();
    _gameStats = allStats
        .where((stat) => stat.gameName == _targetGameName)
        .toList();
    _gameStats.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (mounted) {
      setState(() {});
    }
  }

  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < _gameStats.length; i++) {
      // Using i as X-axis (representing game session number)
      // and score as Y-axis
      spots.add(FlSpot(i.toDouble(), _gameStats[i].score.toDouble()));
    }
    return spots;
  }

  Widget _buildChart(BuildContext context) {
    final spots = _generateSpots();
    final theme = Theme.of(context);

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No game data yet for $_targetGameName.\nPlay some games to see your progress!',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: theme.dividerColor.withOpacity(0.5), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: theme.dividerColor.withOpacity(0.5), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _gameStats.length > 10 ? ((_gameStats.length ~/ 5).toDouble()).clamp(1,1000) : 1, // Adjust interval based on data size
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < _gameStats.length) {
                  // Showing game session number or simple index
                  return SideTitleWidget(axisSide: meta.axisSide, child: Text('${index + 1}', style: theme.textTheme.bodySmall));
                }
                return Container();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                 return SideTitleWidget(axisSide: meta.axisSide, child: Text(value.toInt().toString(), style: theme.textTheme.bodySmall));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: theme.dividerColor)),
        minX: 0,
        maxX: (spots.length - 1).toDouble().clamp(0, double.infinity), // Ensure maxX is not negative
        minY: 0,
        // Adjust maxY if needed, e.g., based on max score
        // maxY: spots.map((s) => s.y).reduce((a,b) => a > b ? a : b) + 50,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.spotIndex < 0 || flSpot.spotIndex >= _gameStats.length) {
                   return null;
                }
                final stat = _gameStats[flSpot.spotIndex];
                return LineTooltipItem(
                  'Score: ${stat.score}\nDate: ${DateFormat.yMd().add_jm().format(stat.timestamp)}\nTries: ${stat.tries}',
                  TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                  children: [
                     TextSpan(text: '\nGame: ${stat.gameName}', style: TextStyle(color: theme.colorScheme.onPrimary.withOpacity(0.8)))
                  ]
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_targetGameName Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildChart(context),
      ),
    );
  }
}
