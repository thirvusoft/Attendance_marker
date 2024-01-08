import 'package:attendancemarker/Page/lead.dart';
import 'package:flutter/material.dart';



class HomePage extends StatelessWidget {

// This widget is the root of your application
@override
// Sample list of dictionaries
  final List<Map<String, dynamic>> dataList = [
    {'title': 'Lead', 'image': 'assets/images/lead.png'},
    {'title': 'Follow Up', 'image': 'assets/images/followup.png'},
    {'title': 'CallHistory', 'image': 'assets/images/callhistory.png'},
   
    {'title': 'Item 6', 'image': 'assets/images/lead.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFEA5455),
        title: const Center(
          child: Text(
            'Lead',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
           return GestureDetector(
            onTap: () {
              // Navigate to a new screen based on the title
              navigateToScreen(context, dataList[index]['title']);
            },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFEA5455),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100, // Adjust the height of the image container as needed
                    decoration: BoxDecoration(
                    
                      image: DecorationImage(
                        image:AssetImage(dataList[index]['image']) ,
                        fit: BoxFit.contain, // Ensures that the image covers the entire container
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Adjust the spacing between image and text
                  Text(
                    dataList[index]['title'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
   void navigateToScreen(BuildContext context, String title) {
    // Implement your navigation logic here
    // Example: Navigate to different screens based on the title
    if (title == 'Lead') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LeadPage()));
    } else if (title == 'Follow Up') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LeadPage()));
    } else if (title == 'CallHistory') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LeadPage()));
    } else {
      // Handle other cases as needed
    }
  }

}