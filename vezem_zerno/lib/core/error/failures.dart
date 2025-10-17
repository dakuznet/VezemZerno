abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

class UserAlreadyExistsFailure extends Failure {
  UserAlreadyExistsFailure([
    super.message = 'Пользователь с таким номером телефона уже зарегистрирован',
  ]);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}


