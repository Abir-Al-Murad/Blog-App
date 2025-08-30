import 'package:blogs/Model/profile_model.dart';

class User_Model{
  final String uid;
  final String email;
  final String username;
  final String firstname;
  final String lastname;
  final Profile_model profile_model;

  User_Model({
    required this.uid,
    required this.email,
    required this.username,
    required this.profile_model,
    required this.firstname,
    required this.lastname,
});

  factory User_Model.fromJson(Map<String,dynamic> json){
    return User_Model(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstname: json['first_name']??'',
      lastname: json['last_name']??'',
      profile_model: Profile_model.fromJson(json['profile'] ?? {}),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'uid':uid,
      'email':email,
      'username':username,
      'first_name':firstname,
      'last_name':lastname,
      'profile_model':profile_model,
    };
  }

}

