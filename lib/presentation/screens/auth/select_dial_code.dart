import 'package:flutter/material.dart';
import '../../../constants/palette.dart';
import '../../../data/dial_codes.dart';
import 'login_screen.dart';
import '../../widgets/auth_widgets/custom_form_field.dart';
import '../../widgets/auth_widgets/dial_widget.dart';

class DialCodeScreen extends StatefulWidget {
  static const String routeName = '/select-dial';
  const DialCodeScreen({Key? key}) : super(key: key);

  @override
  State<DialCodeScreen> createState() => _DialCodeScreenState();
}

class _DialCodeScreenState extends State<DialCodeScreen> {
  bool isSearchIconPressed = false;
  List<Map<String, String>> searchedDials = [];

  void searchTapped() {
    setState(() {
      isSearchIconPressed = !isSearchIconPressed;
    });
  }

  void searchCountry(String query) {
    final suggestions = dialCodes
        .where((element) =>
            element['name']!.contains(RegExp(query, caseSensitive: false)))
        .toList();
    setState(() {
      searchedDials = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {
            if (isSearchIconPressed) {
              setState(() {
                isSearchIconPressed = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: isSearchIconPressed
            ? CustomFormField(
                hintText: 'Search Countries',
                textAlign: TextAlign.start,
                wantBorder: false,
                keyboardType: TextInputType.text,
                autofocus: true,
                onChanged: (value) {
                  searchCountry(value!);
                },
                onFieldSubmitted: (value) {
                  searchTapped();
                },
              )
            : const Text(
                'Choose a country',
                style: TextStyle(
                  color: Palette.tabColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () => searchTapped(),
            icon: Icon(
              isSearchIconPressed ? Icons.clear : Icons.search,
              size: 23.0,
            ),
          ),
        ],
      ),
      body: searchedDials.isNotEmpty
          ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var country = searchedDials[index];
                return InkWell(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.routeName,
                    (route) => false,
                    arguments: country,
                  ),
                  child: DialWidget(country),
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  height: 2.0,
                  thickness: 1.5,
                  color: Colors.grey[200],
                ),
              ),
              itemCount: searchedDials.length,
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var country = dialCodes[index];
                return InkWell(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.routeName,
                    (route) => false,
                    arguments: country,
                  ),
                  child: DialWidget(country),
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  height: 2.0,
                  thickness: 1.5,
                  color: Colors.grey[200],
                ),
              ),
              itemCount: dialCodes.length,
            ),
    );
  }
}
