/// Token
/// ------------------------------------------------------------------------------------------------

enum SPDToken {
  
  solana('Solana', 'SOL'),
  drop('Dream Drop', 'DDT'),
  ;

  const SPDToken(this.name, this.symbol);

  final String name;

  final String symbol;
}