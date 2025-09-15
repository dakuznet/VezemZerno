class Failure {
  final String message;
  Failure(this.message);
}

class UserAlreadyExistsFailure extends Failure {
  UserAlreadyExistsFailure([super.message = 'Пользователь с таким номером телефона уже зарегистрирован']);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}