import 'package:flutter/material.dart';

extension AppString on String {
  String get toCapitalized {
    try {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    } catch (error) {
      return this;
    }
  }

  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');

  bool get isStringNull => this == "" ? true : false;
  String? get stringOrNull => this == "" ? null : this;
  Color get hexColor =>
      Color(int.parse(toUpperCase().replaceAll("#", "FF"), radix: 16));

  bool checkByRegExp(String regexp) {
    RegExp regex = RegExp(regexp);
    return regex.hasMatch(this);
  }

  String? get getHostByUrl {
    try {
      final uri = Uri.parse(this);
      return "${uri.scheme}://${uri.host}";
    } catch (error) {
      return null;
    }
  }

  String replaceUrl(String extHost) {
    if (!contains(extHost)) {
      Uri extUri = Uri.parse(extHost);
      Uri uri = Uri.parse(this);
      if (!uri.isScheme(extUri.scheme)) {
        uri = uri.replace(scheme: extUri.scheme);
      }
      if (uri.host != extUri.host) {
        uri = uri.replace(host: extUri.host);
      }
      return uri.toString();
    }
    return this;
  }
}
