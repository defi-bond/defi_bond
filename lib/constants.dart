/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';


/// Constants
/// ------------------------------------------------------------------------------------------------

// Split
const double equityPercentage = 10.0;
const double stakePercentage = 10.0;
const double rewardsPercentage = 40.0;
const double jackpotPercentage = 40.0;

/// Stake Pool token's mint address.
final PublicKey mintAddress = PublicKey.fromBase58(
  '42teQKLTrk3o9YC9RKWdHwa9ZyiVEqs6XXvqr5bAw8zS',
);

/// Stake Pool's reserve account address.
final PublicKey reserveAddress = PublicKey.fromBase58(
  '459K6rLDFuHkHg4zL13NRF6aiPrJCfyDsdDzxY76FWzW',
);

/// Stake Pool's address.
final PublicKey stakePoolAddress = PublicKey.fromBase58(
  '6yv1MvTZqTXQRZ55zto4eyzmd9Up2KiUAqzucDn96c5G',
);

/// Stake Pool validator list address.
final PublicKey validatorListAddress = PublicKey.fromBase58(
  'W86Qzdds3S6eKVLgGGBqJHEXNw69LtCp3V2deFDVfea',
);

/// 
ProgramAddress associatedTokenAddress(
  final PublicKey wallet,
) => PublicKey.findAssociatedTokenAddress(
  wallet, 
  mintAddress,
);

/// Lotto Program's config account address.
final PublicKey configAddress = PublicKey.fromBase58(
  'NVPq3vFJHdqXaYarMiAP5tLfD7gZy8mbgEc3EC96bHg',
);

/// Lotto Program's draw authority.
final PublicKey drawAuthorityAddress = PublicKey.fromBase58(
  '7H78d7r7pQtrbeXJX8gz92WwrA3KQ5siBznsdWaNyubp',
);