part of 'main_bloc_bloc.dart';

@immutable
abstract class MainBlocState {}

class MainBlocLoaded extends MainBlocState {
  final List<PostModel> posts;
  final bool isLoading;

  MainBlocLoaded({
    required this.posts,
    required this.isLoading,
  });
}

class MainBlocLoading extends MainBlocState {}

class MainBlocError extends MainBlocState {
  final String message;

  MainBlocError({required this.message});
}

class MainBlocEmpty extends MainBlocState {
  final String message;

  MainBlocEmpty({required this.message});
}
