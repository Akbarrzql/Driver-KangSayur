import 'package:driver_kangsayur/ui/bottom_navigation/item/home/event/pesanan_driver_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/pesanan_driver_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/home_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/konfirmasi_driver_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/state/pesanan_driver_state.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/event/profile_driver_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/repository/profile_driver_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PesananDriverBloc extends Bloc<PesananPageEvent, PesananDriverPageState>{
  final PesananDriverRepository pesananDriverRepository;
  final KonfirmasiRepository konfirmasiDriverRepository;

  PesananDriverBloc({required this.pesananDriverRepository, required this.konfirmasiDriverRepository}) : super(InitialPesananDriverPageState()) {
    on<GetPesanan>((event, emit) async {
      emit(PesananDriverPageLoading());
      try {
        emit(PesananDriverPageLoaded(await pesananDriverRepository.pesananDriver()));
      } catch (e) {
        emit(PesananDriverPageError(e.toString()));
      }
    });

    on<GetKonfirmasi>((event, emit) async {
      emit(PesananDriverPageLoading());
      try {
        emit(KonfirmasiDriverPageLoaded(await konfirmasiDriverRepository.konfirmasi(event.transactionCode, event.userId, event.storeId)));
      } catch (e) {
        emit(PesananDriverPageError(e.toString()));
      }
    });
  }}