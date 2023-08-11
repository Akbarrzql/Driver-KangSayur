import 'package:driver_kangsayur/ui/bottom_navigation/item/home/event/analisa_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/analisa_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/state/analisa_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalisaPageBloc extends Bloc<AnalisaEvent, AnalisaState>{
  final AnalisaPageRepository analisaPageRepository;

  AnalisaPageBloc({required this.analisaPageRepository}) : super(AnalisaInitial()){
    on<GetAnalisa>((event, emit) async{
      emit(AnalisaLoading());
      try{
        emit(AnalisaSuccess(await analisaPageRepository.getAnalisa()));
      }catch(e){
        emit(AnalisaFailure(e.toString()));
      }
    });
  }
}