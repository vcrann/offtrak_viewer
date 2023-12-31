import 'package:get_it/get_it.dart';

import 'package:offtrak_viewer/modules/core/managers/tracker_manager.dart';
//import 'package:offtrak_viewer/modules/core/managers/serial_manager.dart';
import 'package:offtrak_viewer/modules/core/managers/udp_manager.dart';

GetIt serviceLocator = GetIt.instance;
void setupLocator() {
  serviceLocator.registerLazySingleton(() => TrackerManager());
  //serviceLocator.registerLazySingleton(() => SerialManager());
  serviceLocator.registerLazySingleton(() => UDPManager());
}
