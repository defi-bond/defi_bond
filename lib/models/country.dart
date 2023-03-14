/// Imports
/// ------------------------------------------------------------------------------------------------

import 'country_code.dart';


/// Country
/// ------------------------------------------------------------------------------------------------

class SPDCountry {
  
  /// Defines a country's [name] and ISO/dial [code].
  const SPDCountry({
    required this.name, 
    required this.code, 
  });

  /// The country's name.
  final String name;

  /// The country's ISO 3166 alpha 2 code and dial code.
  final SPDCountryCode code;

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': code.iso,
      'dialCode': code.dial,
    };
  }
  
  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  factory SPDCountry.fromJson(Map<String, dynamic> json) {
    return SPDCountry(
      name: json['name'],
      code: SPDCountryCode(
        iso: json['isoCode'],
        dial: json['dialCode'],
      ),
    );
  }
}