import 'package:intl/intl.dart';

class Blogs_Model{
  final String uid;
  final String author;
  final String first_name;
  final String last_name;
  final String title;
  final String description;
  final String created_at;

  Blogs_Model({required this.author, required this.first_name, required this.last_name, required this.description,required this.created_at, required this.uid,required this.title});

  factory Blogs_Model.fromJson(Map<String, dynamic> json) {
    String formatted = '';
    if (json['created_at'] != null && json['created_at'].toString().isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(json['created_at']);
        formatted = DateFormat("d MMMM yyyy").format(dateTime);
      } catch (e) {
        formatted = json['created_at'].toString(); // fallback
      }
    }

    return Blogs_Model(
      author: json['author'] ?? '',
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      description: json['description'] ?? '',
      created_at: formatted,
      uid: json['uid'] ?? '',
      title: json['title'] ?? '',
    );
  }


  Map<String,dynamic> toJson(){
    return {
      'title':title,
      'uid':uid,
      'first_name':first_name,
      'last_name':last_name,
      'author':author,
      "description":description,
      'created_at':created_at,
    };
  }
}