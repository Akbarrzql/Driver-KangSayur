import 'package:driver_kangsayur/tracking/repository/selesai_driver_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driver_kangsayur/tracking/event/update_location_event.dart';
import 'package:driver_kangsayur/tracking/state/update_location_state.dart';
import 'package:driver_kangsayur/tracking/repository/update_location_repository.dart';


class UpdateLokasiBloc extends Bloc<UpdateLocationPageEvent, UpdateLocationPageState>{
  final UpdateLocationRepository updateLocationRepository;
  final Selesairepository selesairepository;

  UpdateLokasiBloc({required this.updateLocationRepository, required this.selesairepository}) : super(InitialUpdateLocationPageState()) {
    on<UpdateLocation>((event, emit) async {
      emit(UpdateLocationPageLoading());
      try {
        await updateLocationRepository.updateLocation(event.latitude, event.longitude, event.transactionCode);
        emit(UpdateLocationPageLoaded());
      } catch (e) {
        emit(UpdateLocationPageError(e.toString()));
      }
    });

    on<SelesaiPengiriman>((event, emit) async {
      emit(UpdateLocationPageLoading());
      try {
        await selesairepository.selesai(event.userId, event.storeId, event.transactionCode);
        emit(SelesaiUpdateLocationPage(await selesairepository.selesai(event.userId, event.storeId, event.transactionCode)));
      } catch (e) {
        emit(UpdateLocationPageError(e.toString()));
      }
    });
  }

}
