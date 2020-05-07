import 'package:flutter/material.dart';
import 'package:sjovikvass_app/screens/landing/widgets/objects_list.dart';
import 'package:sjovikvass_app/services/database_service.dart';
import 'package:sjovikvass_app/styles/my_colors.dart';

//The screen that contains the list of object stored at the warehouse.
class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchString = '';
  bool _isSearching = false;
  bool _openSearch = false;

  _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(20.0)),
      child: TextField(
        decoration: InputDecoration(
            suffixIcon: _isSearching
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        }))
                : null,
            border: InputBorder.none,
            hintText: 'Sök objektnamn...'),
        controller: _searchController,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (String value) {
          _isSearching = !_isSearching;
          if (value.isNotEmpty) {
            setState(() {
              _isSearching = true;
              _searchString = value;
            });
          } else {
            setState(() {
              _isSearching = false;
              _searchString = null;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '   Sjövik Förvaring',
                  style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: _openSearch ? MyColors.primary : Colors.black54,
                    ),
                    onPressed: () => setState(() {
                          _openSearch = !_openSearch;
                        }))
              ],
            ),
            _openSearch ? _buildSearchBar() : SizedBox.shrink(),
            _isSearching
                ? ObjectsList(
                    objects:
                        DatabaseService.getStoredObjectsSearch(_searchString),
                    searchString: _searchString,
                  )
                : ObjectsList(
                    objects: DatabaseService.getStoredObjectsFuture(),
                    objectsFutureGetter: DatabaseService.getStoredObjectsFuture,
                  ),
          ],
        ),
      ),
    );
  }
}
