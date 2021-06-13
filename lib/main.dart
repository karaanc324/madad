import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/login.dart';
import 'package:madad/service/firebase_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(title);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(String title) {
    this.title = title;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseService().registerOnFirebase();
    Provider.of<FirebaseService>(context, listen: false).incrementCounter();
    // FirebaseService().getMessage();
  }

  var title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage().getLoginPage(context),
    );
  }
}
