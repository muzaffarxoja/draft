import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/no_params.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/patient.dart';
import '../repositories/patient_repository.dart';

class GetPatientsUseCase implements UseCase<List<Patient>, NoParams> {
  final PatientRepository repository;

  GetPatientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Patient>>> call(NoParams params) async {
    return Right(await repository.getPatients());
  }
}
