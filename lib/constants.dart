/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';


/// Constants
/// ------------------------------------------------------------------------------------------------

/// Animations.
const Duration animationDuration = const Duration(milliseconds: 250);

/// Stake Pool token's mint address.
final PublicKey mintAddress = PublicKey.fromBase58(
  'Ha1Hzyotk1S3y1MRkm917TioVmxgMGiBrjuSZrjDvYNj',
);

/// Stake Pool's reserve account address.
final PublicKey reserveAddress = PublicKey.fromBase58(
  '2Df5abYHyffKzeMWVZmDrjq5R1o3w7Asq15VXzLRZhgv',
);

/// Stake Pool's address.
final PublicKey stakePoolAddress = PublicKey.fromBase58(
  'E9qpGZUoDWnCp9eoFy8BQ8KNfrukVJPrm7VPC7JzMopU',
);

/// Stake Pool validator list address.
final PublicKey validatorListAddress = PublicKey.fromBase58(
  'FbFiR5kkUjoYdhtcGQLCWMsiZT7DBMvBX5pFbxQ459cv',
);

/// Get the associated token address of [wallet].
ProgramAddress associatedTokenAddress(final PublicKey wallet) 
  => PublicKey.findAssociatedTokenAddress(wallet, mintAddress);

/// Lotto Program's config account address.
final PublicKey configAddress = PublicKey.fromBase58(
  'FwYL2HMuzq5922MyTPXeRFEqq575eQpjYftmawXviCsH',
);

/// Lotto Program's draw authority.
final PublicKey drawAuthorityAddress = PublicKey.fromBase58(
  'CGSmazERpGT4wDz5tEUswnH4iVHZjTgJwTWf8WTBqwHF',
);