/// Country Code
/// ------------------------------------------------------------------------------------------------

class SPDCountryCode {
  
  /// Defines a country's [iso] and [dial] code.
  const SPDCountryCode({
    required this.iso, 
    required this.dial,
  });

  /// The ISO 3166 alpha 2 code (e.g. `GB`).
  final String iso;

  /// The dial code (e.g. `44`).
  final String dial;

  /// Return the [dial] code with a `+` prefix (e.g. `+44`).
  String get dialLabel {
    return '+$dial';
  }

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() {
    return {
      'iso': iso,
      'dial': dial,
    };
  }
  
  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  factory SPDCountryCode.fromJson(Map<String, dynamic> json) {
    return SPDCountryCode(
      iso: json['iso'],
      dial: json['dial'],
    );
  }

  /// Return the [iso] code followed by +[dial] code (e.g. `GB +44`).
  @override
  String toString() {
    return '$iso $dialLabel';
  }
}