import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:offtrak_viewer/modules/core/managers/tracker_manager.dart';
//import 'package:offtrak_viewer/modules/core/managers/serial_manager.dart';
import 'package:offtrak_viewer/modules/core/managers/udp_manager.dart';
import 'package:offtrak_viewer/modules/core/widgets/map_view.dart';
import 'package:offtrak_viewer/modules/helpers/service_locator.dart';
//import 'package:flutter_libserialport/flutter_libserialport.dart';

List<String> bauds = <String>['9600', '57600', '115200', '921600'];

class ViewerPage extends StatefulWidget {
  const ViewerPage({Key? key}) : super(key: key);

  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  //String _portDropdownValue = 'No ports available';
  //String _baudDropdownValue = bauds.first;

  @override
  Widget build(BuildContext context) {
    // if (SerialPort.availablePorts.isNotEmpty) {
    //   _portDropdownValue = SerialPort.availablePorts.first;
    // }
    return _buildColumn();
  }

  Widget _buildColumn() {
    return Stack(children: <Widget>[
      //Container(height: 300.0, child: ControlMap()),
      const MapView(),
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        primary: false,
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // DropdownButton<String>(
                      //   value: _portDropdownValue,
                      //   icon: const Icon(Icons.swipe_right_alt),
                      //   hint: const Text('Select Port'),
                      //   items: SerialPort.availablePorts.map((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       _portDropdownValue = newValue!;
                      //     });
                      //   },
                      // ),
                      // DropdownButton<String>(
                      //   value: _baudDropdownValue,
                      //   icon: const Icon(Icons.bar_chart_rounded),
                      //   hint: const Text('Select Baud'),
                      //   items:
                      //       bauds.map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       _baudDropdownValue = newValue!;
                      //     });
                      //   },
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         SerialPort.availablePorts;
                      //       });
                      //     },
                      //     child: const Text('Refresh'),
                      //   ),
                      // ),

                      //ElevatedButton(onPressed: onPressed, child: const Text('Refresh')),
                      ElevatedButton(
                        onPressed: () {
                          // serviceLocator<SerialManager>().openConnection(
                          //     _portDropdownValue,
                          //     int.parse(_baudDropdownValue));
                          serviceLocator<UDPManager>().openUDPConnection();
                        },
                        child: const Text('Connect'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<UDPManager>(
                          builder: (context, udp, child) {
                            return Text(
                                'Packets Received: ${udp.messageCounter}, Last Packet From ID: ${udp.lastSeenID}');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
