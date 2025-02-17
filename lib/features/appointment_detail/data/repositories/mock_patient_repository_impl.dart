import '../datasource/mock_patient_remote_datasource.dart';
import '../models/patient_model.dart';

abstract class PatientRepository {
  Future<List<PatientModel>> getPatients();
}

class MockPatientRepository implements PatientRepository {
  final MockPatientRemoteDataSource mockDataSource;

  MockPatientRepository(this.mockDataSource);

  @override
  Future<List<PatientModel>> getPatients() async {
    return await mockDataSource.getPatients();
  }
}

