import 'dart:async';

import 'package:area/area_services_widget/area_service_widget_base.dart';
import 'package:area/area_services_widget/service_widget_factory.dart';
import 'package:area/models/service.dart';

class GoogleService extends Service {
  const GoogleService()
      : super(
            'Google', '/connect/google', 'area.app', 'area.app:/auth', '/connect/google/callback', 'assets/images/google.png', true, false);

  @override
  AreaServiceWidgetBase createServiceWidgetInstance(StreamController<Map<String, dynamic>> streamParamsController, bool isAction,
      [Map<String, dynamic> params = const {}]) {
    return ServiceWidgetFactory.createServiceWidgetInstance('google', streamParamsController, isAction, params);
  }
}
