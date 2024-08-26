//navigation bar
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hostelms/leaves/leavehostel.dart';
import 'package:hostelms/leaves/wardenleave.dart';
import 'package:hostelms/logsign/screens/profilescreen.dart';
import 'package:hostelms/pages/home.dart';
import 'package:hostelms/pages/homepage.dart';
// import 'package:hostelms/pages/homepage.dart';
import 'package:hostelms/ticketsystem/ticket.dart';
import 'package:hostelms/ticketsystem/wardenTicketview.dart';

class Navigation extends StatefulWidget {
  final String userType;
  final String userId;

  const Navigation({Key? key, required this.userType, required this.userId}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final PageController _pageController = PageController(initialPage: 1); // Set initial page index

  late final List<Widget> _pages;
  late final List<Widget> _navigationItem;

  @override
  void initState() {
    super.initState();

    if (widget.userType == 'hostelite') {
      _pages = [
        Home(userType: widget.userType),//announcements
        ProfileScreen(userId: widget.userId),//hostelcard
        Homepage(userId: widget.userId,userType: widget.userType),//homepage
        LeaveApplicationForm(),//leave
        Ticket(userId: widget.userId),//ticket
      ];

      _navigationItem = [
        const Icon(Icons.announcement, color: Colors.white),
        const Icon(Icons.person, color: Colors.white),
        const Icon(Icons.home, color: Colors.white),
        const Icon(Icons.mail, color: Colors.white),
        const Icon(Icons.build, color: Colors.white),
      ];
    } else {
      _pages = [
        Home(userType: widget.userType),//announcements
       

        Homepage(userId: widget.userId,userType: widget.userType,),//homepage
        WardenLeaveApplicationsPage(),
        WardenTicketView(userId: widget.userId),
      ];

      _navigationItem = [
        const Icon(Icons.announcement, color: Colors.white),
        const Icon(Icons.home, color: Colors.white),
        const Icon(Icons.mail, color: Colors.white),
        const Icon(Icons.build, color: Colors.white),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Prevents resizing when the keyboard appears
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: _pages,
          onPageChanged: (index) {
            setState(() {});
          },
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(243, 122, 87, 183),
        color: Color.fromARGB(220, 51, 5, 77),
        buttonBackgroundColor: Color.fromARGB(243, 34, 20, 58),
        index: 0,
        animationDuration: Duration(milliseconds: 300),
        items: _navigationItem,
        height: 60,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
