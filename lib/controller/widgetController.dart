import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pethotel/controller/styleController.dart';

TextStyle textStyle(
    {Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    TextDecoration? decoration}) {
  color ??= Colors.black;
  fontSize ??= 13;
  fontWeight ??= FontWeight.normal;
  return GoogleFonts.openSans(
      color: color,
      fontWeight: fontWeight,
      height: height,
      fontSize: fontSize,
      decoration: decoration ?? TextDecoration.none);
}

Widget InputTextWidget(
    var hintText, TextEditingController textEditingController, {bool isEnable = true, IconData? iconData ,TextInputType textInputType = TextInputType.text}) {
  return Padding(
    padding:  EdgeInsets.only(right: 25, left: 25),
    child: Container(
      // decoration: boxDecoration(radius: 40, showShadow: true, bgColor: t9_white),
      child: TextFormField(
        enabled: isEnable,
        // style: TextStyle(fontSize: textSizeMedium, ),
        style: textStyle(fontSize: 15, ),
        controller: textEditingController,
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor:    MyStyle.grey200,
          border: OutlineInputBorder(),
          prefixIcon: iconData != null ? Icon(iconData) : null,
          labelStyle:textStyle(),
          labelText: hintText,
          contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
          filled: true,
          // fillColor: Theme_Information.Icon_Back_Color,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  const BorderSide(color: Colors.white, width: 0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  const BorderSide(color: Colors.white, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  const BorderSide(color: Colors.white, width: 0.0),
          ),
        ),
      ),
    ),
  );
}


Widget InputDropdownWidget(
    String hintText,
    TextEditingController textEditingController,
    List<String> items, {
      bool isEnable = true,
      IconData? iconData,
    }) {
  String? selectedValue;

  return Padding(
    padding: EdgeInsets.only(right: 25, left: 25),
    child: Container(
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: isEnable
            ? (newValue) {
          selectedValue = newValue;
          textEditingController.text = newValue ?? '';
        }
            : null,
        decoration: InputDecoration(
          fillColor: MyStyle.grey200,
          border: OutlineInputBorder(),
          prefixIcon: iconData != null ? Icon(iconData) : null,
          labelStyle: textStyle(),
          labelText: hintText,
          contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
          filled: true,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value , style: textStyle(),),
          );
        }).toList(),
      ),
    ),
  );
}

class MyDatePicker{
  Future<DateTime?> selectDate(BuildContext context , selectedDate ,) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ,
      firstDate: DateTime(1800),
      lastDate: DateTime(2101),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: CustomDatePickerTheme().datePickerTheme,
          child: child!,
        );
      },
    );
    if (picked != null ) {
      return picked;
    }
    return null;
  }
}

class CustomDatePickerTheme {
  ThemeData datePickerTheme = ThemeData.light().copyWith(
    dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)))),
    colorScheme: ColorScheme.light(
      primary: MyStyle.mainColor!.withOpacity(0.5), // header background color
      // onPrimary: , // header text color
      onSurface: Colors.black, // body text color
    ),
  );
}

Widget customCard(String description, String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0 , left: 8 , right: 8),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10), // Add margin between cards
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0), // Match the border radius
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w500)),
                    Text(description, style: TextStyle(fontSize: 16)),
                  ],
                ),
                // Text style
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void showLoadingDialog(BuildContext context) {
  // Show the dialog
  ///   Navigator.pop(context);
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Loading..."),
          ],
        ),
      );
    },
  );
}



class AgeDropdownWidget extends StatefulWidget {
  final TextEditingController textEditingController;

  AgeDropdownWidget({required this.textEditingController});

  @override
  _AgeDropdownWidgetState createState() => _AgeDropdownWidgetState();
}

class _AgeDropdownWidgetState extends State<AgeDropdownWidget> {
  int selectedAge = 1; // Default age
  String selectedUnit = 'months'; // Default unit

  final List<String> units = ['months', 'years'];
  final List<int> ages = List.generate(24, (index) => index + 1); // 1 to 24

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              value: selectedAge,
              onChanged: (int? newValue) {
                setState(() {
                  selectedAge = newValue!;
                  widget.textEditingController.text = '$selectedAge $selectedUnit';
                });
              },
              decoration: InputDecoration(
                fillColor: MyStyle.grey200,
                border: OutlineInputBorder(),
                labelStyle: textStyle(),
                // labelText: hintText,
                contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
              ),
              items: ages.map<DropdownMenuItem<int>>((int age) {
                return DropdownMenuItem<int>(
                  value: age,
                  child: Text(age.toString(), style: textStyle()),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 10), // Space between dropdowns
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedUnit,
              onChanged: (String? newUnit) {
                setState(() {
                  selectedUnit = newUnit!;
                  widget.textEditingController.text = '$selectedAge $selectedUnit';
                });
              },
              decoration: InputDecoration(
                fillColor: MyStyle.grey200,
                border: OutlineInputBorder(),
                // prefixIcon: iconData != null ? Icon(iconData) : null,
                labelStyle: textStyle(),
                // labelText: hintText,
                contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
              ),
              items: units.map<DropdownMenuItem<String>>((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit, style: textStyle()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class WeightDropdownWidget extends StatefulWidget {
  final TextEditingController weightController;

  WeightDropdownWidget({required this.weightController});

  @override
  _WeightDropdownWidgetState createState() => _WeightDropdownWidgetState();
}

class _WeightDropdownWidgetState extends State<WeightDropdownWidget> {
  double selectedWeight = 1.0; // Default weight
  String selectedUnit = 'kg'; // Default weight unit

  final List<String> weightUnits = ['kg', 'lbs'];
  final List<double> weights = List.generate(100, (index) => (index + 1) * 0.5); // 0.5 to 50 kg

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonFormField<double>(
              value: selectedWeight,
              onChanged: (double? newValue) {
                setState(() {
                  selectedWeight = newValue!;
                  widget.weightController.text = '$selectedWeight $selectedUnit';
                });
              },
              decoration: InputDecoration(
                fillColor: MyStyle.grey200,
                border: OutlineInputBorder(),
                // prefixIcon: iconData != null ? Icon(iconData) : null,
                labelStyle: textStyle(),
                // labelText: hintText,
                contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
              ),
              items: weights.map<DropdownMenuItem<double>>((double weight) {
                return DropdownMenuItem<double>(
                  value: weight,
                  child: Text(weight.toStringAsFixed(1), style: textStyle()),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 10), // Space between dropdowns
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedUnit,
              onChanged: (String? newUnit) {
                setState(() {
                  selectedUnit = newUnit!;
                  widget.weightController.text = '$selectedWeight $selectedUnit';
                });
              },
              decoration: InputDecoration(
                fillColor: MyStyle.grey200,
                border: OutlineInputBorder(),
                // prefixIcon: iconData != null ? Icon(iconData) : null,
                labelStyle: textStyle(),
                // labelText: hintText,
                contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
              ),
              items: weightUnits.map<DropdownMenuItem<String>>((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit, style: textStyle()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class HeightDropdownWidget extends StatefulWidget {
  final TextEditingController heightController;

  HeightDropdownWidget({required this.heightController});

  @override
  _HeightDropdownWidgetState createState() => _HeightDropdownWidgetState();
}

class _HeightDropdownWidgetState extends State<HeightDropdownWidget> {
  double selectedHeight = 30.0; // Default height
  String selectedUnit = 'cm'; // Default height unit

  final List<String> heightUnits = ['cm', 'inches'];
  final List<double> heights = List.generate(200, (index) => index + 1); // 1 to 200 cm

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonFormField<double>(
              value: selectedHeight,
              onChanged: (double? newValue) {
                setState(() {
                  selectedHeight = newValue!;
                  widget.heightController.text = '$selectedHeight $selectedUnit';
                });
              },
              decoration: InputDecoration(
                fillColor: MyStyle.grey200,
                border: OutlineInputBorder(),
                // prefixIcon: iconData != null ? Icon(iconData) : null,
                labelStyle: textStyle(),
                // labelText: hintText,
                contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
              ),
              items: heights.map<DropdownMenuItem<double>>((double height) {
                return DropdownMenuItem<double>(
                  value: height,
                  child: Text(height.toString(), style: textStyle()),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 10), // Space between dropdowns
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedUnit,
              onChanged: (String? newUnit) {
                setState(() {
                  selectedUnit = newUnit!;
                  widget.heightController.text = '$selectedHeight $selectedUnit';
                });
              },
              decoration: InputDecoration(
                fillColor: MyStyle.grey200,
                border: OutlineInputBorder(),
                // prefixIcon: iconData != null ? Icon(iconData) : null,
                labelStyle: textStyle(),
                // labelText: hintText,
                contentPadding: EdgeInsets.fromLTRB(24, 18, 24, 18),
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
              ),
              items: heightUnits.map<DropdownMenuItem<String>>((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit, style: textStyle()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


Widget buildRow({
  required String title,
  required IconData icon,
  required int index,
  required int screenIndex,
  required Function() onTap
}) {
  return InkWell(
    onTap: () async {
      onTap();
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon,
            color: screenIndex == index ? MyStyle.white : MyStyle.black,),
          SizedBox(width: 5,),
          Text(title, style: textStyle(
            color: screenIndex == index ? MyStyle.white : MyStyle.black,),)
        ],
      ),
    ),
  );
}

