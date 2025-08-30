
import 'package:blogs/network_services/New/new_network_caller.dart';
import 'package:blogs/network_services/auth_controller.dart';
import 'package:blogs/network_services/urls.dart';
import 'package:blogs/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Addnewblog extends StatefulWidget {
  const Addnewblog({super.key});

  @override
  State<Addnewblog> createState() => _AddnewblogState();
}

class _AddnewblogState extends State<Addnewblog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(AuthController.accessToken);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post New Blog",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _descriptionController,
              maxLines: 8,decoration: InputDecoration(
              hintText: 'Description'
            ),),
            SizedBox(height: 24,),
            SizedBox(width:200,child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                onPressed: ()async{
              _onPost();
            }, child: Text("Post"))),
          ],
        ),
      ),
    );
  }
  Future<void> _onPost()async{
    final requestBody = {
      'title': _titleController.text.trim(),
      'description':_descriptionController.text.trim(),
    };
    final Map<String,String>header = {
      'content-type':'application/json',
      "Authorization": "Bearer ${AuthController.accessToken ?? ''}",
    };
    NewNetworkResponse response = await New_Network_Caller.postRequest(uri: Urls.postBlog,header:header,body: requestBody);
    print(response.statuscode);
    if(response.isSuccess){
      print(response.body);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (predicate)=>false);
    }
  }
}
