import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Training Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: RouteOne(),
    );
  }
}

class RouteOne extends StatelessWidget {
  //기본 화면. 병합할땐 지우면 됨
  const RouteOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('기본 화면'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                QR_InputText()))); //가게용 관리자를 위한 QR코드 생성기로 이동
                  },
                  child: Text('QR코드 만들기')),
              ElevatedButton(
                onPressed: () {
                  getPermission();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              QR_View()))); //사용자를 위한 QR코드 인식기로 이동
                },
                child: Text('QR코드 읽기 - 테스트로 인해 현재 카메라 비활성화'),
              ),
            ],
          ),
        ));
  }

  getPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
    } else if (status.isDenied) {
      Permission.camera.request();
    }
  }
}

class QR_InputText extends StatefulWidget {
  const QR_InputText({Key? key}) : super(key: key);

  @override
  State<QR_InputText> createState() => _QR_InputTextState();
}

class _QR_InputTextState extends State<QR_InputText> {
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR코드 만들기'),
      ),
      body: _buildTextComposer(),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.orangeAccent),
      child: Container(
          alignment: Alignment(0.0, 0.0),
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: InputDecoration(
                        labelText: '가게 전화번호',
                        hintText: '가게 전화번호를 입력해주세요',
                        labelStyle: TextStyle(color: Colors.orangeAccent),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.orangeAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.orangeAccent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => QRMaker(
                                        mCode: _textController.text,
                                      ))));
                        }),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
  }
}

class QRMaker extends StatelessWidget {
  const QRMaker({Key? key, required this.mCode}) : super(key: key);

  final mCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR코드 생성기'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              QrImage(
                //가게용 관리자가 입력한 mCode를 기반으로 QR 이미지 생성
                data: '${mCode}',
                size: 200,
              )
            ],
          ),
        ));
  }
}

class QR_View extends StatefulWidget {
  //사용자가 QR코드를 찍기 위해 카메라를 키는 페이지
  const QR_View({Key? key}) : super(key: key);

  @override
  State<QR_View> createState() => _QR_ViewState();
}

class _QR_ViewState extends State<QR_View> {
  var _qrString = 'Scan code empty';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR코드 읽기'),
      ),
      body: _scanQRCode(),
    );
  }

  Widget _scanQRCode() {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Text(_qrString),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanner.scan();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => QRChecker(mCode: _qrString))));
        },
        tooltip: 'scan',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future _scan() async {
    String? barcode = await scanner.scan();

    if (barcode != null) {
      setState(() => _qrString = barcode);
    }
  }
}

class QRChecker extends StatefulWidget {
  //찍힌 QR코드에 적힌 전화번호값을 바탕으로 투기한 쓰레기를 체크하는 곳
  QRChecker({Key? key, required this.mCode}) : super(key: key);

  final mCode;

  @override
  State<QRChecker> createState() => _QRCheckerState();
}

class _QRCheckerState extends State<QRChecker> {
  List<String> _garbageType = ["일반 쓰레기", "페트", "캔", "종이"];

  List<bool> _isChecked = [false, false, false, false];
  List<bool> _isButtonDisabled = [false, false, false, false];
  late Uri phoneNum;

  Future<ShopInfo>? shopInfo;

  @override
  void initState() {
    super.initState();
    print('start GetShopData');
    shopInfo = GetShopData(widget.mCode);
    //shopInfo = GetShopData('01011111111');
    Future.delayed(Duration.zero, () {
      _isChecked = List<bool>.filled(_garbageType.length, false);
    });
    print('end initiate!');
    convertFuture();
  }

  void convertFuture() async {
    await shopInfo?.then((value) {
      _isButtonDisabled[0] = value.TRASH_TYPE.GENERAL;
      _isButtonDisabled[1] = value.TRASH_TYPE.PET;
      _isButtonDisabled[2] = value.TRASH_TYPE.CANS;
      _isButtonDisabled[3] = value.TRASH_TYPE.PAPER;
      phoneNum = Uri.parse('tel:${value.SHOP_NUMBER}');
      print('Future value converted!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('투기한 쓰레기 체크하기'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /*
          Spacer(
            flex: 1,
          ),
          */
          Container(
            margin: EdgeInsets.only(top: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<ShopInfo>(
                  future: shopInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.SHOP_NAME.toString(),
                        style: TextStyle(fontSize: 40),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        '가게를 불러올 수 없음!',
                        style: TextStyle(fontSize: 40),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder<ShopInfo>(
                  future: shopInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.SHOP_ADDRESS.toString(),
                        style: TextStyle(fontSize: 20),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        '가게주소 없음',
                        style: TextStyle(fontSize: 20),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder<ShopInfo>(
                  future: shopInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.SHOP_NUMBER.toString(),
                        style: TextStyle(
                          height: 2.0,
                          color: Colors.grey,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        '가게 전화번호 없음',
                        style: TextStyle(
                          height: 2.0,
                          color: Colors.grey,
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                TextButton(
                  child: Text(
                    '전화걸기',
                    style: TextStyle(
                      height: 2.0,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: () async {
                    if (await url_launcher.canLaunchUrl(phoneNum)) {
                      url_launcher.launchUrl(phoneNum);
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('전화를 걸 수 없습니다.'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('전화번호가 등록되어있지 않습니다.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ok'),
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              ],
            ),
          ),
          /*
          Spacer(
            flex: 1,
          ),
          */
          Expanded(
              child: FutureBuilder<ShopInfo>(
            future: shopInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _garbageType.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: CheckboxListTile(
                            title: Text(_garbageType[index]),
                            value: _isChecked[index],
                            onChanged: _isButtonDisabled[index]
                                ? (val) {
                                    setState(
                                      () {
                                        _isChecked[index] = val as bool;
                                        print(index);
                                      },
                                    );
                                  }
                                : null),
                      );
                    },
                  ),
                );
              } else
                return CircularProgressIndicator();
            },
          )),
          Container(
            height: 48,
            width: double.maxFinite,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(shape: BeveledRectangleBorder()),
              child: Text('선택 완료'),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('제출하시겠습니까?'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('한번 제출한 이후에는 다시 변경할 수 없습니다.'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('예, 알겠습니다.'),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class afterTransfer extends StatefulWidget {
  const afterTransfer({Key? key, required this.mCode}) : super(key: key);

  final mCode;

  @override
  State<afterTransfer> createState() => _afterTransferState();
}

class _afterTransferState extends State<afterTransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('체크 완료!'),
      ),
    );
  }
}

Future<ShopInfo> GetShopData(String ShopNumber) async {
  final url = Uri.parse(
      'http://52.79.202.39/?REQ=post_GET_ROOT_INFO&PHONE_NUM=' +
          ShopNumber +
          '&CATEGORY=SHOP');
  /*
  final url = Uri.parse(
      "http://52.79.202.39/?REQ=post_GET_ROOT_INFO&PHONE_NUM=01011111111&CATEGORY=SHOP");
      */
  print(url);

  final response = await http.get(url);

  print('Hello World!');

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return ShopInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception("server response failed");
  }
}

class TRASHTYPE {
  final bool GENERAL;
  final bool PET;
  final bool CANS;
  final bool PAPER;

  TRASHTYPE({
    required this.GENERAL,
    required this.PET,
    required this.CANS,
    required this.PAPER,
  });

  factory TRASHTYPE.fromJson(Map<String, dynamic> json) {
    return TRASHTYPE(
        GENERAL: json['GENERAL'] as bool,
        PET: json['PET'] as bool,
        CANS: json['CANS'] as bool,
        PAPER: json['PAPER'] as bool);
  }
}

class ShopInfo {
  final String SHOP_NAME;
  final String SHOP_ADDRESS;
  final String SHOP_NUMBER;
  final bool SHOP_IS_OPEN;
  final int SHOP_POINT;
  final TRASHTYPE TRASH_TYPE;

  ShopInfo({
    required this.SHOP_NAME,
    required this.SHOP_ADDRESS,
    required this.SHOP_NUMBER,
    required this.SHOP_IS_OPEN,
    required this.SHOP_POINT,
    required this.TRASH_TYPE,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) {
    return ShopInfo(
      SHOP_NAME: json['SHOP_NAME'] as String,
      SHOP_ADDRESS: json['SHOP_ADDRESS'] as String,
      SHOP_NUMBER: json['SHOP_NUMBER'] as String,
      SHOP_IS_OPEN: json['SHOP_IS_OPEN'] as bool,
      SHOP_POINT: json['SHOP_POINT'] as int,
      TRASH_TYPE: TRASHTYPE.fromJson(json['TRASH_TYPE']),
    );
  }
}

/*
가게이름 : SHOP_NAME
주소 : SHOP_ADDRESS
전화번호 : SHOP_NUMBER
활성화 : SHOP_IS_OPEN
적립금 : SHOP_POINT
GPS정보 : SHOP_LOCATION : {"LNG" : (경도값), "LAT" : (위도값)}
카테고리 : TRASH_TYPE : {"GENERAL" : true, "PET" : true, "CANS" : true, "PAPER" : ture}
*/