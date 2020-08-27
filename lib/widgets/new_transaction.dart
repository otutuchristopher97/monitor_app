import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx) {
    print('Constructor NewTransaction Widget');
  }

  @override
  _NewTransactionState createState() {
    print('createstate NewTransaction Widget');
     return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState() {
    print('Constructor NewTransaction State');
  }

  @override
  void initState() {
    print('initState()');
    super.initState();
  }
  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
   print('dispose()');
    super.dispose();
  }

  void _submitData() {
    if(_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return ;
    }
    widget.addTx(
      enteredTitle, 
      enteredAmount,
      _selectedDate,
      );

      Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2018), 
      lastDate: DateTime.now(),
      ).then((pickedData) {
        if(pickedData == null) {
          return ;
        }
        setState(() {
          _selectedDate = pickedData;
        });
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
              margin: EdgeInsets.fromLTRB(10, 10, 20, 10), 
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10, 
                  left: 10, 
                  right: 10, 
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  cursorColor: Colors.amber,
                  controller: _titleController,
                  onSubmitted:(_) => _submitData,
                  // onChanged: (value) {
                  //   titleInput = value;
                  // },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  cursorColor: Colors.amber,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted:(_) => _submitData(),
                  //onChanged: (value) => amountInput = value,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(_selectedDate == null ? 'No Data Choosen!' : 'picked Date: ${DateFormat.yMd().format(_selectedDate)}')),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold),), 
                          onPressed: _presentDatePicker,
                        ),
                      ],
                    ),
                  ),
                RaisedButton(
                  onPressed: ()=> _submitData(), 
                  child:Text('Add Transaction'),
                  textColor: Theme.of(context).textTheme.button.color,
                  color: Theme.of(context).primaryColor,
                  ),
            ],
              ),
            ),),
    );
  }
}