import 'package:area/exceptions/area_exception.dart';

class WrongEmailPasswordCombinationException extends AreaException {
  WrongEmailPasswordCombinationException({String cause = ""}) : super(cause: cause);
}
