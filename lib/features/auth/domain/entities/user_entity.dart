class UserEntity{

  String uid;
  String email;
  String name;

  UserEntity({
    required this.uid,
    required this.email,
    required this.name
  });

}

class Response {

  UserEntity? user;
  String? error;

  Response({
    this.user,
    this.error
  });

}