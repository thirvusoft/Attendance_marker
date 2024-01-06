import 'package:flutter/material.dart';



class HomePage extends StatelessWidget {

// This widget is the root of your application
@override
// Sample list of dictionaries
  final List<Map<String, dynamic>> dataList = [
    {'title': 'Lead', 'image': 'https://w7.pngwing.com/pngs/652/528/png-transparent-computer-icons-business-lead-generation-company-lead-management-business-company-service-hand.png'},
    {'title': 'Follow Up', 'image': 'https://img.freepik.com/premium-vector/circular-marketing-icon_1453-93.jpg?w=2000'},
    {'title': 'Call History', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2HZk4rZUee8s-tSZroeQxaqyLpjyIjJpydA&usqp=CAU'},
    {'title': 'Item 4', 'image': 'https://w7.pngwing.com/pngs/768/277/png-transparent-digital-marketing-business-icon-electronic-information-map-electronics-service-happy-birthday-vector-images.png'},
    {'title': 'Item 5', 'image': 'https://w7.pngwing.com/pngs/855/25/png-transparent-digital-marketing-online-advertising-computer-icons-taekwondo-elements-service-logo-social-media-marketing.png'},
    {'title': 'Item 6', 'image': 'https://cdn-icons-png.flaticon.com/512/7376/7376481.png'},
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
          return Padding(
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
                        image: NetworkImage(dataList[index]['image']),
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
          );
        },
      ),
    );
  }
}