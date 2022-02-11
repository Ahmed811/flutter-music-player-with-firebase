import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamic_ringtoon/controller/controller.dart';
import 'package:islamic_ringtoon/pages/play_song.dart';
import 'package:provider/provider.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:adcolony_flutter/banner.dart';

import '../constant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    AdColony.init(AdColonyOptions(ADCOLONYID, "0", zones));
    super.initState();
  }

  listener(AdColonyAdListener? event, int? reward) async {
    print(event);
    if (event == AdColonyAdListener.onRequestFilled) {
      if (await AdColony.isLoaded()) {
        AdColony.show();
      }
    }
    if (event == AdColonyAdListener.onClosed) {
      print('ADCOLONY: closed');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<Controller>(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(
          "قائمة الاغاني والاناشيد الاسلامية",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                  flex: 10,
                  child: StreamBuilder<QuerySnapshot>(
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "هناك خطأ بالاتصال،تأكد من اتصالك بالانترنت"),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          var title = snapshot.data!.docs[index]['title'];
                          var url = snapshot.data!.docs[index]['url'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2),
                            child: InkWell(
                              onTap: () async {
                                await AdColony.request(zones[0], listener);
                                controller.loadSong(url);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaySong(
                                              url: url,
                                              title: title,
                                            )));
                              },

                              // {

                              // },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/bgtile.jpg"),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: EdgeInsets.only(right: 20),
                                      alignment: Alignment.centerRight,
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .1,
                                      child: Text(
                                        title,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ))),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
                    },
                    stream: FirebaseFirestore.instance
                        .collection('islamic_ringtoon')
                        .snapshots(),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: BannerView(listener, BannerSizes.banner, zones[1]),
                  ))
            ],
          )),
    );
  }
}
