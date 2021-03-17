import 'dart:async';

import 'package:area/area_services_widget/area_service_widget_base.dart';
import 'package:area/area_services_widget/service_widget_factory.dart';
import 'package:area/models/service.dart';

class TimerService extends Service {
  const TimerService() : super('Timer', null, null, null, null, null, true, false);

  @override
  AreaServiceWidgetBase createServiceWidgetInstance(StreamController<Map<String, dynamic>> streamParamsController, bool isAction,
      [Map<String, dynamic> params = const {}]) {
    return ServiceWidgetFactory.createServiceWidgetInstance('timer', streamParamsController, isAction, params);
  }
}
