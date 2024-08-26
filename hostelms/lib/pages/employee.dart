import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hostelms/local_notifications/noticlass.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:your_app/notification_services.dart';
//second page of announcements

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  late CollectionReference fileRef;
  List<PlatformFile> _files = [];
  bool _uploadInProgress = false;
  TextEditingController _messageController = TextEditingController();
  final NotificationServices _notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    fileRef = FirebaseFirestore.instance.collection('files');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick and View Files'),
        actions: [
          ElevatedButton(
            onPressed: _uploadInProgress ? null : () async {
              setState(() {
                _uploadInProgress = true;
              });
              await uploadFiles().whenComplete(() {
                setState(() {
                  _uploadInProgress = false;
                });
                _notificationServices.sendNotifications(
                  'Announcements',
                  _messageController.text,
                  'warden',
                );
                Navigator.of(context).pop();
              });
            },
            child: Text('Upload'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                if (result == null) return;

                setState(() {
                  _files = result.files;
                });
              },
              child: Text('Pick Files'),
            ),
            if (_files.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _files.length,
                  itemBuilder: (context, index) {
                    final file = _files[index];
                    return buildFile(file);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildFile(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = file.extension ?? 'none';
    final color = getColor(extension);

    return InkWell(
      onTap: () {
        OpenFile.open(file.path!);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '.$extension',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              file.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              fileSize,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadFiles() async {
    List<String> fileUrls = [];
    List<String> fileNames = [];

    for (var file in _files) {
      final savedFile = await saveFilePermanently(file);
      if (await validateFile(savedFile)) {
        final url = await uploadFile(savedFile);
        fileUrls.add(url);
        fileNames.add(file.name);
      } else {
        print('File ${savedFile.path} did not meet the upload criteria.');
      }
    }

    if (fileUrls.isNotEmpty && fileNames.isNotEmpty) {
      await fileRef.add({
        'fileUrls': fileUrls,
        'fileNames': fileNames,
        'message': _messageController.text,
        'uploadedAt': Timestamp.now(),
        'uploadedBy': FirebaseAuth.instance.currentUser!.uid,
      });
      print('Files uploaded with URLs: $fileUrls');
    }
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  Future<String> uploadFile(File file) async {
    try {
      final fileName = path.basename(file.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child('uploads/$fileName');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }

  Future<bool> validateFile(File file) async {
    final fileSize = await file.length();
    return fileSize < 10 * 1024 * 1024;
  }

  Color getColor(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.blue;
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.green;
      case 'mp4':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
