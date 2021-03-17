import 'dart:async';

import 'package:area/area_services_widget/timer_service_widget.dart';
import 'package:area/area_services_widget/twitter_service_widget.dart';

import 'area_service_widget_base.dart';
import 'discord_service_widget.dart';
import 'github_service_widget.dart';
import 'google_service_widget.dart';
import 'microsoft_service_widget.dart';

class ServiceWidgetFactory {
  static const Map<String, Function> SERVICE_FACTORY_MAP = {
    "discord": DiscordServiceWidget.create,
    "github": GithubServiceWidget.create,
    "google": GoogleServiceWidget.create,
    "microsoft": MicrosoftServiceWidget.create,
    "timer": TimerServiceWidget.create,
    "twitter": TwitterServiceWidget.create
  };

  static AreaServiceWidgetBase createServiceWidgetInstance(
      String serviceName, StreamController<Map<String, dynamic>> streamParamsController, bool isAction,
      [Map<String, dynamic> params = const {}]) {
    return SERVICE_FACTORY_MAP[serviceName](streamParamsController, isAction, params);
  }
}
