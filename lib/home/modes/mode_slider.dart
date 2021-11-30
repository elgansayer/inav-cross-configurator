import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ModeSlider extends StatefulWidget {
  ModeSlider({Key? key, required this.range}) : super(key: key);

  final RangeValues range;

  @override
  _ModeSliderState createState() => _ModeSliderState();
}

class _ModeSliderState extends State<ModeSlider> {
  late RangeValues range;

  @override
  void initState() {
    this.range = widget.range;
    super.initState();
  }

  _slider(BuildContext context) {
    return SfRangeSlider(
      min: 900.0,
      max: 2100.0,
      values: SfRangeValues(this.range.start, this.range.end),
      interval: 200,
      dragMode: SliderDragMode.both,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      minorTicksPerInterval: 2,
      onChanged: (SfRangeValues values) {
        setState(() {
          this.range = RangeValues(values.start, values.end);
        });
      },
    );
    // return SfRangeSelector(
    //   min: 900,
    //   max: 2100,
    //   initialValues: SfRangeValues(this.range.start, this.range.end),
    //   labelPlacement: LabelPlacement.betweenTicks,
    //   interval: 1,
    //   // dateIntervalType: DateIntervalType.values,
    //   // dateFormat: DateFormat.y(),
    //   showTicks: true,
    //   showLabels: true, child: null,
    //   onChanged: (value) {
    //     setState(() {
    //       this.range = RangeValues(value.start, value.end);
    //     });
    //   },
    //   // child: Container(
    //   //   child: SfCartesianChart(
    //   //     margin: const EdgeInsets.all(0),
    //   //     primaryXAxis: DateTimeAxis(
    //   //       minimum: _dateMin,
    //   //       maximum: _dateMax,
    //   //       isVisible: false,
    //   //     ),
    //   //     primaryYAxis: NumericAxis(isVisible: false, maximum: 4),
    //   //     series: <SplineAreaSeries<Data, DateTime>>[
    //   //       SplineAreaSeries<Data, DateTime>(
    //   //           dataSource: _chartData,
    //   //           xValueMapper: (Data sales, int index) => sales.x,
    //   //           yValueMapper: (Data sales, int index) => sales.y)
    //   //     ],
    //   //   ),
    //   //   height: 200,
    //   // ),
    // );

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        // activeTrackColor: Colors.red[700],
        // inactiveTrackColor: Colors.red[100],
        trackShape: RectangularSliderTrackShape(),
        trackHeight: 10.0,
        // thumbColor: Colors.redAccent,
        // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        // overlayColor: Colors.red.withAlpha(32),
        // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      ),
      child: RangeSlider(
          activeColor: Colors.blue[700],
          inactiveColor: Colors.red[300],
          // labels: RangeLabels('', ''),
          // 900, 1000, 1200, 1400, 1500, 1600, 1800, 2000, 2100
          divisions: 200,
          min: 900,
          max: 2100,
          values: this.range,
          onChanged: (values) {
            setState(() {
              this.range = values;
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _slider(context);
  }
}
