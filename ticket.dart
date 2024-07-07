import 'package:flutter/material.dart';

void main() => runApp(TicketApp());

class TicketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Generation',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Color(0xFF43328b),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Ticket()),
                );
              },
              child: Text('Generate Ticket (Hostelite)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WardenView(ticketList: ticketList)),
                );
              },
              child: Text('View Tickets (Warden)'),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String>> ticketList = [];

class Ticket extends StatefulWidget {
  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  final TextEditingController _controller = TextEditingController();

  void _addTicket() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        ticketList.add({
          'ticket': _controller.text,
          'response': ''
        });
        _controller.clear();
      });
    }
  }

  void _navigateToListPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TicketListPage(ticketList: ticketList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Ticket'),
        centerTitle: true,
        backgroundColor: Color(0xFF43328b),
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
        child: Center(
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildServiceGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildServiceContainer('assets/clean.jpg'),
            SizedBox(width: 20),
            _buildServiceContainer('assets/electric.jpg'),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildServiceContainer('assets/plumbing.jpg'),
            SizedBox(width: 20),
            _buildServiceContainer('assets/powerwashing.jpg'),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceContainer(String imagePath) {
    return Container(
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
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
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF43328b),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'College',
        ),
      ],
      backgroundColor: Color(0xFF43328b),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    );
  }
}

class TicketListPage extends StatelessWidget {
  final List<Map<String, String>> ticketList;

  TicketListPage({required this.ticketList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket List'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 124, 70, 210),
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
        child: ListView.builder(
          itemCount: ticketList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  ticketList[index]['ticket']!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
                subtitle: Text(
                  'Response: ${ticketList[index]['response']!}',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WardenView extends StatefulWidget {
  final List<Map<String, String>> ticketList;

  WardenView({required this.ticketList});

  @override
  _WardenViewState createState() => _WardenViewState();
}

class _WardenViewState extends State<WardenView> {
  final TextEditingController _responseController = TextEditingController();

  void _respondToTicket(int index) {
    if (_responseController.text.isNotEmpty) {
      setState(() {
        widget.ticketList[index]['response'] = _responseController.text;
        _responseController.clear();
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warden View Tickets'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.green.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: widget.ticketList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  widget.ticketList[index]['ticket']!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
                subtitle: Text(
                  'Response: ${widget.ticketList[index]['response']!}',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: () {
                    _showResponseDialog(context, index);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showResponseDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Respond to Ticket'),
          content: TextFormField(
            controller: _responseController,
            decoration: InputDecoration(
              hintText: 'Enter your response...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _respondToTicket(index),
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
