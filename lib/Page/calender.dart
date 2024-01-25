import 'dart:convert';

import 'package:attendancemarker/Page/crmleadpage.dart';
import 'package:attendancemarker/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:html/parser.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  List<Meeting> meetings = [];

  @override
  void initState() {
    super.initState();
    fetchMeetingData();
  }

  void fetchMeetingData() async {
    final user = await controller.getUser();

    final response = await apiService
        .get('/api/method/thirvu__attendance.utils.api.api.lead_todo', {
      "user": user[0]['email'],
    });

    final jsonResponse = json.decode(response.body);

    if (jsonResponse['message'] != null) {
      final List<dynamic> meetingList = jsonResponse['message'];
      meetings = meetingList.map((data) {
        final String description = data.containsKey('description')
            ? parse(data['description']).documentElement!.text
            : data['description'];

        return Meeting(
          description,
          DateTime.parse(data['custom_start_date']),
          DateTime.parse(data['date']),
          data['reference_name'],
          Colors.green,
          false,
        );
      }).toList();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA5455),
        title: ListTile(
          title: Text(
            "Calendar",
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
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16.0),
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(meetings),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true,
          ),
          todayHighlightColor: Colors.red,
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue, width: 2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          onLongPress: (CalendarLongPressDetails details) {
            if (details.appointments != null &&
                details.appointments!.isNotEmpty) {
              Meeting tappedMeeting = details.appointments![0];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CrmLead(tappedMeeting.reference),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.reference, this.background,
      this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  String reference; // Add this line to include the reference field
  Color background;
  bool isAllDay;
}
