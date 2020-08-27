  import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, 
  //   DeviceOrientation.portraitDown
  //   ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
       // errorColor: Colors.red,
       // fontFamily: 'Quicksand',
       textTheme: ThemeData.light().textTheme.copyWith(
         title: TextStyle(
           //fontFamily: 'OpenSans',
           fontWeight: FontWeight.bold,
           fontSize: 18,
         ),
         button: TextStyle(color: Colors.white)
       ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1', 
    //   title: 'New Shoes', 
    //   amount: 69.99, 
    //   date: DateTime.now(), 
    //   ),
    //   Transaction(
    //   id: 't2', 
    //   title: 'Weekly Groceries', 
    //   amount: 16.53, 
    //   date: DateTime.now(), 
    //   ),
  ];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state ) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions{
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
      ),
    );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime choseDate) {
    final newTx = Transaction(
      title: txTitle, 
      amount: txAmount, 
      date: choseDate, 
      id: DateTime.now().toString()
    );
  
  setState(() {
    _userTransaction.add(newTx);  
  });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, 
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
          );
    },);
  }

  void _delectTransaction(String id) {
    setState(() {
      _userTransaction.retainWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandscapedContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch(value: _showChart, 
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },),
              ],),_showChart 
              ? Container(
                height: (MediaQuery.of(context).size.height 
                - appBar.preferredSize.height
                - mediaQuery.padding.top) * 0.7 ,
                child: Chart(_recentTransactions),)
                :
             txListWidget];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget ){
    return [Container(
                height: (mediaQuery.size.height 
                - appBar.preferredSize.height
                - mediaQuery.padding.top) * 0.3,
                child: Chart(_recentTransactions),), txListWidget];
  }


  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape; 
    final appBar = AppBar(
        title: Text('Personal Expenses'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), 
          onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      );
      final txListWidget = Container(
               height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7 ,
               child: TransactionList(_userTransaction, _delectTransaction));
               
    return Scaffold(
      appBar: appBar,
      body:  SingleChildScrollView(
              child: Column(
        //  mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandscape) ..._buildLandscapedContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape) ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}