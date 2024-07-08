//this is hostelite side for applying leave
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostelms/leaves/viewleave.dart';
import 'package:intl/intl.dart';

class LeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _semesterController = TextEditingController();
  final _reasonController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  bool _parentApproval = false;

  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedFromDate) {
      setState(() {
        _selectedFromDate = picked;
        _fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate ?? DateTime.now(),
      firstDate: _selectedFromDate ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedToDate) {
      setState(() {
        _selectedToDate = picked;
        _toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final leaveData = {
          'uid': user.uid,
          'semester': _semesterController.text,
          'reason': _reasonController.text,
          'fromDate': _fromDateController.text,
          'toDate': _toDateController.text,
          'emergencyPhone': _emergencyPhoneController.text,
          'parentApproval': _parentApproval,
          'timestamp': FieldValue.serverTimestamp(), // Add current timestamp
        };

        FirebaseFirestore.instance
            .collection('leaveApplications')
            .add(leaveData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave application submitted!')),
        );

        // Clear all fields after submission
        _semesterController.clear();
        _reasonController.clear();
        _fromDateController.clear();
        _toDateController.clear();
        _emergencyPhoneController.clear();
        _parentApproval = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leave Application')),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _semesterController,
                          decoration: InputDecoration(labelText: 'Semester', labelStyle: TextStyle(color: Colors.black)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your semester';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _reasonController,
                          decoration: InputDecoration(labelText: 'Reason for Leave', labelStyle: TextStyle(color: Colors.black)),
                          maxLines: 2, // Allow up to 2 lines for the reason
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the reason for leave';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _fromDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'From Date',
                            labelStyle: TextStyle(color: Colors.black),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the start date of leave';
                            }
                            return null;
                          },
                          onTap: () => _selectFromDate(context),
                        ),
                        TextFormField(
                          controller: _toDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'To Date',
                            labelStyle: TextStyle(color: Colors.black),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the end date of leave';
                            }
                            return null;
                          },
                          onTap: () => _selectToDate(context),
                        ),
                        TextFormField(
                          controller: _emergencyPhoneController,
                          decoration: InputDecoration(
                            labelText: 'Additional Phone No (Emergency)',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an emergency contact number';
                            }
                            return null;
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Have parents approved for leave?', style: TextStyle(color: Colors.black)),
                          value: _parentApproval,
                          onChanged: (value) {
                            setState(() {
                              _parentApproval = value!;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF43328b), // Purple color
                          ),
                          child: Text('Submit',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewLeaveApplicationsPage(),
                    ),
                  );
                },
                icon: Icon(Icons.list),
                label: Text('View Leave Applications'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF43328b),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
