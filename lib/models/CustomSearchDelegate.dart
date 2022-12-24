import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/search_result_screen.dart';
import 'package:flutter_complete_guide/widgets/search_result_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    "macbook",
    "iphone",
    "nike",
    "apple",
    "asus",
    "oppo",
    "monitor",
  ];
  String search;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var keyword in searchTerms) {
      if (keyword.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(keyword);
      }
    }
    if (matchQuery.isEmpty) {
      return SearchResultGrid(query);
    } else {
      return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return TextButton(
            onPressed: (() {
              Navigator.of(context).pushNamed(
                SearchResultScreen.routeName,
                arguments: result,
              );
            }),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: Text(
                result,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
          );
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var keyword in searchTerms) {
      if (keyword.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(keyword);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            onPressed: (() {
              Navigator.of(context).pushNamed(
                SearchResultScreen.routeName,
                arguments: result,
              );
            }),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(4),
              child: Text(
                result,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ));
      },
    );
  }
}
