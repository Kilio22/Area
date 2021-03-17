import 'package:area/exceptions/area_exception.dart';

class BadResponseException extends AreaException {
  BadResponseException({String cause = ""}) : super(cause: cause);
}
