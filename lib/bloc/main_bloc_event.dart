part of 'main_bloc_bloc.dart';

@immutable
abstract class MainBlocEvent {
  final int page;

  const MainBlocEvent({required this.page});
}

class FetchMainBlocEvent extends MainBlocEvent {
  const FetchMainBlocEvent(page) : super(page: page);
}
