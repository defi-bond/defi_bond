/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart' show stakePoolAddress;
import 'utils.dart';


/// Deposit
/// ------------------------------------------------------------------------------------------------

/// Creates a deposit SOL instruction.
Future<InstructionData> depositSol({
  required final SolanaWalletProvider provider,
  required final Connection connection,
  required final PublicKey wallet,
  required final StakePool stakePool,
  required final ValidatorList validatorList,
  required final PublicKey tokenAccount,
  required final PublicKey withdrawAccount,
  required final BigInt amount,
}) async {
  final List<TransactionInstruction> instructions = [];

  // Map base-58 public keys.
  final PublicKey reserveStake = PublicKey.fromBase58(stakePool.reserveStake);
  final PublicKey managerFeeAccount = PublicKey.fromBase58(stakePool.managerFeeAccount);
  final PublicKey poolMint = PublicKey.fromBase58(stakePool.poolMint);

  // Fetch the user's `stake pool lotto` token account info.
  final TokenAccountInfo? tokenAccountInfo = await getTokenAccountInfo(
    connection, 
    tokenAccount, 
    poolMint,
  );

  // Create an associated token account for the pool's token.
  if (tokenAccountInfo == null) {
    instructions.add(
      AssociatedTokenProgram.create(
        tokenMint: poolMint, 
        associatedTokenAccount: tokenAccount, 
        associatedTokenAccountOwner: wallet, 
        fundingAccount: wallet,
      ),
    );
  }

  // Create a deposit SOL instruction.
  instructions.add(
    StakePoolProgram.depositSol(
      stakePoolAddress: stakePoolAddress, 
      withdrawAuthority: withdrawAccount, 
      reserveStake: reserveStake, 
      payer: wallet, 
      payerTokenAccount: tokenAccount, 
      feeAccount: managerFeeAccount, 
      referralFeeAccount: managerFeeAccount, 
      poolMint: poolMint, 
      lamports: amount,
    ),
  );

  return InstructionData(
    instructions: instructions,
  );
}