import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readwise/core/repositories/books/books_repository.dart';
import 'package:readwise/presentation/common/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getAllData();
    final booksRepo = BooksRepository();
    // print(await booksRepo.getBooks());
    // print('-------------');
    // print(booksRepo.getBookById('1'));
    // print('-------------');
    // print(booksRepo.getBooksByCategory('sports'));
    // print('-------------');
    // print(booksRepo.getBooksByLanguage('en'));
    // print('-------------');
    // print(booksRepo.getBooksByIds(['1', '2', '3', '4']));
    // print('-------------');
    // print(booksRepo.getBookById('1'));
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Home page'),
      body: Column(
        children: [
          Text('Hello'),
          OutlinedButton(
            onPressed: () {
              context.go('/settings');
            },
            child: Text('go to settings'),
          ),
        ],
      ),
    );
  }

  void getAllData() async {
    final booksRepo = BooksRepository();
    final data = await booksRepo.getBooksByIds('1,2,3');
    print(data.results?.length);
  }
}
