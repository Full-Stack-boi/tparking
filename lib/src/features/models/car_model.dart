class CarModel {
  String? id;
  String? building;
  String? floor;
  String? carRegistration;
  String? slotName;
  bool? isParked;
  bool? paymentDone;
  bool? booked;
  String? parkedFrom;
  String? parkedTo;
  String? parkingHours;

  CarModel(
      {this.id,
      this.building,
      this.floor,
      this.carRegistration,
      this.slotName,
      this.isParked,
      this.paymentDone,
      this.booked,
      this.parkedFrom,
      this.parkedTo,
      this.parkingHours});

  CarModel.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    building = json["building"];
    floor = json["floor"];
    carRegistration = json["car_registration"];
    slotName = json["slot_name"];
    isParked = json["isParked"];
    paymentDone = json["payment_done"];
    booked = json["booked"];
    parkedFrom = json["parked_from"];
    parkedTo = json["parked_to"];
    parkingHours = json["parking_hours"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["building"] = building;
    data["floor"] = floor;
    data["car_registration"] = carRegistration;
    data["slot_name"] = slotName;
    data["isParked"] = isParked;
    data["payment_done"] = paymentDone;
    data["booked"] = booked;
    data["parked_from"] = parkedFrom;
    data["parked_to"] = parkedTo;
    data["parking_hours"] = parkingHours;
    return data;
  }
}
