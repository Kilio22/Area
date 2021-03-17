import 'package:area/exceptions/area_exception.dart';

class BadTokenException extends AreaException {
  BadTokenException({String cause = ""}) : super(cause: cause);
}
