/// MAD201-01 Project 1
/// Darshilkumar Karkar - A00203357
/// API Service for Currency Conversion
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getConversionRate(
    String baseCurrency,
    String targetCurrency,
  ) async {
    final url = Uri.parse(
      'https://api.exchangerate-api.com/v4/latest/$baseCurrency',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates'][targetCurrency];
        return '1 $baseCurrency = $rate $targetCurrency';
      } else {
        return 'Failed to load rate';
      }
    } catch (error) {
      return 'Error: ${error.toString()}';
    }
  }
}
