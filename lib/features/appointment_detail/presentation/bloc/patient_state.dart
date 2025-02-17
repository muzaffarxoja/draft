import 'package:equatable/equatable.dart';
import '../../domain/entities/patient.dart';

abstract class PatientState extends Equatable {
  @override
  List<Object> get props => [];
}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final List<Patient> patients;

  PatientLoaded(this.patients);

  @override
  List<Object> get props => [patients];
}

class PatientError extends PatientState {
  final String message;

  PatientError(this.message);

  @override
  List<Object> get props => [message];
}
