import 'package:assessment_2/Provider/authentication.dart';
import 'package:assessment_2/holding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Welcome Home...",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 360.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Out",
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                  onPressed: () async {
                    await Provider.of<Authentication>(context, listen: false)
                        .signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HoldingPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.login)),
            ],
          )
        ],
      ),
    );
  }
}
