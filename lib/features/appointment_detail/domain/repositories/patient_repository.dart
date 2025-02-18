import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<Patient>>> getPatients();
}
