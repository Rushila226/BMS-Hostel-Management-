//hostelside view tickets
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TicketListPage extends StatelessWidget {
  final String userId;

  TicketListPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket List',
        style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xFF43328b),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),

      ),
      body: Container(
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tickets')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> tickets = snapshot.data!.docs;

            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return Card(
                  
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Color.fromARGB(255, 255, 253, 253),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.black12,
                      width: 2,
                    ),
                    
                  ),
                  child: ListTile(
                    title: Text(
                      'Service:${tickets[index]['category'] ?? ''}'
                      ,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Message: ${tickets[index]['message'] ?? ''}',
                          style: TextStyle(
                            color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,


                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Status: ${tickets[index]['status'] ?? ''}',
                          style: TextStyle(
                            color: tickets[index]['status'] == 'Pending'
                                ? Colors.orange
                                : tickets[index]['status'] == 'Completed'
                                    ? Colors.green
                                    : tickets[index]['status'] == 'In Progress'
                                        ? Colors.blue
                                        : tickets[index]['status'] == 'Cancelled'
                                            ? Colors.red
                                            : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
