import 'package:bloc/bloc.dart';

import '../../domain/use_cases/get_patients_use_case.dart';
import 'patient_event.dart';
import 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final GetPatientsUseCase getPatientsUseCase;

  PatientBloc(this.getPatientsUseCase) : super(PatientLoading()) {
    on<LoadPatientsEvent>((event, emit) async {
      final patients = await getPatientsUseCase.call(NoParams());
      emit(PatientLoaded(patients));
    });
  }
}
