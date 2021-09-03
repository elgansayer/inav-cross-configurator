import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inavconfiurator/components/ErrorBanner.dart';
import 'package:inavconfiurator/components/bloc/errormessage_repository.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:inavconfiurator/serial/serialport_repository.dart';
import 'bloc/devices_bloc.dart';
import 'devices_screen.dart';

class DevicesPage extends StatefulWidget {
  static const String routeName = '/connection';

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SerialPortRepository(),
      child: Scaffold(
        appBar: AppBar(
          // title: Text('INav'),title: Image.asset('assets/images/cf_logo_white.svg', fit: BoxFit.cover),
          title: SvgPicture.asset('assets/images/cf_logo_white.svg',
              fit: BoxFit.cover),
        ),
        body: BlocProvider(
          create: (context) {
            DevicesPageBloc bloc = DevicesPageBloc(
                errorMessageRepository:
                    RepositoryProvider.of<ErrorMessageRepository>(context),
                serialPortRepository:
                    RepositoryProvider.of<SerialPortRepository>(context),
                serialDeviceRepository:
                    RepositoryProvider.of<SerialDeviceRepository>(context));

            // Fire event to load ports
            bloc.add(new GetDevicesEvent());
            return bloc;
          },
          child: ErrorWrapper(child: DevicesScreen()),
        ),
      ),
    );
  }
}
