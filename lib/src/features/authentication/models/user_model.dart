import '../../../utils/encryption_helper.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;
  final String roles;
  final String? imgaeLink;
  final List<String> carRegistrations;

  UserModel(
      {this.imgaeLink,
      this.id,
      required this.fullName,
      required this.email,
      required this.phoneNo,
      required this.password,
      required this.roles,
      this.carRegistrations = const []});

  toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNo": phoneNo,
      "roles": roles,
      "imgaeLink": imgaeLink,
      "car_registrations": carRegistrations.map((car) => EncryptionHelper.encrypt(car)).toList(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> rawCars = [];
    final carRegsData = json["car_registrations"];
    
    if (carRegsData is List) {
      rawCars = List<String>.from(carRegsData.map((e) => e?.toString() ?? ''));
    } else if (carRegsData is String) {
      if (carRegsData.isNotEmpty && carRegsData != '{}' && carRegsData != '[]') {
        // Handle raw Postgres array formats like "{car1,car2}" or JSON string arrays
        final clean = carRegsData
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .replaceAll("'", "");
        rawCars = clean
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    final decryptedCars = rawCars.map((car) => EncryptionHelper.decrypt(car)).toList();

    return UserModel(
      id: json["id"]?.toString(),
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
      phoneNo: json["phoneNo"] ?? "",
      password: json["password"] ?? "",
      roles: json["roles"] ?? "",
      imgaeLink: (json["imgaeLink"]?.toString() == 'null' || json["imgaeLink"]?.toString() == '')
          ? null
          : json["imgaeLink"]?.toString(),
      carRegistrations: decryptedCars,
    );
  }
}
