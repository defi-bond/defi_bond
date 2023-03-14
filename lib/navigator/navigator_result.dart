/// Navigator Result
/// ------------------------------------------------------------------------------------------------

class SPDNavigatorResult<T> {
  
  /// The return value of a route that has been popped from the stack.
  /// 
  /// 
  const SPDNavigatorResult({
    this.data,
    this.error,
  });

  /// The returned data.
  final T? data;
  
  /// The returned error.
  final dynamic error;

  /// Return `true` if the result contains [data].
  bool get hasData => data != null;
  
  /// Return `true` if the result contains an [error].
  bool get hasError => error != null;

  /// Return `true` if the result contains [data] or an [error].
  bool get hasResult => hasData || hasError;
}