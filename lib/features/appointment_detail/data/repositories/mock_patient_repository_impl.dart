import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasource/mock_patient_remote_datasource.dart';
import '../models/patient_model.dart';

class MockPatientRepository implements PatientRepository {
  final MockPatientRemoteDataSource mockDataSource;

  MockPatientRepository(this.mockDataSource);


  @override
  Future<Either<Failure, List<Patient>>> getPatients() async {
    try {
      final List<PatientModel> patientModels = await mockDataSource.getPatients();
      final patients = patientModels.map((model) => model.toDomain()).toList();
      return Right(patients);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
  }


