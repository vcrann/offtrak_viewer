import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offtrak_viewer/modules/core/managers/tracker_manager.dart';
import 'package:offtrak_viewer/modules/core/managers/serial_manager.dart';
import 'package:offtrak_viewer/modules/core/widgets/map_view.dart';
import 'package:offtrak_viewer/modules/helpers/service_locator.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

List<String> bauds = <String>['9600', '57600', '115200', '921600'];

class ViewerPage extends StatefulWidget {
  const ViewerPage({Key? key}) : super(key: key);

  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  //String _portDropdownValue = SerialPort.availablePorts.first;
  String _portDropdownValue = 'No ports available';
  final String _baudDropdownValue = bauds.first;

  @override
  Widget build(BuildContext context) {
    if (SerialPort.availablePorts.isNotEmpty) {
      _portDropdownValue = SerialPort.availablePorts.first;
    }
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
                      DropdownButton<String>(
                        value: _portDropdownValue,
                        icon: const Icon(Icons.swipe_right_alt),
                        hint: const Text('Select Port'),
                        items: SerialPort.availablePorts.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _portDropdownValue = newValue!;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: _baudDropdownValue,
                        icon: const Icon(Icons.bar_chart_rounded),
                        hint: const Text('Select Baud'),
                        items:
                            bauds.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _portDropdownValue = newValue!;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              SerialPort.availablePorts;
                            });
                          },
                          child: const Text('Refresh'),
                        ),
                      ),

                      //ElevatedButton(onPressed: onPressed, child: const Text('Refresh')),
                      ElevatedButton(
                        onPressed: () {
                          serviceLocator<SerialManager>().openConnection(
                              _portDropdownValue,
                              int.parse(_baudDropdownValue));
                        },
                        child: const Text('Connect'),
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

//wrap widget requires list of widgets so need to return list of cards from this function
//   List<Widget> _buildInfoCardList(SwarmManager swarmManager) {
//     Iterable<AgentState> agents = swarmManager.swarm.values;
//     List<Widget> infoCards = [];
//     for (AgentState agent in agents) {
//       //infoCards.add(_buildInfoCard(agent));
//       infoCards.add(AgentInfoCard(agentState: agent));
//     }
//     return infoCards;
//   }

//   Widget _buildControlButton(
//       MQTTAppConnectionState state, String buttonText, String command) {
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ElevatedButton(
//           child: Text(buttonText),
//           style: ElevatedButton.styleFrom(
//             fixedSize: const Size(88, 36),
//             //primary: Colors.deepOrange
//           ),
//           onPressed: state == MQTTAppConnectionState.connected ||
//                   state == MQTTAppConnectionState.connectedSubscribed
//               ? () {
//                   _handleControlPress(command);
//                 }
//               : null,
//         ));
//   }

//   void _handleControlPress(String command) {
//     var swarm = serviceLocator<SwarmManager>().swarm;
//     List<String> selected = serviceLocator<SwarmManager>().selected;
//     if (command == 'return') {
//       var sortedSwarmALtitudes = altCalc(swarm,
//           55); //31 is altitude of hough end, 55 is altitude of bredbury, change with function to get site elevation in future
//       for (String agent in swarm.keys) {
//         _publishMessage(
//             agent + '/home/altitude', sortedSwarmALtitudes[agent].toString());
//         //sleep(const Duration(seconds: 1));
//         _publishMessage('commands/' + agent, command);
//       }
//     } else if (selected.isEmpty) {
//       for (String agent in swarm.keys) {
//         _sendCommand(agent, command);
//       }
//     } else {
//       for (String agent in selected) {
//         _sendCommand(agent, command);
//       }
//     }
//   }

//   void _publishMessage(String topic, String message) {
//     serviceLocator<MQTTManager>().publish(topic, message);
//     //_messageTextController.clear();
//   }

//   void _sendCommand(String agent, String command) {
//     serviceLocator<MQTTManager>().sendCommand(agent, command);
//     //_messageTextController.clear();
//   }
// }

// class AgentInfoCard extends StatefulWidget {
//   const AgentInfoCard({Key? key, required this.agentState}) : super(key: key);
//   final AgentState agentState;

//   @override
//   AgentInfoCardState createState() => AgentInfoCardState();
// }

// class AgentInfoCardState extends State<AgentInfoCard> {
//   String _buttonText = 'SELECT';
//   bool _selected = false;

//   toggleSelected() {
//     if (_buttonText == 'SELECT') {
//       setState(() {
//         _selected = true;
//         _buttonText = 'UNSELECT';
//         serviceLocator<SwarmManager>()
//             .addSelected(widget.agentState.getAgentID);
//       });
//     } else {
//       _selected = false;
//       _buttonText = 'SELECT';
//       serviceLocator<SwarmManager>()
//           .removeSelected(widget.agentState.getAgentID);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 150.0,
//       //height: 300.0,
//       child: Align(
//         alignment: FractionalOffset.bottomCenter,
//         child: Column(
//           children: [
//             Card(
//               shape: _selected
//                   ? RoundedRectangleBorder(
//                       side: const BorderSide(color: Colors.blue, width: 2.0),
//                       borderRadius: BorderRadius.circular(4.0))
//                   : RoundedRectangleBorder(
//                       side: const BorderSide(color: Colors.white, width: 2.0),
//                       borderRadius: BorderRadius.circular(4.0)),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   ListTile(
//                     //dense: true,
//                     //leading: Icon(Icons.airplanemode_active),
//                     title: Text(widget.agentState.getAgentID),
//                     subtitle: Text(widget.agentState.getConnectionStatus),
//                   ),
//                   const Divider(
//                     height: 0,
//                     thickness: 2,
//                     indent: 5,
//                     endIndent: 5,
//                     color: Colors.grey,
//                   ),
//                   //const SizedBox(width: 8),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(5.0),
//                         alignment: Alignment.topLeft,
//                         child: Row(
//                           children: [
//                             const Icon(Icons.battery_full_sharp),
//                             Text(widget.agentState.getBatteryLevel.toString() +
//                                 '%'),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(5.0),
//                         alignment: Alignment.topLeft,
//                         child: Row(
//                           children: [
//                             const Icon(Icons.wifi),
//                             Text(widget.agentState.getWifiStrength.toString() +
//                                 'dB'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.airplanemode_active),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Container(
//                               color: Colors.green,
//                               child: Center(
//                                 child: Text(widget.agentState.getFlightMode),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: TextButton(
//                       child: Text(_buttonText),
//                       onPressed: () {
//                         toggleSelected();
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             widget.agentState.getCloseTo.isNotEmpty
//                 ? Container(
//                     width: double.infinity,
//                     child: Card(
//                       //width: 150.0,
//                       color: Colors.red,
//                       child: Column(
//                         children: getCloseToWidgets(),
//                       ),
//                     ),
//                   )
//                 : Container(height: 0),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> getCloseToWidgets() {
//     List<Widget> _widgets = [];

//     // List<String> _closeTo = widget.agentState.getCloseTo;
//     // for (int i = 0; i < _closeTo.length; i++) {
//     //   _widgets.add(Text('CLOSE TO ' + _closeTo[i]));
//     // }
//     widget.agentState.getCloseTo.forEach((agent, distance) {
//       _widgets
//           .add(Text(roundDouble(distance, 1).toString() + 'm from ' + agent));
//     });
//     return _widgets;
//   }
// }
