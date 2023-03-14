import 'package:flutter/material.dart';

abstract class OANavView extends StatefulWidget {

  const OANavView({ 
    Key? key,
    required this.notifier,
  }): super(key: key);

  final ChangeNotifier notifier;
}

abstract class OANavViewState<T> extends State<OANavView> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void viewWillAppear() {
    print("VIEW WILL APPEAR");
  }

  void viewDidAppear() {
    print("VIEW DID APPEAR");
  }

  void viewWillDisappear() {
    print("VIEW WILL DISAPPEAR");
  }

  void viewDidDisappear() {
    print("VIEW DID DISAPPEAR");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}