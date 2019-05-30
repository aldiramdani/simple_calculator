import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Calculator App',
    home: SIForm(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  _SIFormState createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {

  var _formKey = GlobalKey<FormState>();

  var _currencies = ['Rupiah', 'Dollar', 'Pounds'];
  final _minimumPadding = 5.0;

  var _currentItemSelected = '';

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Simple Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalController,
                      validator: (String value){
                        if(value.isEmpty){
                          return 'Please Enter Principal Amount';
                        }
                      },
                      decoration: InputDecoration(
                        errorStyle:TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0
                        ) ,
                          labelText: 'Principal',
                          labelStyle: textStyle,
                          hintText: 'Enter Principal',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: roiController,
                      validator: (String value){
                        if(value.isEmpty){
                          return 'Please Enter Rate of Interest';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Rate of Interest',
                          labelStyle: textStyle,
                          hintText: 'In Percent',
                          errorStyle:TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: termController,
                        validator: (String value){
                          if(value.isEmpty){
                            return 'Please Enter Term';
                          }
                        },
                          decoration: InputDecoration(
                              labelText: 'Term',
                              labelStyle: textStyle,
                              hintText: 'Time in Years',
                              errorStyle:TextStyle(
                                  color: Colors.yellowAccent,
                                  fontSize: 15.0
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                                items: _currencies.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: _currentItemSelected,
                                onChanged: (String newValueSelected) {
                                  _onDropDownItemSelected(newValueSelected);
                                }))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                                child: Text(
                                  'Calculate',
                                  textScaleFactor: 1.5,
                                ),
                                color: Theme.of(context).accentColor,
                                textColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  setState(() {
                                    if(_formKey.currentState.validate()) {
                                      this.displayResult =
                                          _calculateTotalReturn();
                                    }
                                  });
                                })),
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text('Reset', textScaleFactor: 1.5),
                                onPressed: () {
                                  setState(() {
                                    _reset();
                                  });
                                })),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding),
                  child: Text(
                    this.displayResult,
                    style: textStyle,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10.0),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturn() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years,your investment will be worth $totalAmountPayable $_currentItemSelected';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}
