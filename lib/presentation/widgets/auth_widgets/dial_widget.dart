import 'package:flutter/material.dart';

class DialWidget extends StatelessWidget {
  final Map<String, String> country;
  const DialWidget(this.country, {Key? key}) : super(key: key);

  String generateFlag(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        generateFlag(country['code']!),
        style: const TextStyle(fontSize: 20.0),
      ),
      title: Text(
        country['name']!,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      trailing: Text(
        country['dialCode']!,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
          fontSize: 16.0,
        ),
      ),
    );
  }
}
