import 'package:flutter/material.dart';
import 'package:rbgo/home/chooseRide.dart';
import 'package:rbgo/main.dart';

class Rides extends StatefulWidget {
  const Rides({super.key});

  @override
  State<Rides> createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/img_7.png"),
            ),
          )
        ],
        title: Text(
          'RB Go',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "What's your current location?",
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.location_on_outlined, // Set the desired icon here
                    color: Colors.grey.shade700, // Adjust the color if needed
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Set the border radius here
                    borderSide: BorderSide.none, // Make the border invisible
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Where do you want to travel ?",
                  prefixIcon: Icon(
                    Icons.location_on, // Set the desired icon here
                    color: Colors.grey.shade700, // Adjust the color if needed
                  ),
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Set the border radius here
                    borderSide: BorderSide.none, // Make the border invisible
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Rides Available',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: (){
                  navi(context, Chooseride());
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  radius: 25,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img_8.png',
                      fit: BoxFit.cover,
                      width: 40, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                    ),
                  ),
                ),
                title: Text(
                  "RB Auto",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("\$23 - 5 min away"),
                trailing: Icon(Icons.arrow_right_alt),
              ),
              Divider(),
              ListTile(onTap: (){
                navi(context, Chooseride());
              },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  radius: 25,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img_1.png',
                      fit: BoxFit.cover,
                      width: 40, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                    ),
                  ),
                ),
                title: Text("4 Seater",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("\$23 - 5 min away"),
                trailing: Icon(Icons.arrow_right_alt),
              ),
              Divider(),
              ListTile(onTap: (){
                navi(context, Chooseride());
              },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  radius: 25,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img_9.png',
                      fit: BoxFit.cover,
                      width: 40, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                    ),
                  ),
                ),
                title: Text("6 Seater Premium",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("\$23 - 5 min away"),
                trailing: Icon(Icons.arrow_right_alt),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
