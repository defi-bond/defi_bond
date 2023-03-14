/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../exceptions/exception.dart';
import '../providers/provider.dart';
import '../storage/storage_key.dart';


/// Price Info
/// ------------------------------------------------------------------------------------------------

class PriceInfo extends Serializable {

  const PriceInfo({
    required this.price,
  });

  final double price;

  factory PriceInfo.fromJson(final Map<String, dynamic> json) => PriceInfo(
    price: json['price'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'price': price,
  };
}


/// Price Provider
/// ------------------------------------------------------------------------------------------------

class PriceProvider extends SPLProvider<PriceInfo> {

  /// Price information provider.
  PriceProvider._();

  static final PriceProvider shared = PriceProvider._();

  @override
  String get storageKey => SPDStorageKey.priceInfo;
  
  @override
  PriceInfo Function(Map<String, dynamic>) get decoder => PriceInfo.fromJson;

  double get price => value?.price ?? 0.0;

  @override
  Future<PriceInfo> fetch(final SolanaWalletProvider provider) async {
    const String uriString = 'https://www.binance.com/api/v3/ticker/price?symbol=SOLBUSD';
    final http.Response response = await http.get(Uri.parse(uriString));
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    print('SOL Price $jsonResponse');
    final double? price = double.tryParse(jsonResponse["price"]);
    if (price == null) {
      throw const SPDException('Failed to load SOL price');
    }
    return PriceInfo(
      price: price,
    );
  }  
}