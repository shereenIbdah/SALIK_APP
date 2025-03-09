import 'package:flutter/services.dart'; // For loading assets using rootBundle
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert'; // Required for JSON decoding

class GetServiceKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase.database',
    ];

    // Path to the service account JSON file in the assets folder
    String serviceAccountKeyPath = 'assets/salikapp.json';

    // Load the service account JSON file from the assets
    String serviceAccountJson =
        await rootBundle.loadString(serviceAccountKeyPath);

    // Decode the JSON content into a Map
    Map<String, dynamic> serviceAccountCredentialsJson =
        json.decode(serviceAccountJson);

    // Load the credentials from the JSON map
    final serviceAccountCredentials =
        ServiceAccountCredentials.fromJson(serviceAccountCredentialsJson);

    // Authenticate using the service account credentials
    final client =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);

    // Get the access token
    final accessToken = await client.credentials.accessToken.data;

    // Return the access token
    return accessToken;
  }
}
