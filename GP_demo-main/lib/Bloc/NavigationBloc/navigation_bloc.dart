// Events
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavigationEvent {}

class TabChanged extends NavigationEvent {
  final int index;
  final List<String> initialTestIds;
  TabChanged(this.index, {this.initialTestIds = const []});
}

// States
class NavigationState {
  final int selectedIndex;
  final List<String> initialTestIds; // ✅ جديد

  const NavigationState({
    this.selectedIndex = 0,
    this.initialTestIds = const [],
  });

  NavigationState copyWith({int? selectedIndex, List<String>? initialTestIds}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      initialTestIds: initialTestIds ?? this.initialTestIds,
    );
  }
}

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<TabChanged>((event, emit) {
      emit(
        NavigationState(
          selectedIndex: event.index,
          initialTestIds: event.initialTestIds,
        ),
      );
    });
  }
}
