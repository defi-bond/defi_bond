/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:solana_wallet_provider/solana_wallet_provider.dart' show BorshSerializable;


/// Serializable Codec Mixin
/// ------------------------------------------------------------------------------------------------

class SPDSerializableCodec<T extends BorshSerializable> extends Codec<T, Iterable<int>> {
  
  const SPDSerializableCodec(this._decode);

  final T Function(Iterable<int>) _decode;

  @override
  Converter<Iterable<int>, T> get decoder => SPDSerializableDecoder(_decode);

  @override
  Converter<T, Iterable<int>> get encoder => const SPDSerializableEncoder();
}


/// Serializable Encoder
/// ------------------------------------------------------------------------------------------------

class SPDSerializableEncoder<T extends BorshSerializable> extends Converter<T, Iterable<int>> {

  const SPDSerializableEncoder();

  @override
  Iterable<int> convert(final T input) => input.serialize();
}


/// Serializable Decoder
/// ------------------------------------------------------------------------------------------------

class SPDSerializableDecoder<T extends BorshSerializable> extends Converter<Iterable<int>, T> {

  const SPDSerializableDecoder(this.decode);

  final T Function(Iterable<int>) decode;

  @override
  T convert(Iterable<int> input) => decode(input);
}