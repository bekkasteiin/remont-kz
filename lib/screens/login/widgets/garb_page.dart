import 'package:flutter/material.dart';

class GarbageWidget extends StatelessWidget {
  const GarbageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Center(
        child: Image.asset('assets/images/garbage.gif',
            height: MediaQuery.of(context).size.height * 0.2),
      ),
    );
  }
}