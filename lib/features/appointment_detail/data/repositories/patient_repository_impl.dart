// import 'package:dartz/dartz.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../domain/entities/patient.dart';
// import '../../domain/repositories/patient_repository.dart';
// import '../datasource/patient_remote_data_source.dart';
//
//
// class PatientRepositoryImpl implements PatientRepository {
//   final PatientRemoteDataSource remoteDataSource;
//
//   PatientRepositoryImpl(this.remoteDataSource);
//
//   @override
//   Future<Either<Failure, List<Patient>>> getPatients() async {
//     try {
//       final patients = await remoteDataSource.getPatients();
//       return Right(patients);
//     } catch (e) {
//       return Left(ServerFailure());
//     }
//   }
// }
