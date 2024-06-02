import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';

class HomePage extends StatefulWidget {
  final String? savedEmail;
  final String? savedPassword;

  HomePage({required this.savedEmail, required this.savedPassword});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var jsonList;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A141C),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isSearching ? 60 : 100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF0D1F29),
            title: _isSearching ? _buildSearchBar() : _buildDefaultAppBar(),
            bottom: _isSearching
                ? null
                : PreferredSize(
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
                          InkWell(
                            onTap: () {
                              // Xử lý khi nhấn vào nút
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 50,
                                  child:
                                      Image.asset('assets/images/Emerald.png'),
                                ),
                                SizedBox(width: 0),
                                Text(
                                  '5',
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
                                style: TextStyle(
                                  color: Color(0xFF8D8E99),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '7',
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
                              setState(() {
                                _isSearching = true;
                              });
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

  Widget _buildDefaultAppBar() {
    return Text('');
  }

  Widget _buildSearchBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Image.asset('assets/icons/tune.png'),
              onPressed: () {
                // Handle filter button press
              },
            ),
            Expanded(
              child: Container(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(44.0),
                      borderSide: BorderSide(color: Color(0xFF8D8E99)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Image.asset('assets/icons/search.png'),
                      onPressed: () {
                        // Handle the send button press
                      },
                    ),
                  ),
                  cursorColor: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: Image.asset('assets/icons/close.png'),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
