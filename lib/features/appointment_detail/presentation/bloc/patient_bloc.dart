import 'package:bloc/bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/use_cases/get_patients_use_case.dart';
import 'patient_event.dart';
import 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final GetPatientsUseCase getPatientsUseCase;

  PatientBloc(this.getPatientsUseCase) : super(PatientLoading()) {
    on<LoadPatientsEvent>((event, emit) async {
      final result = await getPatientsUseCase.call(NoParams());

      result.fold(
            (failure) {
          // Handle failure based on its type
          String errorMessage;
          if (failure is ServerFailure) {
            errorMessage = "Server failure occurred";
          } else {
            errorMessage = "Unknown error occurred"; // Default message for unknown failures
          }

          // Emit error state with the error message
          emit(PatientError(errorMessage));
        },
            (patients) {
          emit(PatientLoaded(patients));
        },
      );
    });

  }
}

