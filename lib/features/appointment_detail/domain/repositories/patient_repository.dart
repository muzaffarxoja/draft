import '../entities/patient.dart';

abstract class PatientRepository {
  Future<List<Patient>> getPatients();
}
