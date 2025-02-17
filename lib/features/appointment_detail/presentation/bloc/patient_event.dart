import 'package:equatable/equatable.dart';

abstract class PatientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPatientsEvent extends PatientEvent {}
