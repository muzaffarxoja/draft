import '../models/patient_model.dart';
import 'dart:async';



class MockPatientRemoteDataSource {
  Future<List<PatientModel>> getPatients() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    return [
      PatientModel(
        id: "1",
        fullName: "Лысенко Андрей Владимирович",
        birthDate: "04 янв 2001",
        age: 21,
        mobilePhone: "+7 (927) 420-61-87",
      ),
      PatientModel(
        id: "2",
        fullName: "Лысенко Аркадий",
        birthDate: "03 авг 1986",
        age: 36,
        mobilePhone: "+7 (960) 453-81-23",
      ),
      PatientModel(
        id: "3",
        fullName: "Лысенко Вера",
        birthDate: "10 авг 1964",
        age: 58,
        mobilePhone: "+7 (966) 258-18-40",
      ),
    ];
  }
}
