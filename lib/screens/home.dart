import 'package:flutter/material.dart';
import 'package:minimarket/layouts/bottomNav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('ajshl'),
      bottomNavigationBar: BottomNav(),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:minimarket/network/api.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<SalesDetails> sales = [];

//   Future<String> getDataSales() async {
//     var response = await Network().getData('/chart-monthly-sales-transaction');
//     return response.body;
//   }

//   Future loadSalesData() async {
//     final String jsonString = await getDataSales();
//     final dynamic jsonResponse = json.decode(jsonString);
//     for (Map<String, dynamic> i in jsonResponse) {
//       sales.add(SalesDetails.fromJson(i));
//     }
//   }

  // List<String> month = ['Apr', 'May', 'Jun'];
  // List<int> salesCount = [150, 200, 300];

  // void loadSalesData() {
  //   for (int i = 0; i < month.length; i++) {
  //     sales.add(SalesDetails(month[i], salesCount[i]));
  //   }
  // }

//   @override
//   void initState() {
//     loadSalesData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: EdgeInsets.all(20),
//           child: FutureBuilder(
//             future: getDataSales(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return (SfCartesianChart(
//                   primaryXAxis: CategoryAxis(),
//                   series: <ChartSeries>[
//                     LineSeries<SalesDetails, String>(
//                       dataSource: sales,
//                       xValueMapper: (SalesDetails details, _) => details.month,
//                       yValueMapper: (SalesDetails details, _) =>
//                           details.salesCount,
//                     )
//                   ],
//                 ));
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SalesDetails {
//   SalesDetails(this.month, this.salesCount);
//   final String month;
//   final int salesCount;

//   factory SalesDetails.fromJson(Map<String, dynamic> parsedJson) {
//     return SalesDetails(
//         parsedJson['month'].toString(), parsedJson['salesCount']);
//   }
// }





// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:minimarket/network/api.dart';
// import 'package:minimarket/screens/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String name = "";
//   var user_id;
//   var company_id;

//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   _loadUserData() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var user = jsonDecode(localStorage.getString('data')!);

//     if (user != null) {
//       setState(() {
//         name = user['name'];
//         user_id = user['user_id'];
//         company_id = user['company_id'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff151515),
//       appBar: AppBar(
//         title: Text('Home'),
//         backgroundColor: Color(0xff151515),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.power_settings_new),
//             onPressed: () {
//               logout();
//             },
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.all(15),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     'Hello, ',
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                   Text(
//                     '${name}',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void logout() async {
//     var data = {'user_id': user_id, 'company_id': company_id};
//     var res = await Network().authData(data, '/logout');
//     var body = json.decode(res.body);
//     if (body['message'] != null) {
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.remove('data');
//       localStorage.remove('token');
//       Navigator.pushReplacement(
//           this.context, MaterialPageRoute(builder: (context) => LoginScreen()));
//     }
//   }
// }
