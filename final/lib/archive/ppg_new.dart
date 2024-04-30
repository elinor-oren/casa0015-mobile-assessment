// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:heart_bpm/heart_bpm.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'dart:math' as math; // Ensure this is at the top for min and max

// class SensorValue {
//   final DateTime time;
//   final double value;

//   SensorValue(this.time, this.value);
// }

// class PPGScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   const PPGScreen({Key? key, required this.cameras}) : super(key: key);

//   @override
//   _PPGScreenState createState() => _PPGScreenState();
// }

// class _PPGScreenState extends State<PPGScreen> {
//   List<int> data = []; // Storing raw data as integers
//   List<SensorValue> bpmValues = [];
//   bool isMeasuring = false;
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//   }

//   Future<void> initCamera() async {
//     _controller = CameraController(
//       widget.cameras.first,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller!.initialize().then((_) {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   void toggleMeasurement() {
//     setState(() {
//       isMeasuring = !isMeasuring;
//       if (isMeasuring) {
//         _controller?.setFlashMode(FlashMode.torch);
//       } else {
//         _controller?.setFlashMode(FlashMode.off);
//         _controller?.stopImageStream();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF141925),
//       appBar: AppBar(
//         title: const Text("Check Your Pulse"),
//         backgroundColor: Colors.blue,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Center(
//                 child: _controller == null
//                     ? CircularProgressIndicator()
//                     : (_controller!.value.isInitialized
//                         ? CameraPreview(_controller!)
//                         : Text("Waiting for camera initialization...")),
//               ),
//             ),
//             if (bpmValues.isNotEmpty)
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(border: Border.all()),
//                   child: BPMChart(bpmValues),
//                 ),
//               ),
//             Expanded(
//               child: Center(
//                 child: IconButton(
//                   icon: Icon(
//                       isMeasuring ? Icons.favorite : Icons.favorite_border),
//                   color: Colors.red,
//                   iconSize: 128,
//                   onPressed: toggleMeasurement,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BPMChart extends StatelessWidget {
//   final List<SensorValue> bpmData;

//   BPMChart(this.bpmData);

//   @override
//   Widget build(BuildContext context) {
//     List<FlSpot> spots = bpmData
//         .map((data) => FlSpot(
//               data.time.millisecondsSinceEpoch.toDouble(),
//               data.value,
//             ))
//         .toList();

//     return LineChart(
//       LineChartData(
//         gridData: FlGridData(show: false),
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(show: false),
//         lineBarsData: [
//           LineChartBarData(
//             spots: spots,
//             isCurved: true,
//             barWidth: 2,
//             color: Colors.blue,
//             belowBarData: BarAreaData(show: false),
//             dotData: FlDotData(show: false),
//           ),
//         ],
//         minX: spots.first.x,
//         maxX: spots.last.x,
//         minY: spots.map((e) => e.y).reduce(math.min) * 0.9,
//         maxY: spots.map((e) => e.y).reduce(math.max) * 1.1,
//       ),
//     );
//   }
// }
