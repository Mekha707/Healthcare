import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart'; // 👈 السطر ده مهم جداً

// ... الـ imports كما هي

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final UserService _apiService;
  int _currentPage = 1;
  String? _lastQueryKey;

  // حفظ الفلاتر الحالية لضمان استمراريتها عند الـ Pagination
  String? _activeFilterName;
  String? _activeFilterSpecialtyId;
  String? _activeFilterLocation;
  String? _activeFilterServiceType;

  DoctorsBloc(this._apiService) : super(DoctorsInitial()) {
    on<FetchDoctors>(_onFetch);
    on<LoadMoreDoctors>(_onLoadMore);
    on<RefreshDoctors>(_onRefresh);
    on<FilterDoctors>(_onFilter, transformer: restartable());
  }

  Future<void> _onFetch(FetchDoctors event, Emitter<DoctorsState> emit) async {
    emit(DoctorsLoading());
    _currentPage = 1;
    _clearFilters(); // تصفير الفلاتر عند البداية من جديد

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final result = await _apiService.getDoctors(page: _currentPage);
      emit(
        DoctorsLoaded(
          allDoctors: result.items,
          filteredDoctors: result.items,
          hasNextPage: result.hasNextPage,
          currentPage: _currentPage,
        ),
      );
    } catch (e) {
      emit(DoctorsError(e.toString()));
    }
  }

  Future<void> _onFilter(
    FilterDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    final newQueryKey =
        "${event.name}_${event.specialtyId}_${event.cityName}_${event.serviceType}";

    // 🔥 يمنع إعادة نفس الريكوست
    if (_lastQueryKey == newQueryKey) return;
    _lastQueryKey = newQueryKey;

    _activeFilterName = event.name;
    _activeFilterSpecialtyId = event.specialtyId;
    _activeFilterLocation = event.cityName;
    _activeFilterServiceType = event.serviceType;
    _currentPage = 1;

    // ✅ لو فيه داتا قبل كده، خليه loading خفيف
    if (state is DoctorsLoaded) {
      emit((state as DoctorsLoaded).copyWith(isRefreshing: true));
    } else {
      emit(DoctorsLoading());
    }

    try {
      final result = await _apiService.getDoctors(
        page: _currentPage,
        name: _activeFilterName,
        specialtyId: _activeFilterSpecialtyId,
        location: _activeFilterLocation,
        serviceType: _activeFilterServiceType,
      );

      emit(
        DoctorsLoaded(
          allDoctors: result.items,
          filteredDoctors: result.items,
          hasNextPage: result.hasNextPage,
          currentPage: _currentPage,
        ),
      );
    } catch (e) {
      emit(DoctorsError("Search Error: ${e.toString()}"));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    final current = state;
    if (current is! DoctorsLoaded ||
        !current.hasNextPage ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;

    try {
      final result = await _apiService.getDoctors(
        page: _currentPage,
        // ✅ نرسل كل الفلاتر النشطة حالياً عشان الـ Pagination يكمل صح
        name: _activeFilterName,
        specialtyId: _activeFilterSpecialtyId,
        location: _activeFilterLocation,
        serviceType: _activeFilterServiceType != null
            ? (_activeFilterServiceType!)
            : null,
      );

      final updatedItems = [...current.allDoctors, ...result.items];

      emit(
        current.copyWith(
          allDoctors: updatedItems,
          filteredDoctors: updatedItems,
          hasNextPage: result.hasNextPage,
          currentPage: _currentPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      _currentPage--;
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(
    RefreshDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    add(FetchDoctors());
  }

  void _clearFilters() {
    _activeFilterName = null;
    _activeFilterSpecialtyId = null;
    _activeFilterLocation = null;
    _activeFilterServiceType = null;
  }
}
