import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import './video_player.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialize = Firebase.initializeApp();
    return FutureBuilder(
        future: _initialize,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'Assignment',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: appSnapshot.connectionState!=ConnectionState.done?Container(): const MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: MediaQuery.of(context).padding,
        constraints: const BoxConstraints.expand(),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Products').snapshots(),
            builder:(_,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }else{
              return  PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                controller: pageController,
                itemBuilder: (_, page) {
                List rev = snapshot.data!.docs.toList();
                 return Stack(children: [
                   Container(
                     constraints: const BoxConstraints.expand(),
                     child: VideoPlayercustom(page,rev)),
                 Align(
                   alignment: Alignment.bottomCenter,
                   child: OutlinedButton(
                     style: OutlinedButton.styleFrom(
                       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                       primary:  Colors.white,
                       backgroundColor: Colors.black.withOpacity(0.2),
                     ),
                     onPressed: () async {
                                          final url = '${rev[page]["Urlvideo"]}';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            // ignore: avoid_print
                                            print("error");
                                          }
                                        },
                    child: const Text("View Product")),
                 )
                 ]);
                });
              }
            }
          ),
        ),
    );
  }
}
