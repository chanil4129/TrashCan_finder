import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

//회원가입 확인
class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  late Widget _choose_User_Shop;
  late UserSignUp _myUserSign;
  late ShopSignUp _myShopSign;

  _signUpState(){
    _choose_User_Shop=new ChooseUserShop(User_Shop_Button: User_Shop_Button,);
    _myUserSign=new UserSignUp();
    _myShopSign=new ShopSignUp();
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
class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
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
                    labelText: 'ex) 01012345678'),
              ),
            ),
            Container(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  heroTag: 'usersignup',

                  onPressed: () {
                    Future<bool> _future=UserSignUphttp();

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
  Future<bool> UserSignUphttp() async {
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
class ShopSignUp extends StatefulWidget {
  const ShopSignUp({Key? key}) : super(key: key);

  @override
  State<ShopSignUp> createState() => _ShopSignUpState();
}

class _ShopSignUpState extends State<ShopSignUp> {
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
                    labelText: 'ex) 01012345678'),
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
                  heroTag: 'shopsingup',

                  onPressed: () {
                    Future<bool> _future=ShopSignUphttp();

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

  Future<bool> ShopSignUphttp() async {
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
