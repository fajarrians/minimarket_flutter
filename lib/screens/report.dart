import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:minimarket/layouts/bottomNav.dart';
// import 'package:minimarket/theme/color.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   bool _isLoading = false;
//   var firstDate;
//   var endDate;
//   TextEditingController firstDateController = TextEditingController();
//   TextEditingController endDateController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 5,
//                   child: TextFormField(
//                     controller: firstDateController,
//                     decoration: InputDecoration(
//                         icon: Icon(Icons.calendar_today), //icon of text field
//                         labelText: "Tanggal Awal" //label text of field
//                         ),
//                     onTap: () async {
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );

//                       if (pickedDate != null) {
//                         String formattedDate =
//                             DateFormat('yyyy-MM-dd').format(pickedDate);

//                         setState(() {
//                           firstDateController.text = formattedDate;
//                         });
//                       }
//                     },
//                     validator: (firstDateValue) {
//                       if (firstDateValue!.isEmpty) {
//                         return "Tidak boleh Kosong";
//                       }
//                       firstDate:
//                       firstDateValue;
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 50),
//                 Expanded(
//                   flex: 5,
//                   child: TextFormField(
//                     controller: endDateController,
//                     decoration: InputDecoration(
//                         icon: Icon(Icons.calendar_today), //icon of text field
//                         labelText: "Tanggal Akhir" //label text of field
//                         ),
//                     onTap: () async {
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );

//                       if (pickedDate != null) {
//                         String formattedDate =
//                             DateFormat('yyyy-MM-dd').format(pickedDate);

//                         setState(() {
//                           endDateController.text = formattedDate;
//                         });
//                       }
//                     },
//                     validator: (endDateValue) {
//                       if (endDateValue!.isEmpty) {
//                         return "Tidak boleh Kosong";
//                       }
//                       firstDate:
//                       endDateValue;
//                       return null;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             SizedBox(
//               height: 40,
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                   }
//                 },
//                 child: _isLoading
//                     ? SizedBox(
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                         height: 18,
//                         width: 18,
//                       )
//                     : Text('Cari'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ThemeColors().blue4,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
