import 'package:meta/meta.dart';

@immutable
class ViewState {
  const ViewState({
    this.isLoading,
  });

  factory ViewState.initial() {
    return const ViewState(
      isLoading: false,
    );
  }

  final bool isLoading;

  ViewState copyWith({
    bool isLoading,
  }) {
    return ViewState(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  int get hashCode => isLoading.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ViewState &&
              runtimeType == other.runtimeType &&
              isLoading == other.isLoading;

  @override
  String toString() {
    return 'ViewState: {isLoading: $isLoading}';
  }
}
