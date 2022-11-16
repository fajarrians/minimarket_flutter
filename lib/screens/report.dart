import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimarket/currency_format.dart';
import 'package:minimarket/network/api.dart';
import 'package:minimarket/screens/change_date_report.dart';
import 'package:minimarket/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var company_id;
  String? start_date = DateTime.now().toString();
  String? end_date = DateTime.now().toString();
  int expenditure_total = 0;
  int discount_total = 0;
  int sales_subtotal = 0;
  int sales_cash_subtotal = 0;
  int sales_gopay_subtotal = 0;
  int sales_ovo_subtotal = 0;
  int sales_shopeepay_subtotal = 0;
  int profit = 0;
  var salesInvoiceItem = [];
  var data_expenditure = [];

  @override
  void initState() {
    super.initState();
    _loadLocalStorage();
  }

  _loadLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('data')!);
    setState(() {
      company_id = user['company_id'];
      start_date = localStorage.getString('start_date');
      if (start_date == null) {
        DateTime date_now = DateTime.now();
        start_date = date_now.toString();
      }

      end_date = localStorage.getString('end_date');
      if (end_date == null) {
        DateTime date_now = DateTime.now();
        end_date = date_now.toString();
      }
    });
    _loadDataFinancialStatements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Laporan Keuangan',
          style: TextStyle(
            color: ThemeColors().textWhite,
          ),
        ),
        backgroundColor: ThemeColors().backgroundBlue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeDateReportScreen(),
                ),
              );
            },
            icon: Icon(Icons.date_range_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                DateFormat('d MMMM y').format(DateTime.parse(start_date!)) +
                    " s/d " +
                    DateFormat('d MMMM y').format(DateTime.parse(end_date!)),
                textAlign: TextAlign.center,
                style: TextStyle(color: ThemeColors().textBlack),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeColors().backgroundBlue,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                leading: Text('Penjualan'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(sales_subtotal, 0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: ListTile(
                leading: Text('Tunai'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(sales_cash_subtotal, 0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: ListTile(
                leading: Text('Gopay'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(sales_gopay_subtotal, 0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: ListTile(
                leading: Text('Ovo'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(sales_ovo_subtotal, 0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: ListTile(
                leading: Text('ShopeePay'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(sales_shopeepay_subtotal, 0),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeColors().backgroundBlue,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                leading: Text('Diskon'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(discount_total, 0),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeColors().backgroundBlue,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                leading: Text('Pengeluaran'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(expenditure_total, 0),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ThemeColors().backgroundBlue,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                leading: Text('Laba'),
                trailing: Text(
                  CurrencyFormat.convertToIdr(profit, 0),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Menu Laku',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: salesInvoiceItem.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCardSales(context, index);
                // return const Text("tes");
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pengeluaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            ListView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data_expenditure.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCardExpenditure(context, index);
                // return const Text("tes");
              },
            ),
          ],
        ),
      ),
    );
  }

  void _loadDataFinancialStatements() async {
    var data = {
      'company_id': company_id,
      'start_date': start_date,
      'end_date': end_date,
    };
    var res = await Network().postData(data, '/post-data-financial-statements');
    var body = jsonDecode(res.body);
    setState(() {
      sales_cash_subtotal = body['sales_cash_subtotal'];
      sales_gopay_subtotal = body['sales_gopay_subtotal'];
      sales_ovo_subtotal = body['sales_ovo_subtotal'];
      sales_shopeepay_subtotal = body['sales_shopeepay_subtotal'];
      discount_total = body['discount_total'];
      expenditure_total = body['expenditure_total'];
      sales_subtotal = body['sales_subtotal'];
      profit = body['profit'];
      salesInvoiceItem = body['data_sales_item'];
      data_expenditure = body['data_expenditure'];
    });
    print(body);
  }

  Widget makeCardExpenditure(BuildContext context, int index) {
    return Container(
      child: ListTile(
        leading: Text(data_expenditure[index]['expenditure_remark'].toString()),
        trailing: Text(
          CurrencyFormat.convertToIdr(
              data_expenditure[index]['expenditure_amount'], 0),
        ),
      ),
    );
  }

  Widget makeCardSales(BuildContext context, int index) {
    return Container(
      child: ListTile(
        leading: Text(salesInvoiceItem[index]['item_name'] +
            ' x ' +
            salesInvoiceItem[index]['subtotal_item'].toString()),
        trailing: Text(
          CurrencyFormat.convertToIdr(
              salesInvoiceItem[index]['subtotal_amount'], 0),
        ),
      ),
    );
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
