import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasource/patient_remote_data_source.dart';


class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  PatientRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Patient>> getPatients() async {
    return await remoteDataSource.getPatients();
  }
}
