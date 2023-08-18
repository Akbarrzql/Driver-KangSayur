import 'package:driver_kangsayur/ui/bottom_navigation/item/home/model/pesanan_driver_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/event/riwayat_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/model/riwayat_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/repository/riwayat_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/riwayat/state/riwayat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RiwayatDriverBloc extends Bloc<RiwayatEvent, RiwayatState>{
  final RiwayatRepository riwayatRepository;
  List<Datum2> _filteredProdukRiwayat = [];
  RiwayatModel? _riwayatModel;


  RiwayatDriverBloc({required this.riwayatRepository}) : super(RiwayatInitial()) {
    on<GetRiwayat>((event, emit) async {
      emit(RiwayatLoading());
      try {
        var riwayatModel = await riwayatRepository.riwyayatDriver(event.filterId);
        _riwayatModel = riwayatModel;
        emit(RiwayatSuccess(riwayatModel));
      } catch (e) {
        emit(RiwayatError(e.toString()));
      }
    });

    on<FilterProdukRiwayat>((event, emit) {
      final keyword = event.keyword.toLowerCase();

      if (RiwayatModel != null) {
        if (keyword.isNotEmpty) {
          _filteredProdukRiwayat = _riwayatModel!.data.where((produk) {
            final namaProduk = produk.barangPesanan[0].namaProduk .toString().toLowerCase();
            return namaProduk.contains(keyword);
          }).toList();
        } else {
          _filteredProdukRiwayat = _riwayatModel!.data;
        }
        emit(FilteredRiwayat(_filteredProdukRiwayat));
      }
    });
  }
}