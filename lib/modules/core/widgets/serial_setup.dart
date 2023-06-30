// import 'package:flutter/material.dart';
// import 'package:flutter_libserialport/flutter_libserialport.dart';

// class SerialSetup extends StatefulWidget {
//   const SerialSetup({
//     super.key,
//     this.port,
//     //this.baudRate,
//   });

//   final String? port;
//   final int baudRate;

//   @override
//   State<SerialSetup> createState() => _SerialSetupState();
// }

// class _SerialSetupState extends State<SerialSetup> {
//   double _size = 1.0;

//   void grow() {
//     setState(() {
//       _size += 0.1;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: widget.color,
//       transform: Matrix4.diagonal3Values(_size, _size, 1.0),
//       child: widget.child,
//     );
//   }
// }

// void main() {
//   print('Available ports:');
//   var i = 0;
//   for (final name in SerialPort.availablePorts) {
//     final sp = SerialPort(name);
//     print('${++i}) $name');
//     print('\tDescription: ${sp.description}');
//     print('\tManufacturer: ${sp.manufacturer}');
//     print('\tSerial Number: ${sp.serialNumber}');
//     print('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
//     print('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
//     sp.dispose();
//   }
// }
