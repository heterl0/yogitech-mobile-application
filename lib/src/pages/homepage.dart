import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/features/api_service.dart';

class HomePage extends StatefulWidget {
  final String? savedEmail;
  final String? savedPassword;

  HomePage({required this.savedEmail, required this.savedPassword});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var jsonList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A141C),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Set the height of the AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false, // Disable the back button
            backgroundColor: Color(0xFF0D1F29),
            bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(0), // Set the height of the bottom content
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  right: 20.0,
                  left: 20.0,
                ), // Padding bottom content

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // Xử lý khi nhấn vào nút
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 40, // Đặt chiều rộng cho hình ảnh
                            height: 50, // Đặt chiều cao cho hình ảnh
                            child: Image.asset('assets/images/Emerald.png'),
                          ),
                          SizedBox(width: 0), // Khoảng cách giữa hình ảnh và số
                          Text(
                            '5', // Số hiển thị sau hình ảnh
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Streak',
                          style:
                              TextStyle(color: Color(0xFF8D8E99), fontSize: 16),
                        ),
                        Text(
                          '7', // Số ngày duy trì sử dụng app (có thể thay đổi)
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        // Xử lý khi nhấn nút tìm kiếm
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                child: Text(
                  'Try this exercise for beginners',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Placeholder for ad content
              Container(
                height: 200, // Example height, replace with actual ad content
                color: Colors.grey[300],
                child: Center(
                  child: Text('Advertisement Placeholder'),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'For You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Replace these placeholders with your actual content
                    Container(
                      width: 150,
                      height: 132,
                      color: Colors.blue,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Content 1')),
                    ),
                    Container(
                      width: 150,
                      height: 132,
                      color: Colors.green,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Content 2')),
                    ),
                    Container(
                      width: 150,
                      height: 132,
                      color: Colors.orange,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Content 3')),
                    ),
                    // Add more containers if needed
                  ],
                ),
              ),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Newest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Similar to the "For You" section, add your content here
                    Container(
                      width: 150,
                      height: 132,
                      color: Colors.blue,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Content 1')),
                    ),
                    Container(
                      width: 150,
                      height: 132,
                      color: Colors.green,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Content 2')),
                    ),
                    Container(
                      width: 150,
                      height: 132,
                      color: Colors.orange,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child: Text('Content 3')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
