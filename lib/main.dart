import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    theme: ThemeData(fontFamily: 'Roboto'),
    home: MyApp(),
  ));
}

Future<User> fetchUser() async {
  print("fetching");

  final response =
      await get(Uri.parse("http://192.168.87.64:3000/api/getUser"));

  if (response.statusCode == 200) {
    print("good request");
    return User.fromJson(jsonDecode(response.body));
  } else {
    print("failed request");
    throw Exception("failed to load");
  }
}

class User {
  final String username;

  const User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<User>? futureUserData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    log("MEOW");
    log("MEOW");
    futureUserData = fetchUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(46, 13, 12, 1),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
            Text("Gym Form Tracker"),
            Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 69, 97, 1),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _selectedIndex = 0;
          });
        },
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder<User>(
                    future: futureUserData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        double width = MediaQuery.of(context).size.width;
                        return Center(
                          child: Column(
                            children: [
                              Text(
                                "Welcome ${snapshot.data!.username}",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: width * 0.1,
                                  fontFamily: 'Teko',
                                ),
                              ),
                              Text(
                                "Lets Get Moving!",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 35,
                                  fontFamily: 'Teko',
                                ),
                              )
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "${snapshot.error}",
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        );
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(122, 40, 53, 1),
                ),
                child: Column(
                  children: [
                    Text(
                      "Your Workout For Today",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.25,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(122, 40, 53, 1),
                ),
                child: Column(
                  children: [
                    Text(
                      "Current Plan",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Text("HELLO!")
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Color.fromRGBO(255, 69, 97, 1),
        unselectedItemColor: Colors.amber,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        onTap: (index) => {
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease)
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home_filled),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: "workout",
          ),
        ],
      ),
    );
  }
}
