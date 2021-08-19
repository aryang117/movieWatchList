import 'package:flutter/material.dart';

// 3rd Party Packages
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// other screens
import '../HomeScreen/HomeScreen.dart';

// All this widget does it initialize hive,
// if there's an error then the error
// if the hive box is loading then a circular Progress Indicator is displayed
// if the box is loaded successfully, then the home screen is displayed
class InitializeHive extends StatefulWidget {
  InitializeHive({Key? key, required this.isUserSignedIn}) : super(key: key);

  final bool isUserSignedIn;
  @override
  _InitializeHiveState createState() => _InitializeHiveState();
}

class _InitializeHiveState extends State<InitializeHive> {
  // loads/creates the box
  Future<void> loadHiveStuff() async {
    Hive.openBox('movieDB');
  }

  // we load/create the box as soon as this widget init
  @override
  void initState() {
    super.initState();
    loadHiveStuff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Hive.openBox('moviedb'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Container(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(snapshot.error.toString()));
              else
                return HomeScreen(isUserLoggedIn: widget.isUserSignedIn);
            } else
              return CircularProgressIndicator();
          }),
    );
  }

  // we close the box when we don't need it
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
