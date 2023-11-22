class CarModel {
  String? name;
  bool? isParked;
  bool? paymentDone;
  bool? booked;
  String? parkedFrom;
  String? parkedTo;
  String? parkingHours;

  CarModel(
      {this.name,
      this.isParked,
      this.paymentDone,
      this.booked,
      this.parkedFrom,
      this.parkedTo,
      this.parkingHours});
  CarModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    isParked = json["isParked"];
    paymentDone = json["paymentDone"];
    booked = json["booked"];
    parkedFrom = json["parkedFrom"];
    parkedTo = json["parkedTo"];
    parkingHours = json["parkingHours"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["isParked"] = isParked;
    data["paymentDone"] = paymentDone;
    data["booked"] = booked;
    data["parkedFrom"] = parkedFrom;
    data["parkedTo"] = parkedTo;
    data["parkingHours"] = parkingHours;
    return data;
  }
}
