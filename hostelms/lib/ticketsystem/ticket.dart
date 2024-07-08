//hostel side raising tickets

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelms/ticketsystem/ticketList.dart';

class Ticket extends StatefulWidget {
  final String userId;

  Ticket({required this.userId});

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  final TextEditingController _controller = TextEditingController();
  String _selectedCategory = '';

  final List<String> _categories = [
    'Electricity',
    'Plumbing',
    'Water Issue',
    'Washing Machine',
  ];

  void _addTicket() {
    if (_controller.text.isNotEmpty && _selectedCategory.isNotEmpty) {
      // Fetch user details to get allocated_hostel
      FirebaseFirestore.instance.collection('user').doc(widget.userId).get().then((userSnapshot) {
        if (!userSnapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not found!'),
            ),
          );
          return;
        }

        final allocatedHostel = userSnapshot.data()?['allocated_hostel'];

        // Fetch hostelite details to get room_number
        FirebaseFirestore.instance.collection('hosteliteDetails').doc(widget.userId).get().then((hosteliteSnapshot) {
          if (!hosteliteSnapshot.exists) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hostelite details not found!'),
              ),
            );
            return;
          }

          final roomNumber = hosteliteSnapshot.data()?['room_number'];

          // Add ticket to Firestore
          FirebaseFirestore.instance.collection('tickets').add({
            'userId': widget.userId,
            'category': _selectedCategory,
            'message': _controller.text,
            'timestamp': Timestamp.now(),
            'status': 'Pending', // Default status is Pending
            'allocated_hostel': allocatedHostel,
            'room_number': roomNumber,
          }).then((value) {
            setState(() {
              _controller.clear();
              _selectedCategory = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ticket generated successfully!'),
              ),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to generate ticket: $error'),
              ),
            );
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error fetching hostelite details: $error'),
            ),
          );
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching user details: $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category and enter details.'),
        ),
      );
    }
  }

  void _navigateToListPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TicketListPage(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generate Ticket',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF43328b),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(255, 117, 80, 182),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose the service',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 20),
                _buildServiceGrid(),
                SizedBox(height: 20),
                _buildInputField(),
                SizedBox(height: 20),
                _buildButton('Add Ticket', _addTicket),
                SizedBox(height: 10),
                _buildButton('View Tickets', _navigateToListPage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _categories.sublist(0, 2).map((category) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Column(
                children: [
                  _buildServiceContainer(category),
                  Text(
                    category,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedCategory == category ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _categories.sublist(2, 4).map((category) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Column(
                children: [
                  _buildServiceContainer(category),
                  Text(
                    category,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedCategory == category ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceContainer(String category) {
    String imageAsset;
    switch (category) {
      case 'Electricity':
        imageAsset = 'images/electric.jpg';
        break;
      case 'Plumbing':
        imageAsset = 'images/plumbing.jpg';
        break;
      case 'Water Issue':
        imageAsset = 'images/water.jpeg';
        break;
      case 'Washing Machine':
        imageAsset = 'images/washing.jpeg';
        break;
      default:
        imageAsset = 'null';
    }

    return Container(
      margin: EdgeInsets.all(8.0),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(3, 3),
            blurRadius: 5,
          ),
        ],
        color: _selectedCategory == category ? Colors.blue : Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imageAsset,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          hintText: 'Enter your details here...',
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        maxLines: 3,
        style: TextStyle(color: Colors.black),
        onEditingComplete: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard
        },
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF43328b),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}


