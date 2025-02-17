import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<List<PatientModel>> getPatients();
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final http.Client client;

  PatientRemoteDataSourceImpl(this.client);

  @override
  Future<List<PatientModel>> getPatients() async {
    final response = await client.get(Uri.parse('https://yourapi.com/patients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PatientModel.fromJson(json)).toList();
    } else {
      throw Exception("Error fetching patients");
    }
  }
}
