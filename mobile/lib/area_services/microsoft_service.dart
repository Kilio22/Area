import 'dart:async';

import 'package:area/area_services_widget/area_service_widget_base.dart';
import 'package:area/area_services_widget/service_widget_factory.dart';
import 'package:area/models/service.dart';

class MicrosoftService extends Service {
  const MicrosoftService()
      : super('Microsoft', '/connect/microsoft', 'msauth.area.app', 'msauth.area.app://auth', '/connect/microsoft/callback',
            'assets/images/microsoft.png', true, true);

  @override
  AreaServiceWidgetBase createServiceWidgetInstance(StreamController<Map<String, dynamic>> streamParamsController, bool isAction,
      [Map<String, dynamic> params = const {}]) {
    return ServiceWidgetFactory.createServiceWidgetInstance('microsoft', streamParamsController, isAction, params);
  }
}
