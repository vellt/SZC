import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:szc/models/job_file.dart';
import 'package:szc/models/response_info.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:url_launcher/url_launcher.dart';

class Func {
  static Future<ResponseInfo> openWebsite(String url) async {
    return await launchUrl(Uri.parse(url)).then((value) => (value)
        ? ResponseInfo(
            status: true,
            title: 'Sikeresen megnyitva az oldal:',
            message: url,
            foregroundColor: Colors.white,
            backgroundColor: Colors.greenAccent,
          )
        : ResponseInfo(
            status: false,
            title: 'Nem lehet megnyitni az oldalt:',
            message: url,
            foregroundColor: Colors.white,
            backgroundColor: Colors.redAccent));
  }

  static Future<ResponseInfo> copyTextToTheClipBoard(String text) async {
    await FlutterClipboard.copy(text);
    return ResponseInfo(
      status: true,
      title: 'Sikeresen kimásolva:',
      message: text,
      backgroundColor: Colors.greenAccent,
      foregroundColor: Colors.white,
    );
  }

  static Future<ResponseInfo> downloadDocs(JobFile file) async {
    Uri googleUrl = Uri.parse(file.url);
    if (await launchUrl(googleUrl, mode: LaunchMode.externalApplication)) {
      return ResponseInfo(
        status: true,
        title: 'A letöltés elindítva',
        message: file.name,
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      );
    } else {
      return ResponseInfo(
        status: false,
        title: "Nem sikerült elindítani a letöltést:",
        message: file.name,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      );
    }
  }

  static Future<ResponseInfo> writeMail(
    String emailAddress,
    String title,
  ) async {
    String email = Uri.encodeComponent(emailAddress);
    String subject = Uri.encodeComponent("[Jelentkezés] - $title");
    String body = Uri.encodeComponent("Meghirdetett pozíció: $title"
        "\nNév:"
        "\nTelefon:"
        "\nLegkorábbi kezdés időpontja: "
        "\nÜzenet: ");
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail, mode: LaunchMode.externalApplication)) {
      return ResponseInfo(
        status: true,
        title: "Email",
        message: "Sikerült megnyini",
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      );
    } else {
      return ResponseInfo(
        status: false,
        title: "Hiba történt",
        message: "Nem sikerült megnyini az emailt",
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      );
    }
  }

  static Future<ResponseInfo> openMap(String location) async {
    List<GBSearchData> data = await GeocoderBuddy.query(location);
    if (data.isEmpty) {
      return ResponseInfo(
        status: false,
        title: "Nem sikerült megnyini az alábbi címet:",
        message: location,
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent,
      );
    } else {
      Uri googleUrl = Uri.parse(
          'https://www.google.com/maps/search/${location.replaceAll("/", "-")}/@${data[0].lat},${data[0].lon},100z/');
      if (!await launchUrl(googleUrl, mode: LaunchMode.externalApplication)) {
        return ResponseInfo(
          status: false,
          title: "Nem sikerült megnyini az alábbi címet:",
          message: location,
          foregroundColor: Colors.white,
          backgroundColor: Colors.redAccent,
        );
      }
      return ResponseInfo(
        status: true,
        title: "Sikerült megnyini az alábbi címet:",
        message: location,
        foregroundColor: Colors.white,
        backgroundColor: Colors.greenAccent,
      );
    }
  }
}
