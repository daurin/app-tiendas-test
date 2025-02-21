abstract class Event<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}