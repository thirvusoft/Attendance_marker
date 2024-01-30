// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ContactListScreen extends StatefulWidget {
//   @override
//   _ContactListScreenState createState() => _ContactListScreenState();
// }

// class _ContactListScreenState extends State<ContactListScreen> {
//   List<Contact> _contacts = [];
//   List<Contact> _selectedContacts = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadContacts();
//   }

//   Future<void> _loadContacts() async {
//     List<Contact> contacts = await getContactList();
//     setState(() {
//       _contacts = contacts;
//     });
//   }

//   Future<List<Contact>> getContactList() async {
//     Iterable<Contact> contacts = await ContactsService.getContacts();
//     List<Contact> contactList = contacts.toList();
//     return contactList;
//   }

//   Future<void> _saveSelectedContacts(List<Contact> selectedContacts) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> selectedContactNames =
//         selectedContacts.map((contact) => contact.displayName ?? '').toList();
//     List<String> selectedContactPhoneNumbers = selectedContacts
//         .map((contact) =>
//             contact.phones!.isNotEmpty ? contact.phones!.first.value ?? '' : '')
//         .toList();
//     prefs.setStringList('selectedContactNames', selectedContactNames);
//     prefs.setStringList(
//         'selectedContactPhoneNumbers', selectedContactPhoneNumbers);
//   }

//   void _toggleContactSelection(Contact contact) {
//     setState(() {
//       if (_selectedContacts.contains(contact)) {
//         _selectedContacts.remove(contact);
//       } else {
//         _selectedContacts.add(contact);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contact List'),
//       ),
//       body: _buildContactList(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // Save selected contacts before navigating to the next page
//           await _saveSelectedContacts(_selectedContacts);

//           // Navigate to the next page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NextPage(),
//             ),
//           );
//         },
//         child: Icon(Icons.arrow_forward),
//       ),
//     );
//   }

//   Widget _buildContactList() {
//     if (_contacts.isEmpty) {
//       return Center(
//         child: Text('No contacts available.'),
//       );
//     } else {
//       return ListView.builder(
//         itemCount: _contacts.length,
//         itemBuilder: (context, index) {
//           Contact contact = _contacts[index];
//           bool isSelected = _selectedContacts.contains(contact);

//           return ListTile(
//             title: Text(contact.displayName ?? ''),
//             subtitle: Text(contact.phones!.isNotEmpty
//                 ? contact.phones!.first.value ?? ''
//                 : 'No phone number'),
//             onTap: () {
//               _toggleContactSelection(contact);
//             },
//             trailing: Checkbox(
//               value: isSelected,
//               onChanged: (value) {
//                 _toggleContactSelection(contact);
//               },
//             ),
//           );
//         },
//       );
//     }
//   }
// }

// class NextPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Unselected Contacts'),
//       ),
//       body: _buildUnselectedContacts(),
//     );
//   }

//   Future<Map<String, List<String>>> _getUnselectedContacts() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> selectedContactNames =
//         prefs.getStringList('selectedContactNames') ?? [];
//     List<String> selectedContactPhoneNumbers =
//         prefs.getStringList('selectedContactPhoneNumbers') ?? [];

//     List<Contact> allContacts = await getContactList();
//     List<Contact> selectedContacts = [];

//     // Find the selected contacts
//     for (int i = 0; i < allContacts.length; i++) {
//       if (selectedContactNames.contains(allContacts[i].displayName) &&
//           selectedContactPhoneNumbers.contains(allContacts[i].phones!.isNotEmpty
//               ? allContacts[i].phones!.first.value
//               : '')) {
//         selectedContacts.add(allContacts[i]);
//       }
//     }

//     // Find the unselected contacts
//     List<Contact> unselectedContacts = List.from(allContacts)
//       ..removeWhere((contact) =>
//           selectedContactNames.contains(contact.displayName) &&
//           selectedContactPhoneNumbers.contains(
//               contact.phones!.isNotEmpty ? contact.phones!.first.value : ''));

//     Map<String, List<String>> unselectedContactsMap = {
//       'unselectedContactNames': unselectedContacts
//           .map((contact) => contact.displayName ?? '')
//           .toList(),
//       'unselectedContactPhoneNumbers': unselectedContacts
//           .map((contact) => contact.phones!.isNotEmpty
//               ? contact.phones!.first.value ?? ''
//               : '')
//           .toList(),
//     };

//     return unselectedContactsMap;
//   }

//   Widget _buildUnselectedContacts() {
//     return FutureBuilder<Map<String, List<String>>>(
//       future: _getUnselectedContacts(),
//       builder: (context, AsyncSnapshot<Map<String, List<String>>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, List<String>>? data =
//               snapshot.data as Map<String, List<String>>?;

//           List<String>? unselectedContactNames =
//               data?['unselectedContactNames'];
//           List<String>? unselectedContactPhoneNumbers =
//               data?['unselectedContactPhoneNumbers'];

//           if (unselectedContactNames != null &&
//               unselectedContactPhoneNumbers != null) {
//             return ListView.builder(
//               itemCount: unselectedContactNames.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(unselectedContactNames[index]),
//                   subtitle: Text(unselectedContactPhoneNumbers[index]),
//                 );
//               },
//             );
//           } else {
//             return const Center(
//               child: Text('No unselected contacts found.'),
//             );
//           }
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }

//   Future<List<Contact>> getContactList() async {
//     Iterable<Contact> contacts = await ContactsService.getContacts();
//     List<Contact> contactList = contacts.toList();
//     return contactList;
//   }
// }
