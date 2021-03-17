import 'dart:async';

import 'package:area/area_services_widget/area_service_widget_base.dart';
import 'package:area/area_services_widget/service_widget_factory.dart';
import 'package:area/models/service.dart';

class GithubService extends Service {
  const GithubService()
      : super(
            'Github', '/connect/github', 'area.app', 'area.app://auth', '/connect/github/callback', 'assets/images/github.png', true, true);

  @override
  AreaServiceWidgetBase createServiceWidgetInstance(StreamController<Map<String, dynamic>> streamParamsController, bool isAction,
      [Map<String, dynamic> params = const {}]) {
    return ServiceWidgetFactory.createServiceWidgetInstance('github', streamParamsController, isAction, params);
  }
}
