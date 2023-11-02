import 'package:attendancemarker/widgets/resuable_appbar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Vignesh M',
        subtitle: "Sales Executive",
        actions: [
          Container(
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 3.0, style: BorderStyle.solid),
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("https://shorturl.at/psJU4")),
            ),
          ),
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,

              width:
                  MediaQuery.of(context).size.width, // Full width minus padding
              height: 150,
              child: Container(
                color: Color(0xFFEA5455),
                child: Text(
                  'Green',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 35,
              width: 300,
              height: 250,
              child: Container(
                width: 300,
                height: 250,
                color: Colors.black,
                child: Text(
                  'Red',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
