// // import 'dart:io';
// // import 'dart:typed_data';

// // import 'package:barcode_widget/barcode_widget.dart';
// // import 'package:chat/widgets.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'dart:ui' as ui;
// // import 'package:flutter_share/flutter_share.dart';
// // import 'package:flutter/rendering.dart';
// // import 'package:path_provider/path_provider.dart';

// // class Market extends StatefulWidget {
// //   const Market({super.key});

// //   @override
// //   State<Market> createState() => _MarketState();
// // }

// // class _MarketState extends State<Market> {
// //   // sharewidgetasimage() async {
// //   //   try {
// //   //     RenderRepaintBoundary? boundry =
// //   //         barcodekey.currentContext.findRenderObject();
// //   //     ui.Image? image = boundery.toimage(pixelratio: 5);
// //   //     ByteData byteData =
// //   //         await image.toByteData(format: ui.ImageByteFormat.png);
// //   //     var pngbytes = byteData.buffer.asUint8List();
// //   //     String dir = (await getApplicationDocumentsDirectory()).path;
// //   //     File file = File(
// //   //         '$dir/' + DateTime.now().millisecondsSinceEpoch.toString() + '.png');
// //   //     await file.writeAsBytes(pngbytes);
// //   //     FlutterShare.shareFile(title: "myfile", filePath: file.path);
// //   //   } catch (e) {}
// //   // }
// //   Future<void> shareWidgetAsImage() async {
// //     try {
// //       RenderRepaintBoundary? boundary = barcodekey.currentContext
// //           ?.findRenderObject() as RenderRepaintBoundary?;
// //       if (boundary == null) {
// //         print('Boundary is null');
// //         return;
// //       }

// //       ui.Image image = await boundary.toImage(pixelRatio: 5.0);
// //       ByteData? byteData =
// //           await image.toByteData(format: ui.ImageByteFormat.png);
// //       if (byteData == null) {
// //         print('ByteData is null');
// //         return;
// //       }

// //       Uint8List pngBytes = byteData.buffer.asUint8List();
// //       String dir = (await getApplicationDocumentsDirectory()).path;
// //       String filePath = '$dir/${DateTime.now().millisecondsSinceEpoch}.png';
// //       File file = File(filePath);
// //       await file.writeAsBytes(pngBytes);

// //       await FlutterShare.shareFile(
// //         title: 'My File',
// //         filePath: file.path,
// //       );
// //     } catch (e) {
// //       print('Error: $e');
// //     }
// //   }

// //   GlobalKey barcodekey = new GlobalKey();
// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     return Scaffold(
// //       drawer: Drawer(
// //         child: Column(
// //           children: [
// //             Container(
// //               width: double.infinity,
// //               height: size.height / 5,
// //               child: Mytext(
// //                   text: 'my qr code',
// //                   size: size.height / 30,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.red),
// //             ),
// //             RepaintBoundary(
// //               key: barcodekey,
// //               child: BarcodeWidget(
// //                   data: 'https://nabulsi.com',
// //                   height: size.height / 5, //size.height/3,
// //                   width: size.width / 2,
// //                   barcode: Barcode.qrCode()),
// //             ),
// //             Center(
// //               child: InkWell(
// //                   onTap: () {
// //                     shareWidgetAsImage();
// //                   },
// //                   child: Icon(
// //                     Icons.share,
// //                     size: 80,
// //                   )),
// //             )
// //           ],
// //         ),
// //       ),
// //       appBar: AppBar(
// //         backgroundColor: Colors.teal,
// //         title: const Text("e-market"),
// //       ),
// //       body: StreamBuilder(
// //         stream: FirebaseFirestore.instance.collection('section').snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.hasError) {
// //             return const Center(
// //               child: Text('an error happend'),
// //             );
// //           } else if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           }
// //           return GridView.builder(
// //               itemCount: snapshot.data?.docs.length,
// //               gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
// //                   mainAxisSpacing: size.width / 20,
// //                   crossAxisSpacing: size.width / 20,
// //                   maxCrossAxisExtent: 200),
// //               itemBuilder: (context, index) {
// //                 var element = snapshot.data!.docs[index];
// //                 return Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: CircleAvatar(
// //                       radius: 50,
// //                       child: //Text(element['namear']),
// //                           Stack(children: [
// //                         Image.network(element['logourl']),
// //                         ClipRRect(
// //                             borderRadius: BorderRadius.circular(150),
// //                             child: Container(
// //                               color: Colors.black.withOpacity(.4),
// //                             )),
// //                         Center(
// //                             child: Mytext(
// //                                 text: element['namear'],
// //                                 size: size.height / 40,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.white)),
// //                       ])),
// //                 );
// //               });
// //         },
// //       ),
// //     );
// //   }
// // }



// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

 
// import 'package:chat/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
 

// class Market extends StatefulWidget {
//   const Market({super.key});

//   @override
//   State<Market> createState() => _MarketState();
// }

// class _MarketState extends State<Market> {
//   GlobalKey barcodeKey = GlobalKey();

//   Future<void> shareWidgetAsImage() async {
//     try {
//       RenderRepaintBoundary? boundary = barcodeKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//       if (boundary == null) {
//         return;
//       }

//       ui.Image image = await boundary.toImage(pixelRatio: 5.0);
//       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       if (byteData == null) {
//         return;
//       }

//       Uint8List pngBytes = byteData.buffer.asUint8List();
//       String dir = (await getApplicationDocumentsDirectory()).path;
//       String filePath = '$dir/${DateTime.now().millisecondsSinceEpoch}.png';
//       File file = File(filePath);
//       await file.writeAsBytes(pngBytes);

//       await FlutterShare.shareFile(
//         title: 'My File',
//         filePath: file.path,
//       );
//     } catch (e) {
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       drawer: Drawer(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: size.height / 5,
//               child: Mytext(
//                 text: 'my qr code',
//                 size: size.height / 30,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             RepaintBoundary(
//               key: barcodeKey,
//               child: BarcodeWidget(
//                 data: 'https://nabulsi.com',
//                 height: size.height / 5,
//                 width: size.width / 2,
//                 barcode: Barcode.qrCode(),
//               ),
//             ),
//             Center(
//               child: InkWell(
//                 onTap: shareWidgetAsImage,
//                 // ignore: prefer_const_constructors
//                 child: Icon(
//                   Icons.share,
//                   size: 80,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text("e-market"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('section').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('an error happened'),
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return GridView.builder(
//             itemCount: snapshot.data?.docs.length,
//             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//               mainAxisSpacing: size.width / 20,
//               crossAxisSpacing: size.width / 20,
//               maxCrossAxisExtent: 200,
//             ),
//             itemBuilder: (context, index) {
//               var element = snapshot.data!.docs[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircleAvatar(
//                   radius: 50,
//                   child: Stack(
//                     children: [
//                       Image.network(element['logourl']),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(150),
//                         child: Container(
//                           color: Colors.black.withOpacity(0.4),
//                         ),
//                       ),
//                       Center(
//                         child: Mytext(
//                           text: element['namear'],
//                           size: size.height / 40,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
