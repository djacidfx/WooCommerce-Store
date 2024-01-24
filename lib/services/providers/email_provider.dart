import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:woocommerce/utils/print_to_console.dart';

class EmailProvider with ChangeNotifier {

  Future sendEmail({
    required String serviceId,
    required String templateId,
    required String userId,
    required Map<String, dynamic> parameters,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'https://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': parameters
      }),
    );
    printToConsole(response.body);
  }

}