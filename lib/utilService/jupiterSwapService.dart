import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solana/solana.dart';

class JupiterSwapService {
  final String baseUrl = 'https://quote-api.jup.ag';

  // Get a quote from Jupiter API
  Future<Map<String, dynamic>> getQuote({
    required String inputMint,
    required String outputMint,
    required String amount,
    required int slippageBps,
  }) async {
    final url = Uri.parse('$baseUrl/v6/quote?inputMint=$inputMint&outputMint=$outputMint&amount=$amount&slippageBps=$slippageBps');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load quote');
    }
  }

  // Execute a swap on Jupiter API
  Future<Map<String, dynamic>> executeSwap({
    required String route,
    required String userPublicKey,
    required String signature,
  }) async {
    final url = Uri.parse('$baseUrl/v4/swap');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "route": route,
        "userPublicKey": userPublicKey,
        "signature": signature,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Swap execution failed');
    }
  }
}