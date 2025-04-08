import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Help',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Your last trip"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('19/12/22 , 12:03am'), Text('\$35.00')],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15)),
                height: 150,
                width: double.infinity,
              ),
              SizedBox(
                height: 5,
              ),
              Text('Report an issue with this trip'),
              SizedBox(
                height: 20,
              ),
              Text(
                "All Topics",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Help with trip',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Account',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Membership and loyalty',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Grievance Redressal',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'A guide to Uber',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Uber shuttle',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Accessibility',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'About cancellation policy',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Report a map issue',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
