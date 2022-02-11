import 'package:flutter/material.dart';
import '../constant.dart';
import './home.dart';
import 'package:url_launcher/url_launcher.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/splash.png",
            ),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.grey.withOpacity(.3),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 20,
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home())),
                  child: Text(
                    "قائمة الاغاني والاناشيد",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.grey.withOpacity(.3),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 20,
                  onPressed: () async => await launchURL(),
                  child: Text(
                    "قيم التطبيق",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ////////////////////rate app
  static launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=$packageName';
    // const url = 'https://appgallery.huawei.com/#/app/C103738797';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
