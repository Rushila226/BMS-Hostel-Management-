//warden side tickets
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:c
class WardenTicketView extends StatefulWidget {
  final String userId; // Assuming you have the warden's userId

  const WardenTicketView({Key? key, required this.userId}) : super(key: key);

  @override
  _WardenTicketViewState createState() => _WardenTicketViewState();
}

class _WardenTicketViewState extends State<WardenTicketView> {
  late Future<String?> _allocatedHostelFuture;

  @override
  void initState() {
    super.initState();
    _allocatedHostelFuture = _getWardenAllocatedHostel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warden Tickets',
        style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromARGB(255, 36, 28, 70),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              const Color.fromARGB(255, 117, 80, 182),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<String?>(
          future: _allocatedHostelFuture,
          builder: (context, AsyncSnapshot<String?> hostelSnapshot) {
            if (hostelSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (hostelSnapshot.hasError) {
              return Center(child: Text('Error: ${hostelSnapshot.error}'));
            }
            if (!hostelSnapshot.hasData || hostelSnapshot.data == null) {
              return Center(child: Text('No allocated hostel found.'));
            }
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tickets')
                  .where('allocated_hostel', isEqualTo: hostelSnapshot.data)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No tickets found.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var ticket = snapshot.data!.docs[index];
                      var userId = ticket['userId'] as String?;
                      if (userId == null) {
                        return _buildTicketCard(ticket, 'Unknown User');
                      }
                      return FutureBuilder<String>(
                        future: _getUserFullName(userId),
                        builder: (context, AsyncSnapshot<String> userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildTicketCard(ticket, 'Loading...');
                          }
                          if (userSnapshot.hasError) {
                            return _buildTicketCard(
                                ticket, 'Error: ${userSnapshot.error}');
                          }
                          if (!userSnapshot.hasData) {
                            return _buildTicketCard(ticket, 'User not found');
                          }
                          return _buildTicketCard(ticket, userSnapshot.data!);
                        },
                      );
                    },
                  );
                }
                return Center(child: Text('Unexpected state.'));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTicketCard(DocumentSnapshot ticket, String fullName) {
    String status = ticket['status'] ?? 'Unknown';
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fullName.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF43328b),),
                ),
                Text(
                  _formatDate(ticket['timestamp']),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatTime(ticket['timestamp']),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Category: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ticket['category']),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Message: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ticket['message']),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Room Number: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ticket['room_number']),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: $status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (status != 'Completed' && status != 'Cancelled')
                  DropdownButton<String>(
                    value: status,
                    items: _getStatusOptions(status).map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        _updateTicketStatus(ticket.id, newValue);
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getStatusOptions(String currentStatus) {
    switch (currentStatus) {
      case 'Pending':
        return [
          'Pending',
          'In Progress',
          'Completed',
          'Cancelled',
          'Deferred'
        ];
      case 'In Progress':
        return ['In Progress', 'Completed', 'Deferred'];
      case 'Deferred':
        return [
          'Pending',
          'In Progress',
          'Completed',
          'Cancelled',
          'Deferred'
        ];
      default:
        return [];
    }
  }

  Future<void> _updateTicketStatus(String ticketId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('tickets')
        .doc(ticketId)
        .update({'status': newStatus});
    setState(() {}); // Refresh the UI
  }

  Future<String> _getUserFullName(String userId) async {
    var userRef = FirebaseFirestore.instance.collection('user').doc(userId);
    var snapshot = await userRef.get();
    if (snapshot.exists) {
      return snapshot['full_name'] ?? 'Unknown User';
    } else {
      return 'Unknown User';
    }
  }

  Future<String?> _getWardenAllocatedHostel() async {
    var userRef =
        FirebaseFirestore.instance.collection('user').doc(widget.userId);
    var userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      return userSnapshot['allocated_hostel'];
    } else {
      throw Exception('Warden not found');
    }
  }

  String _formatDate(Timestamp timestamp) {
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(timestamp.toDate());
  }

  String _formatTime(Timestamp timestamp) {
    var formatter = DateFormat('HH:mm');
    return formatter.format(timestamp.toDate());
  }
}
