import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _dot = SizedBox(
    width: 30,
    height: 30,
    child: DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    ));

const _distanceKey = 'distance';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _distance = 0;
  double _dragStartDistance = 0;
  SharedPreferences? _sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _section(isOpposite: true),
            _section(),
          ],
        ),
      ),
    );
  }

  Expanded _section({bool isOpposite = false}) {
    return Expanded(
      child: GestureDetector(
        onHorizontalDragUpdate: (detail) {
          setState(() {
            _distance = (isOpposite ? -1 : 1) *
                (_dragStartDistance + (detail.primaryDelta ?? 0) / 1200)
                    .clamp(-1, 1);
          });
          _dragStartDistance = _distance;
          _sharedPreferences?.setDouble(_distanceKey, _distance);
        },
        child: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment((isOpposite ? -1 : 1) * _distance, 0),
            child: _dot,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _initSharedPreferences();
    super.initState();
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _distance = _sharedPreferences!.getDouble(_distanceKey) ?? 0;
      _dragStartDistance = _distance;
    });
  }
}
