import 'package:driver_kangsayur/ui/auth/event/login_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/event/profile_driver_event.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/repository/logout_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/repository/profile_driver_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/profile/state/profile_driver_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileDriverBloc extends Bloc<ProfileDriverPageEvent, ProfileDriverPageState>{
  final ProfileDriverPageRepository profileDriverRepository;
  final LogoutRepository logoutRepository;

  ProfileDriverBloc({required this.profileDriverRepository, required this.logoutRepository}) : super(ProfileDriverPageInitial()) {
    on<GetProfileDriver>((event, emit) async {
      emit(ProfileDriverPageLoading());
      try {
        emit(ProfileDriverPageSuccess(await profileDriverRepository.pesananDriver()));
      } catch (e) {
        emit(ProfileDriverPageError(e.toString()));
      }
    });

    on<GetLogoutDriver>((event, emit) async {
      emit(ProfileDriverPageLoading());
      try {
        await logoutRepository.logout();
        emit(ProfileDriverPageSuccess(await profileDriverRepository.pesananDriver()));
      } catch (e) {
        emit(ProfileDriverPageError(e.toString()));
      }
    });
  }}