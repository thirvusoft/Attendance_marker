import 'package:attendancemarker/Page/lead.dart';
import 'package:attendancemarker/widgets/resuable_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_log/call_log.dart';

class Lead {
  final String name;
  final String number;
  final Duration duration;

  Lead({required this.name, required this.number, required this.duration});
}

class LeadManagerScreen extends StatefulWidget {
  @override
  _LeadManagerScreenState createState() => _LeadManagerScreenState();
}

class _LeadManagerScreenState extends State<LeadManagerScreen> {
  List<CallLogEntry> callLogs = [];
  List<CallLogEntry> filteredCallLogs = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.phone.request().isGranted) {
      _getCallLogs();
    } else {
      print('Permission denied');
    }
  }

  Future<void> _getCallLogs() async {
    Iterable<CallLogEntry> logs = await CallLog.get();
    List<CallLogEntry> attendedCalls =
        logs.where((log) => log.callType == CallType.incoming).toList();

    setState(() {
      callLogs = attendedCalls;
      filteredCallLogs = List.from(callLogs); // Initialize filtered list
    });
  }

  void _filterSearchResults(String query) {
    List<CallLogEntry> filteredList = callLogs
        .where((log) =>
            log.name?.toLowerCase().contains(query.toLowerCase()) == true ||
            log.formattedNumber?.contains(query) == true)
        .toList();

    setState(() {
      filteredCallLogs = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA5455),
        title: ListTile(
          title: Text(
            "Call Log",
            style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterSearchResults(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(color: Color(0xFFEA5455)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(
                    color: Color(0xFFEA5455),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCallLogs.length,
              itemBuilder: (context, index) {
                CallLogEntry log = filteredCallLogs[index];
                String phoneNumber = log.formattedNumber ?? 'Unknown';
                String name = log.name ?? 'Unknown';
                Duration duration = Duration(seconds: log.duration ?? 0);

                return _buildListItem(
                  name,
                  phoneNumber,
                  duration,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String name, String phoneNumber, Duration duration) {
    String formattedPhoneNumber =
        phoneNumber.startsWith('+91') ? phoneNumber.substring(3) : phoneNumber;
    formattedPhoneNumber = formattedPhoneNumber.replaceAll(' ', '');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          title: Text(
            '$name - $formattedPhoneNumber',
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Duration: ${_formatDuration(duration)}',
            style: const TextStyle(fontSize: 14.0),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeadPage(name, formattedPhoneNumber),
                ));
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
