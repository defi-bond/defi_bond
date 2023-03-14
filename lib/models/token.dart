/// Token
/// ------------------------------------------------------------------------------------------------

enum SPDToken {
  
  solana('Solana', 'Solana', 'SOL'),
  stakePoolDrops('Stake Pool Drops', 'Stake Pool', 'SPD'),
  ;

  const SPDToken(this.label, this.shortLabel, this.symbol);

  final String label;

  final String shortLabel;

  final String symbol;
}