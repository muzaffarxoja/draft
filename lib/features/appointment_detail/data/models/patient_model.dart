import '../../domain/entities/patient.dart';

class PatientModel extends Patient {
  PatientModel({
    required String id,
    required String fullName,
    required String birthDate,
    required int age,
    required String mobilePhone,
  }) : super(
    id: id,
    fullName: fullName,
    birthDate: birthDate,
    age: age,
    mobilePhone: mobilePhone,
  );

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      fullName: json['full_name'], // JSON key changed to snake_case
      birthDate: json['birth_date'], // JSON key changed to snake_case
      age: json['age'],
      mobilePhone: json['mobile_phone'], // JSON key changed to snake_case
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName, // Convert back to snake_case
      'birth_date': birthDate, // Convert back to snake_case
      'age': age,
      'mobile_phone': mobilePhone, // Convert back to snake_case
    };
  }
}
