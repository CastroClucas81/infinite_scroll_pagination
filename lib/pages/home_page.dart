import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/bloc/main_bloc_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MainBlocBloc mainBlocBloc;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    mainBlocBloc = BlocProvider.of<MainBlocBloc>(context)
      ..add(FetchMainBlocEvent(page));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        mainBlocBloc.add(FetchMainBlocEvent(page += 1));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("infinity scroll pagination"),
      ),
      body: BlocBuilder<MainBlocBloc, MainBlocState>(
        bloc: mainBlocBloc,
        builder: (context, state) {
          if (state is MainBlocLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MainBlocEmpty) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is MainBlocLoaded) {
            return Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100.0,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          state.posts[index].title,
                        ),
                      ),
                    );
                  },
                ),
                state.isLoading ? _loading() : Container(),
              ],
            );
          }

          return const Center(
            child: Text("Erro inesperado."),
          );
        },
      ),
    );
  }

  Widget _loading() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 45.0,
        width: 45.0,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 15.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 25.0,
              spreadRadius: 1.0,
            )
          ],
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
