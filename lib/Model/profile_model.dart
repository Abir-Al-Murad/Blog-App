import 'dart:io';

class Profile_model{
  final File? profile_image;
  final String? bio;
  final String? location;
  final String? phone_number;
  final String? birth_date;

  Profile_model({this.location, this.phone_number, this.birth_date, this.profile_image,this.bio});

  factory Profile_model.fromJson(Map<String,dynamic>json){
    return Profile_model(
      profile_image: json['profile_image'],
      bio: json['bio'],
      location: json['location'],
      phone_number: json['phone_number'],
      birth_date: json['birth_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_image': profile_image,
      'bio': bio,
      'location': location,
      'phone_number': phone_number,
      'birth_date': birth_date,
    };
  }
}