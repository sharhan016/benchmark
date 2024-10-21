// library progress_bar_chart;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

/// A widget that displays a progress bar chart.
///
/// The [ProgressBarChart] widget is used to display a chart with progress bars.
class ProgressBarChart extends StatefulWidget {
  const ProgressBarChart({
    super.key,
    required this.height,
    required this.values,
    this.borderRadius,
    this.showLables = true,
    this.colorBlend = true,
    this.totalPercentage = 0,
    this.unitLabel = '%',
  });

  /// A list of [StatisticsItem] objects representing the data to be displayed in the progress bar chart.
  final List<StatisticsItem> values;

  /// The height of the progress bar chart.
  final double height;

  /// The border radius of the progress bars (optional).
  final double? borderRadius;

  /// Whether to show the labels on the progress bars (optional).
  final bool showLables;

  /// Whether to blend the colors of the progress bars (optional).
  final bool colorBlend;

  /// The unit label of the progress values (optional).
  final String unitLabel;

  /// The total percentage of the progress bars (optional).
  final double totalPercentage;

  @override
  State<ProgressBarChart> createState() => _ProgressBarChartState();
}

class _ProgressBarChartState extends State<ProgressBarChart>
    with TickerProviderStateMixin {
  Map<Color, AnimationController> controllers = {};
  Map<Color, Animation<double>> animations = {};
  List<StatisticsItem> percentageValues = [];

  @override
  void initState() {
    super.initState();

    percentageValues = List<StatisticsItem>.from(widget.values);
    percentageValues.sort((a, b) => b.value.compareTo(a.value));

    double total = 0;
    for (var i = 0; i < percentageValues.length; i++) {
      double percentage = widget.totalPercentage != 0
          ? (percentageValues[i].value / widget.totalPercentage)
          : percentageValues[i].value;
      total += percentage;
      percentageValues[i] = StatisticsItem(percentageValues[i].color, total,
          title: percentageValues[i].title,
          titleColor: percentageValues[i].titleColor); // Added titleColor
    }

    percentageValues = percentageValues.reversed.toList();

    const maxDuration = Duration(seconds: 1);

    // Create animation controllers and animations for each value
    for (var entry in percentageValues) {
      final duration = Duration(
          milliseconds: (maxDuration.inMilliseconds * entry.value).round());
      controllers[entry.color] = AnimationController(
        duration: duration,
        vsync: this,
      );
      animations[entry.color] =
          Tween<double>(begin: 0, end: entry.value).animate(
        CurvedAnimation(
          parent: controllers[entry.color]!.view,
          curve: Curves.easeOut,
        ),
      );
      controllers[entry.color]?.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String formatText(double value, {bool original = false}) {
    double result = widget.totalPercentage != 0 ? value : value * 100;
    int formatResult = result.toInt();
    var languageCode = Localizations.localeOf(context).languageCode;
    final numberFormat = NumberFormat.decimalPattern(languageCode);
    String ret = numberFormat.format(formatResult);
    return original
        ? result % 1 == 0
            ? ret
            : result.toStringAsFixed(2)
        : ret;
  }

  Color getTextColor(Color color, Color? titleColor) {
    if (titleColor != null) return titleColor; // Return custom title color
    if (widget.colorBlend) {
      return Color.alphaBlend(color.withOpacity(0.3), Colors.black);
    }
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  getTitle(String? title) {
    return title != null ? '$title: ' : '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return SizedBox(
            width: width,
            child: Stack(
              children: percentageValues
                  .map(
                    (entry) => AnimatedBuilder(
                      animation: animations[entry.color]!,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            IgnorePointer(
                              child: LinearProgressIndicator(
                                minHeight: widget.height,
                                value: animations[entry.color]?.value,
                                backgroundColor: Colors.transparent,
                                color: entry.color,
                                semanticsValue: entry.value.toString(),
                                borderRadius: widget.borderRadius != null
                                    ? BorderRadius.circular(
                                        widget.borderRadius!,
                                      )
                                    : BorderRadius.zero,
                              ),
                            ),
                            if (widget.showLables)
                              Builder(
                                builder: (context) {
                                  final itemOrigin = widget.values.firstWhere(
                                      (e) => e.color == entry.color);
                                  final textWidth = width *
                                      (widget.totalPercentage != 0
                                          ? itemOrigin.value /
                                              widget.totalPercentage
                                          : itemOrigin.value);
                                  if (textWidth < 40) return Container();
                                  return FutureBuilder(
                                    future: Future.delayed(
                                        const Duration(microseconds: 500)),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else {
                                        return Container(
                                          width: width * entry.value,
                                          height: widget.height,
                                          alignment: Alignment.centerRight,
                                          child: Tooltip(
                                            message:
                                                '${getTitle(itemOrigin.title)}${formatText(itemOrigin.value, original: true)}${widget.unitLabel}',
                                            triggerMode: TooltipTriggerMode.tap,
                                            child: SizedBox(
                                              width: textWidth,
                                              child: Text(
                                                '${formatText(itemOrigin.value)} ${textWidth > 60 ? widget.unitLabel : ''}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: getTextColor(
                                                      entry.color,
                                                      itemOrigin
                                                          .titleColor), // Use custom title color
                                                  fontSize: widget.height * 0.5,
                                                  fontWeight: FontWeight.w700,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ).animate().fadeIn();
                                      }
                                    },
                                  );
                                },
                              )
                          ],
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

/// Represents an item in the statistics chart.
class StatisticsItem {
  /// Represents the title of the progress bar chart displayed in tooltips.
  final String? title;

  /// Represents the value of the progress bar chart.
  double value;

  /// Represents the color of the progress bar chart.
  final Color color;

  /// Represents the custom color of the title.
  final Color? titleColor; // Add titleColor field

  /// Creates a new instance of [StatisticsItem].
  StatisticsItem(
    this.color,
    this.value, {
    this.title,
    this.titleColor, // Initialize titleColor (optional)
  });
}
