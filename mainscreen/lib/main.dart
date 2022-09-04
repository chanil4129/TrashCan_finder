import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _UserMainScreen();
}

class _UserMainScreen extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 248, 181, 0),
          title: Center(
            child: Text("쓰레기 분리수거 찾기"),
          ),
        ),
        // body: Column(
        //   children: [
        //     Container(
        //       width: double.infinity,
        //       height: 40,
        //       child: Category(),
        //       color: Colors.transparent,
        //     ),
        //     Expanded(child: NaverMap_User())
        //   ],
        // ),
        body: Stack(
          children: [
            Positioned(child: NaverMap_User()),
            Container(
              width: double.infinity,
              height: 40,
              child: Category(),
              color: Colors.transparent,
            )
          ],
        ),
        drawer: Login(),
      ),
    );
  }
}

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<Category> {
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            color: Colors.transparent,
            height: 40,
            child: Container(
                margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset(
                              'myasset/myimage/general_waste.png'),
                          label: Text('일반쓰레기'),
                          onPressed: () => ProgramAccessShopData,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar:
                              new Image.asset('myasset/myimage/plastic.png'),
                          label: Text('플라스틱'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset('myasset/myimage/can.png'),
                          label: Text('캔'),
                          onSelected: (bool value) {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: InputChip(
                          avatar: new Image.asset(
                              'myasset/myimage/glass_bottle.png'),
                          label: Text('병'),
                          onSelected: (bool value) {},
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final bool login = false;

  @override
  Widget build(BuildContext context) {
    if (login) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('고객 이름'),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 181, 0),
              ),
            ),
            ListTile(
              title: Text('고객 정보'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('로그인'),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 181, 0),
              ),
            ),
            ListTile(
              title: Text('로그인'),
              onTap: () {
                ProgramAccessShopData();
              },
            ),
            ListTile(
              title: Text('회원가입'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context)=>signIn())
                );
              },
            )
          ],
        ),
      );
    }
  }
}

class NaverMap_User extends StatefulWidget {
  @override
  _NaverMapUserState createState() => _NaverMapUserState();
}

class _NaverMapUserState extends State<NaverMap_User> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NaverMap(
          // initialCameraPosition: CameraPosition(
          //   target: LatLng(27.6602292, 85.308027),
          //   zoom: 17,
          // ),
          onMapCreated: onMapCreated,
          mapType: _mapType,
        ),
      ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  Future<void> onLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }
}


Future<void> ProgramAccessShopData() async{
  Future<double?> latitude = currentlatitude();
  Future<double?> altitude = currentaltitude();

  String geturl = 'http://52.79.202.39/?REQ=post_GET_NEAR_SHOP&CUR_LOCATION=' +
  'LNG:' + altitude.toString() + ',LAT:' + latitude.toString() +
  '&CATEGORY=' + 'SHOP';
  Uri url = Uri.parse(geturl);

  http.Response response = await http.get(url);
  if (response != null) {
    print(response.body);
  } else {
    print("hi");
  }
}

Future<double?> currentlatitude() async{
  Location current = new Location();
  LocationData _locationData;
  _locationData = await current.getLocation();

  return _locationData.latitude;
}
Future<double?> currentaltitude() async{
  Location current = new Location();
  LocationData _locationData;
  _locationData = await current.getLocation();

  return _locationData.altitude;
}


Future<void> ProgramAccessLogin() async {
  String geturl = 'http://52.79.202.39/?REQ=api_LOGIN&USER_ID=' +
      'bluehill' +
      '&USER_PW=' +
      'qmffnglf' +
      '&USER_TYPE=' +
      'SHOP';
  Uri url = Uri.parse(geturl);

  http.Response response = await http.get(url);
  if (response != null) {
    print(response.body);
  } else {
    print("hi");
  }
}

void ProgramAccessSign() {}

//SignIn 전체 화면
class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  late Widget _choose_User_Shop;
  late UserSignin _myUserSign;
  late ShopSignin _myShopSign;

  _signInState(){
    _choose_User_Shop=new ChooseUserShop(User_Shop_Button: User_Shop_Button,);
    _myUserSign=new UserSignin();
    _myShopSign=new ShopSignin();
    user_shop.u_s=0;
  }

  @override
  Widget build(BuildContext context) {
    return _choose_User_Shop;
  }

  void User_Shop_Button(){
    if(user_shop.u_s==1) _choose_User_Shop=_myUserSign;
    if(user_shop.u_s==2) _choose_User_Shop=_myShopSign;
    setState(() {});
  }
}

//User, Shop 고르는 화면
class ChooseUserShop extends StatefulWidget {
  const ChooseUserShop({Key? key,required this.User_Shop_Button}) : super(key: key);
  final VoidCallback User_Shop_Button;

  @override
  State<ChooseUserShop> createState() => _ChooseUserShopState();
}

class _ChooseUserShopState extends State<ChooseUserShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User or Shop')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
                child: Column(
                  children: [
                    IconButton(onPressed: (){user_shop.u_s=1; widget.User_Shop_Button();}, icon: Icon(Icons.plagiarism),iconSize: 100.0,),
                    Text('User')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                ),
                child: Column(
                  children: [
                    IconButton(onPressed: (){user_shop.u_s=2; widget.User_Shop_Button();}, icon: Icon(Icons.home),iconSize: 100.0,),
                    Text('Shop')
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class user_shop{
  static int u_s=0;
}

//User 회원가입 화면
class UserSignin extends StatefulWidget {
  const UserSignin({Key? key}) : super(key: key);

  @override
  State<UserSignin> createState() => _UserSigninState();
}

class _UserSigninState extends State<UserSignin> {
  final _UserID=TextEditingController();
  final _UserPwd=TextEditingController();
  final _UserPn=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                'ID',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _UserID,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: 'ID를 입력하세요'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                'Password',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _UserPwd,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: '비밀번호를 입력하세요'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                '전화번호',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _UserPn,//UserPhoneNumber
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: '01012345678'),
              ),
            ),
            Container(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Future<bool> _future=UserSigninhttp();

                    _future.then((val) {
                      Navigator.pop(context,true);
                      showToast('회원가입 성공');
                    }).catchError((error){
                    showToast('회원가입 실패 : ID 중복');
                    });
                  },
                  label: Text('회원가입'),
                )),
          ],
        ),
      ),
    );
  }

  //BackEnd 통신(회원가입)
  Future<bool> UserSigninhttp() async {
    String _UriInfo='http://52.79.202.39/?REQ=api_WP_USER_ADD&USER_ID=${_UserID.text}&USER_PW=${_UserPwd.text}&USER_TYPE=USER&PHONE_NUM=${_UserPn.text}';
    final url=Uri.parse(_UriInfo);
    final response = await http.get(url);

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if(response.body.contains('해당 사용자명은 이미 있습니다')) throw 'error';

    return true;
  }
}

//Shop 회원가입 화면
class ShopSignin extends StatefulWidget {
  const ShopSignin({Key? key}) : super(key: key);

  @override
  State<ShopSignin> createState() => _ShopSigninState();
}

class _ShopSigninState extends State<ShopSignin> {
  final _ShopID=TextEditingController();
  final _ShopPwd=TextEditingController();
  final _ShopPn=TextEditingController();
  final _ShopName=TextEditingController();
  final _ShopAddress=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입'),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                'ID',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _ShopID,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: 'ID를 입력하세요'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                'Password',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _ShopPwd,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: '비밀번호를 입력하세요'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                '전화번호',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _ShopPn,//UserPhoneNumber
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: '01012345678'),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                '가게이름',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _ShopName,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: '가게이름을 입력하세요'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(
                '가게주소',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"
                ),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                controller: _ShopAddress,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                    labelText: '주소를 입력하세요'),
              ),
            ),


            Container(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Future<bool> _future=ShopSigninhttp();

                    _future.then((val) {
                      Navigator.pop(context,true);
                      showToast('회원가입 성공');
                    }).catchError((error){
                      showToast('회원가입 실패 : ID 중복');
                    });
                  },
                  label: Text('회원가입'),
                )),
          ],
        ),
      ),
    );
  }

  Future<bool> ShopSigninhttp() async {
    String _UriInfo='http://52.79.202.39/?REQ=api_WP_USER_ADD&USER_ID=${_ShopID.text}&USER_PW=${_ShopPwd.text}&USER_TYPE=SHOP&PHONE_NUM=${_ShopPn.text}';
    final url=Uri.parse(_UriInfo);
    final response = await http.get(url);

    String _UriInfoAdd='http://52.79.202.39/?REQ=post_PUT_ROOT_INFO&PHONE_NUM=${_ShopPn.text}&CATEGORY=SHOP&JSON_UPDATE={"SHOP_NAME":"${_ShopName.text}","SHOP_ADDRESS":"${_ShopAddress.text}"}';
    final urlAdd=Uri.parse(_UriInfoAdd);
    final responseAdd=await http.post(urlAdd);
    print('Response status: ${responseAdd.statusCode}');
    print('Response body: ${responseAdd.body}');

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if(response.body.contains('해당 사용자명은 이미 있습니다')) throw 'error';

    return true;
  }
}

//Toast
void showToast(String message){
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.black38,
    textColor: Colors.white,
  );
}


