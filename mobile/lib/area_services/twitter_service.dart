import 'dart:async';

import 'package:area/area_services_widget/area_service_widget_base.dart';
import 'package:area/area_services_widget/service_widget_factory.dart';
import 'package:area/models/service.dart';

class TwitterService extends Service {
  const TwitterService()
      : super('Twitter', '/connect/twitter', 'area.app', 'area.app://', '/connect/twitter/callback', 'assets/images/twitter.png', false,
            true);

  @override
  AreaServiceWidgetBase createServiceWidgetInstance(StreamController<Map<String, dynamic>> streamParamsController, bool isAction,
      [Map<String, dynamic> params = const {}]) {
    return ServiceWidgetFactory.createServiceWidgetInstance('twitter', streamParamsController, isAction, params);
  }
}
