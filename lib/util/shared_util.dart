import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class SharedUtil {
  static final SharedUtil _instance = SharedUtil._internal();

  factory SharedUtil() => _instance;

  SharedUtil._internal();

  late SharedPreferences _prefSingle;
  Future<void> init() async {
    _prefSingle = await SharedPreferences.getInstance();
  }

  Future<void> reloadPref() async {
    await _prefSingle.reload();
  }

  Future<void> clearSharedPref() async {
    // Clear all preferences except IPs
    final ipOne = _prefSingle.getString("ip_one") ?? "";
    final ipTwo = _prefSingle.getString("ip_two") ?? "";
    await _prefSingle.clear();
    await _prefSingle.setString("ip_one", ipOne);
    await _prefSingle.setString("ip_two", ipTwo);
  }

  Future<void> clearSpecificKeys() async {
    await _prefSingle.remove("jwtToken");
    await _prefSingle.remove("decryptedJwtToken");
    await _prefSingle.remove("is_user_logged_in");
    await _prefSingle.remove("company_id");
    await _prefSingle.remove("bu_id");
    await _prefSingle.remove("plant_id");
    await _prefSingle.remove("department_id");
    await _prefSingle.remove("location_id");
    await _prefSingle.remove("Login_id");
    await _prefSingle.remove("employee_type");
    await _prefSingle.remove("employee_name");
    await _prefSingle.remove("token");
    await _prefSingle.remove("employee_name1");
    await _prefSingle.remove("image1");
    // await reloadPref();
  }

  Future<bool> setJWTToken(String jwtToken) =>
      _prefSingle.setString('jwtToken', jwtToken);
  Future<bool> setDecryptedJWTToken(String jwtToken) =>
      _prefSingle.setString('decryptedJwtToken', jwtToken);

  Future<void> setIpOne(String ipOne) => _prefSingle.setString("ip_one", ipOne);

  Future<void> setIpTwo(String ipTwo) => _prefSingle.setString("ip_two", ipTwo);
  Future<void> setisMttr(String isMttr) =>
      _prefSingle.setString("is_mttr", isMttr);
  Future<void> setisDowntime(String isDownTime) =>
      _prefSingle.setString("is_downtime", isDownTime);
  Future<void> setisMultiple(String isMultiple) =>
      _prefSingle.setString("is_multiple", isMultiple);

  Future<void> setIsIpOneChecked(bool isIpOneChecked) =>
      _prefSingle.setBool("is_ip_one_checked", isIpOneChecked);

  Future<void> setIsIpTwoChecked(bool isIpTwoChecked) =>
      _prefSingle.setBool("is_ip_Two_checked", isIpTwoChecked);

  Future<void> setRememberUser(String isLogin) =>
      _prefSingle.setString("is_user_logged_in", isLogin);

  Future<bool> setCompanyId(String companyId) =>
      _prefSingle.setString("company_id", companyId);

  Future<bool> setBuId(String bussinessUnitId) =>
      _prefSingle.setString("bu_id", bussinessUnitId);

  Future<bool> setPlantId(String plantId) =>
      _prefSingle.setString("plant_id", plantId);

  Future<void> setDepartmentId(String id) =>
      _prefSingle.setString("department_id", id);

  Future<void> setLoginId(String id) => _prefSingle.setString("Login_id", id);

  Future<bool> setLocationId(String LocationId) =>
      _prefSingle.setString("location_id", LocationId);

  Future<bool> setEmployeetype(String Employeetype) =>
      _prefSingle.setString("employee_type", Employeetype);

  Future<bool> setEmployeename(String Employeename) =>
      _prefSingle.setString("employee_name", Employeename);

  Future<bool> setToken(String token) => _prefSingle.setString("token", token);
  Future<bool> setEmpImage(String image) =>
      _prefSingle.setString("image", image);

  Future<void> setEmployeeName1(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('employee_name1', name);
  }

  Future<void> setImage1(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('image1', name);
  }

  // Future<bool> setEmployeeimage(String Employeeimage) =>
  //     _prefSingle.setString("employee_image", Employeeimage);

  String? get getcompanyId => _prefSingle.getString("company_id") ?? "";

  String? get getBuId => _prefSingle.getString("bu_id") ?? "";

  String? get getPlantId => _prefSingle.getString("plant_id") ?? "";

  String? get getLoginId => _prefSingle.getString("Login_id") ?? "";

  String? get getDepartmentId => _prefSingle.getString("department_id") ?? "";

  String? get getLocationId => _prefSingle.getString("location_id") ?? "";

  String? get getEmployeeType => _prefSingle.getString("employee_type") ?? "";

  String? get getEmployeeName => _prefSingle.getString("employee_name") ?? "";
  String? get getisMttr => _prefSingle.getString("is_mttr") ?? "";
  String? get getisdowntime => _prefSingle.getString("is_downtime") ?? "";
  String? get getisMultiple => _prefSingle.getString("is_multiple") ?? "";

  Future<String?> get getEmployeeName1 async {
    // Replace this with your actual asynchronous implementation
    return await SharedPreferences.getInstance()
        .then((pref) => pref.getString('employee_name1'));
  }

  String? get getToken => _prefSingle.getString("token") ?? "";
  // String? get getImage => _prefSingle.getString("image") ?? "";

  Future<String?> get getImage1 async {
    // Replace this with your actual asynchronous implementation
    return await SharedPreferences.getInstance()
        .then((pref) => pref.getString('image1'));
  }

  String? get getEmployeeImage => _prefSingle.getString("employee_image") ?? "";

  String? get getIsUserLogin =>
      _prefSingle.getString("is_user_logged_in") ?? "";

  String get getIpOne => _prefSingle.getString("ip_one") ?? "";

  String get getIpTwo => _prefSingle.getString("ip_two") ?? "";

  bool get IpOneCheckStatus => _prefSingle.getBool("is_ip_one_checked") ?? true;

  bool get IpTwoCheckStatus =>
      _prefSingle.getBool("is_ip_Two_checked") ?? false;

  String get getJWTToken => _prefSingle.getString('jwtToken') ?? '';
  String get getDecryptedJWTToken =>
      _prefSingle.getString('decryptedJwtToken') ?? '';

  //for set selected bu and plant
  Future<void> setSelectedCompanyId(String companyId) =>
      _prefSingle.setString("selected_company_id", companyId);
  Future<void> setSelectedBuId(String buId) =>
      _prefSingle.setString("selected_bu_id", buId);
  Future<void> setSelectedPlantId(String plantId) =>
      _prefSingle.setString("selected_plant_id", plantId);

  //for get selected company,bu,plant
  String? get getSelectedCompanyId =>
      _prefSingle.getString("selected_company_id") ?? "";
  String? get getSelectedBuId => _prefSingle.getString("selected_bu_id") ?? "";
  String? get getSelectedPlantId =>
      _prefSingle.getString("selected_plant_id") ?? "";
}
