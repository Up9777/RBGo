import 'package:flutter/material.dart';
import 'package:rbgo/home/chooseRide.dart';
import 'package:rbgo/main.dart';

class Rides extends StatefulWidget {
  String type;
  Rides({super.key, required this.type});

  @override
  State<Rides> createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  // List of Mumbai locations
  final List<String> mumbaiLocations = [
    'Bandra',
    'Andheri',
    'Colaba',
    'Juhu',
    'Powai',
    'Malad',
    'Versova',
    'Dadar',
    'Worli',
    'Borivali'
  ];

  // Variables to store selected locations
  String? selectedCurrentLocation;
  String? selectedDestination;

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
          'Book ${widget.type}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              // Current Location Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: DropdownButton<String>(
                  value: selectedCurrentLocation,
                  hint: Text("Select your current location"),
                  isExpanded: true,
                  icon: Icon(Icons.location_on_outlined,
                      color: Colors.grey.shade700),
                  underline: SizedBox(),
                  items: mumbaiLocations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCurrentLocation = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              // Destination Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: DropdownButton<String>(
                  value: selectedDestination,
                  hint: Text("Select your destination"),
                  isExpanded: true,
                  icon: Icon(Icons.location_on, color: Colors.grey.shade700),
                  underline: SizedBox(),
                  items: mumbaiLocations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDestination = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedCurrentLocation != null &&
                      selectedDestination != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chooseride(
                          currentLocation: selectedCurrentLocation!,
                          destination: selectedDestination!, type: widget.type,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select both locations')),
                    );
                  }
                },
                child: Text("Continue"),
              ),
              Divider(),
              SizedBox(height: 20),
              Text(
                'Rides Available',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: 20),
              ListTile(
                onTap: () {
                  if (selectedCurrentLocation != null &&
                      selectedDestination != null) {
                    navi(
                      context,
                      Chooseride(
                        currentLocation: selectedCurrentLocation!,
                        destination: selectedDestination!, type: widget.type,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select both locations')),
                    );
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  radius: 25,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img_8.png',
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                title: Text(
                  "RB Auto",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Rs. 40 - 5 min away"),
                trailing: Icon(Icons.arrow_right_alt),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  if (selectedCurrentLocation != null &&
                      selectedDestination != null) {
                    navi(
                      context,
                      Chooseride(
                        currentLocation: selectedCurrentLocation!,
                        destination: selectedDestination!, type: widget.type,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select both locations')),
                    );
                  }
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  radius: 25,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img_1.png',
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                title: Text(
                  "4 Seater",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Rs. 80 - 5 min away"),
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
