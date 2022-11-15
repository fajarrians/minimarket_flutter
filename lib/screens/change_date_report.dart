import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimarket/screens/report.dart';
import 'package:minimarket/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeDateReportScreen extends StatefulWidget {
  const ChangeDateReportScreen({super.key});

  @override
  State<ChangeDateReportScreen> createState() => _ChangeDateReportScreenState();
}

class _ChangeDateReportScreenState extends State<ChangeDateReportScreen> {
  bool _isLoading = false;
  var startDate;
  var endDate;
  final _formKey = GlobalKey<FormState>();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ubah Tanggal',
          style: TextStyle(
            color: ThemeColors().textWhite,
          ),
        ),
        backgroundColor: ThemeColors().backgroundBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors().backgroundWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range_rounded), //icon of text field
                    labelText: "Tanggal Awal" //label text of field
                    ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    setState(() {
                      startDateController.text = formattedDate;
                      startDate = formattedDate;
                    });
                  }
                },
                validator: (startDateValue) {
                  if (startDateValue!.isEmpty) {
                    return "Tidak boleh Kosong";
                  }
                  startDate:
                  startDateValue;
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: endDateController,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range_rounded), //icon of text field
                    labelText: "Tanggal Akhir" //label text of field
                    ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    setState(() {
                      endDateController.text = formattedDate;
                      endDate = formattedDate;
                    });
                  }
                },
                validator: (endDateValue) {
                  if (endDateValue!.isEmpty) {
                    return "Tidak boleh Kosong";
                  }
                  startDate:
                  endDateValue;
                  return null;
                },
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveDate();
                    }
                  },
                  child: _isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(
                            color: ThemeColors().textWhite,
                          ),
                          height: 18,
                          width: 18,
                        )
                      : Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors().backgroundBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDate() async {
    setState(() {
      _isLoading = true;
    });

    final localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('start_date', startDate.toString());
    await localStorage.setString('end_date', endDate.toString());

    Future.delayed(
        Duration(seconds: 2),
        () => [
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportScreen(),
                ),
              ),
              _showMsg('Tanggal berhasil disimpan')
            ]);
  }
}
