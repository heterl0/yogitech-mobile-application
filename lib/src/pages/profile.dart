import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _nameState();
}

class _nameState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A141C),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF0D1F29),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  right: 20.0,
                  left: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/icons/share.png'),
                      onPressed: () {},
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Image.asset('assets/icons/settings.png'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 160, // 2 * radius + 8 (border width) * 2
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueGrey, // Set the border color
                            width: 1.5, // Set the border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 78,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        // userName,
                        'Duy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Calorie',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Your total of calories',
                                    style: TextStyle(
                                      color: Color(0xFF8D8E99),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              // Sử dụng InkWell hoặc GestureDetector với một hình ảnh
                              InkWell(
                                onTap: () {
                                  // Xử lý sự kiện khi button được nhấn
                                  print('Button pressed');
                                  // Thêm các lệnh xử lý sự kiện của bạn ở đây
                                },
                                child: Image.asset(
                                  'assets/icons/info.png',
                                  width: 20, // Đặt kích thước cho hình ảnh
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Social',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Your friends and more',
                                    style: TextStyle(
                                      color: Color(0xFF8D8E99),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              // Sử dụng InkWell hoặc GestureDetector với một hình ảnh
                              InkWell(
                                onTap: () {
                                  // Xử lý sự kiện khi button được nhấn
                                  print('Button pressed');
                                },
                                child: Image.asset(
                                  'assets/icons/diversity_2.png',
                                  width: 20, // Đặt kích thước cho hình ảnh
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Personalized Exercise',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Your customize exercise',
                                    style: TextStyle(
                                      color: Color(0xFF8D8E99),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              // Sử dụng InkWell hoặc GestureDetector với một hình ảnh
                              InkWell(
                                onTap: () {
                                  // Xử lý sự kiện khi button được nhấn
                                  print('Button pressed');
                                },
                                child: Image.asset(
                                  'assets/icons/tune_setting.png',
                                  width: 20, // Đặt kích thước cho hình ảnh
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Additional Rows can be added below
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '6', // Replace with API data
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: Color(0xFF8D8E99),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '7', // Replace with API data
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Follower',
                                style: TextStyle(
                                  color: Color(0xFF8D8E99),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'EXP',
                                style: TextStyle(
                                  color: Color(0xFF8D8E99),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '999', // Replace with API data
                                style: TextStyle(
                                    color: Color(0xFF4095D0),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF8D8E99)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'BMI',
                                style: TextStyle(
                                  color: Color(0xFF8D8E99),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '18.5', // Replace with API data
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add content for second row
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(0.0),
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF8D8E99)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0), // Added space for better layout
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(44.0),
                        border:
                            Border.all(color: Color(0xFFFF5858), width: 3.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Xử lý sự kiện khi nhấn vào nút "Đăng xuất"
                          },
                          borderRadius: BorderRadius.circular(44.0),
                          child: Center(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Color(0xFFFF5858),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
