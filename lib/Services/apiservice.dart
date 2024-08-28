import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
// import '';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // GET request
  Future<http.Response> getRequest(BuildContext context, endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  // POST request
  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: headers ?? {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // PUT request (for updating)
  Future<http.Response> putRequest(String endpoint, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: headers ?? {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // DELETE request
  Future<http.Response> deleteRequest(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: headers);
    return _handleResponse(response);
  }

  // File upload (Multipart request)
  Future<http.Response> uploadFile(String endpoint, File file,
      {Map<String, String>? headers, Map<String, String>? fields}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final request = http.MultipartRequest('POST', url);

    if (headers != null) {
      request.headers.addAll(headers);
    }

    if (fields != null) {
      request.fields.addAll(fields);
    }

    final fileStream = http.ByteStream(file.openRead());
    final length = await file.length();
    final multipartFile = http.MultipartFile(
      'file', // Field name for the file in the request
      fileStream,
      length,
      filename: basename(file.path),
    );

    request.files.add(multipartFile);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  // Helper method to handle the response
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw HttpException(
          'Failed request with status: ${response.statusCode} - ${response.body}');
    }
  }
}
