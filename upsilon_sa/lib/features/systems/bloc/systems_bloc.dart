import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'systems_event.dart';
part 'systems_state.dart';

class SystemsBloc extends Bloc<SystemsEvent, SystemsState> {
  SystemsBloc() : super(SystemsInitial()) {
    on<SystemsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
