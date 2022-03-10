import 'package:chat_app/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  
  @override
  Widget build(BuildContext context) {
    
    final _search = Provider.of<Search>(context);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Icon(
            Icons.search,
            size: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ChangeNotifierProvider.value(
              value: _search,
              child: TextField(
                controller: _search.searchController,
                onChanged: (_) => _search.change(),
                decoration: InputDecoration(
                    label: const Text('Search for a user'),
                    labelStyle: const TextStyle(color: Colors.white),
                    hintText: 'Search by username...',
                    hintStyle: TextStyle(color: Colors.grey[700])),
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ), 
        ],
      ),
      actions: [
        _search.searchController.text != '' ? IconButton(
            onPressed: () {
              _search.searchController.clear();
             FocusManager.instance.primaryFocus?.unfocus();
             _search.change();
            },
            icon: const Icon(
              Icons.cancel,
              size: 20,
            )) : Container()
      ],
    );
  }
}
