import 'package:area/exceptions/area_exception.dart';

class AlreadyExistsException extends AreaException {
  AlreadyExistsException({String cause = ""}) : super(cause: cause);
}
