import 'dart:convert';
import 'package:blogs/Model/blogs_model.dart';
import 'package:blogs/blogCard.dart';

import 'package:blogs/network_services/headers.dart';
import 'package:blogs/network_services/urls.dart';
import 'package:blogs/screens/addNewblog.dart';
import 'package:blogs/screens/signOut_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool inProgress = true;
  late TabController _tabController;
  List<Blogs_Model> allBlogs = [];
  List<Blogs_Model> myBlogs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchBlogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignoutScreen()));
          }, icon: Icon(Icons.person_sharp))
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.black.withOpacity(0.4),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
          tabs: const [
            Tab(text: 'All Blogs'),
            Tab(text: 'My Blogs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBlogsList(allBlogs),
          _buildBlogsList(myBlogs),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Addnewblog()));
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBlogsList(List<Blogs_Model> blogs) {
    return RefreshIndicator(
      onRefresh: _fetchBlogs,
      child: inProgress
          ? const Center(child: CircularProgressIndicator())
          : blogs.isEmpty
          ? const Center(child: Text('No blogs available'))
          : ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          return _buildBlogCard(blog);
        },
      ),
    );
  }

  Widget _buildBlogCard(Blogs_Model blog) {
    return BlogCard(blog: blog);
  }

  Future<void> _fetchBlogs() async {
    setState(() {
      inProgress = true;
    });

    try {
      Response response = await get(Uri.parse(Urls.blog));
      Response res = await get(Uri.parse(Urls.myBlog), headers: Headers.myPostsHeader);
      if(res.statusCode == 200){
        final List<dynamic> data = List<dynamic>.from(jsonDecode(res.body));
        List<Blogs_Model> myblogs = data
            .map((e) => Blogs_Model.fromJson(e))
            .toList();
        myBlogs = myblogs;
      }
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print("Printing re.body");
        List<Blogs_Model> blogs = (decodedData as List)
            .map((item) => Blogs_Model.fromJson(item))
            .toList();

        setState(() {
          allBlogs = blogs;
          inProgress = false;
        });
      } else {
        setState(() {
          inProgress = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load blogs')),
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        inProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}