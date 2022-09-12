currentLocation currentUser = currentLocation();

///가게 하나만 담아서 넣어주는 곳
Shop shop = Shop();

///쓰레기 종류
String trash = "";

///가게 전체를 담는 리스트
List<Store> shopes = [];
List<Store> shop_ranks = [];

///개개인 가게 정보 클래스
class Shop {
  String shopName = "가게명";
  String shopAddress = "주소";
  String shopNumber = "전화번호";
  bool shopIsOpen = false;
  int shopPoint = 0;
  List<double> shopLocation = [0, 0];
  List<bool> trashFlag = [false, false, false, false];
}

///가게 위치 리스트 받는부분
class ShopLocation {
  late double lng;
  late double lat;

  ShopLocation({required this.lng, required this.lat});

  factory ShopLocation.fromJson(Map<String, dynamic> json) {
    shop.shopLocation[0] = json['LNG'];
    shop.shopLocation[1] = json['LAT'];
    return ShopLocation(lng: json['LNG'], lat: json['LAT']);
  }
}

List<bool> trashFlag = [false, false, false, false];
bool shopOpen = false;

///카테고리 종류 받는 부분
class TrashType {
  late bool general;
  late bool pet;
  late bool cans;
  late bool paper;

  TrashType({
    required this.general,
    required this.pet,
    required this.cans,
    required this.paper,
  });

  factory TrashType.fromJson(Map<String, dynamic> json) {
    shop.trashFlag[0] = json['GENERAL'];
    shop.trashFlag[1] = json['PET'];
    shop.trashFlag[2] = json['CANS'];
    shop.trashFlag[3] = json['PAPER'];
    return TrashType(
      general: json['GENERAL'],
      pet: json['PET'],
      cans: json['CANS'],
      paper: json['PAPER'],
    );
  }
}

///전체적으로 가게 모든 데이터를 받는 부분
class Store {
  final String shopName;
  final String shopAddress;
  final String shopNumber;
  final bool shopIsOpen;
  final int shopPoint;
  final ShopLocation shopLocation;
  final TrashType trashType;

  Store(
      {required this.shopName,
        required this.shopAddress,
        required this.shopNumber,
        required this.shopIsOpen,
        required this.shopPoint,
        required this.shopLocation,
        required this.trashType});

  factory Store.fromJson(Map<String, dynamic> json) {
    shop.shopIsOpen = json['SHOP_IS_OPEN'];
    shop.shopName = json['SHOP_NAME'];
    shop.shopAddress = json['SHOP_ADDRESS'];
    shop.shopNumber = json['ID_AUX'];
    shop.shopPoint = json['SHOP_POINT'];
    return Store(
        shopName: json['SHOP_NAME'],
        shopAddress: json['SHOP_ADDRESS'],
        shopNumber: json['ID_AUX'],
        shopIsOpen: json['SHOP_IS_OPEN'],
        shopPoint: json['SHOP_POINT'],
        shopLocation: ShopLocation.fromJson(json['SHOP_LOCATION']),
        trashType: TrashType.fromJson(json['TRASH_TYPE']));
  }

  Map<String, dynamic> toJson() => {
    'SHOP_NAME': shopName,
    'SHOP_ADDRESS': shopAddress,
    'ID_AUX': shopNumber,
    'SHOP_IS_OPEN': shopIsOpen,
    'SHOP_POINT': shopPoint,
    'TRASH_TYPE': trashType,
    'SHOP_LOCATION': shopLocation
  };
}

class currentLocation {
  double lat = 0.0;
  double lng = 0.0;
}