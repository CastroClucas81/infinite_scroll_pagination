import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:infinite_scroll_pagination/models/post_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'main_bloc_event.dart';
part 'main_bloc_state.dart';

class MainBlocBloc extends Bloc<MainBlocEvent, MainBlocState> {
  MainBlocBloc() : super(MainBlocLoading());

  List<PostModel> postList = [];
  int maxPage = 5;

  @override
  Stream<MainBlocState> mapEventToState(MainBlocEvent event) async* {
    switch (event.runtimeType) {
      case FetchMainBlocEvent:
        if (event.page <= maxPage) {

          if (event.page > 1) {
            yield MainBlocLoaded(
              posts: postList,
              isLoading: postList.isEmpty ? false : true,
            );
          }

          yield await _fetchPosts(postList, event.page);
        }
        break;
    }
  }

  Future<MainBlocState> _fetchPosts(List<PostModel> postList, int page) async {
    final response = await http.get(
      Uri.parse(
          'http://jsonplaceholder.typicode.com/posts?_limit=10&_page=$page'),
    );

    switch (response.statusCode) {
      case 200:
        var decoded = jsonDecode(response.body);

        if (decoded != null) {
          List<PostModel> decodedPostList = [];

          for (var post in decoded) {
            decodedPostList.add(PostModel.fromJson(post));
          }

          postList.addAll(decodedPostList);

          return MainBlocLoaded(posts: postList, isLoading: false);
        }

        return MainBlocEmpty(message: "Lista Vazia.");
      case 400:
        return MainBlocError(message: "Falha ao carregar os dados.");
      default:
        return MainBlocError(
            message: "Não foi possível conectar-se ao servidor.");
    }
  }

  /*
  Future<MainBlocState> _fetch(List<String> responseData) async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) != null) {
        for (int i = 0; i < 10; i++) {
          responseData.add(jsonDecode(response.body)['message']);
        }

        return MainBlocLoaded(dogImages: responseData, isLoading: false);
      }

      return MainBlocEmpty(message: "Não há cadastros.");
    } else {
      return MainBlocError(message: "Falha ao carregar os dados.");
    }
  }
  */
}
