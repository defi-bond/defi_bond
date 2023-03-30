/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart';
import 'instruction.dart';
import 'state.dart';


/// Stake Pool Lotto Program
/// ------------------------------------------------------------------------------------------------

class LottoProgram extends Program {

  /// Lotto program.
  LottoProgram._()
    : super(PublicKey.fromBase58('98iqnEfLWpWK69Yn7YAPnWvkCSZAUgkXeS4tciGjccHQ'));
  
  /// Internal singleton instance.
  static final LottoProgram _instance = LottoProgram._();

  /// The program id.
  static PublicKey get programId => _instance.publicKey;

  /// Find the program derived address of [seed].
  static ProgramAddress findPDA(final LottoSeed seed, { final PublicKey? config })
    => _instance.findAddress([(config ?? configAddress).toBytes(), utf8.encode(seed.name)]);

  /// Find the associated token address of [seed].
  static ProgramAddress findATA(final LottoSeed seed, { final PublicKey? config }) {
    final PublicKey pda = LottoProgram.findPDA(seed, config: config).publicKey;
    return PublicKey.findAssociatedTokenAddress(pda, mintAddress);
  }

  /// {@macro solana_web3.Program.findAddress}
  static ProgramAddress Function(List<List<int>>) get findProgramAddress => _instance.findAddress;

  /// {@macro solana_web3.Program.checkDeployed}
  static Future<void> Function(Connection) get checkProgramDeployed => _instance.checkDeployed;

  static TransactionInstruction create({
    required final PublicKey payer,
    required PublicKey config,
    required int configSpace,
    required ProgramAddress state,
    required int stateSpace,
    required ProgramAddress fee,
    required int feeSpace,
    required PublicKey feeATA,
    required ProgramAddress exclusionList,
    required int exclusionListSpace,
    required PublicKey exclusionListATA,
    required ProgramAddress equity,
    required int equitySpace,
    required PublicKey equityATA,
    required ProgramAddress treasury,
    required int treasurySpace,
    required PublicKey treasuryATA,
    required ProgramAddress jackpot,
    required int jackpotSpace,
    required PublicKey jackpotATA,
    required ProgramAddress stake,
    required int stakeSpace,
    required PublicKey stakeATA,
    required PublicKey tokenMint,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signer(payer),
      AccountMeta.signerAndWritable(config),
      AccountMeta.writable(state.publicKey),
      AccountMeta.writable(fee.publicKey),
      AccountMeta.writable(feeATA),
      AccountMeta.writable(exclusionList.publicKey),
      AccountMeta.writable(equity.publicKey),
      AccountMeta.writable(equityATA),
      AccountMeta.writable(treasury.publicKey),
      AccountMeta.writable(treasuryATA),
      AccountMeta.writable(jackpot.publicKey),
      AccountMeta.writable(jackpotATA),
      AccountMeta.writable(stake.publicKey),
      AccountMeta.writable(stakeATA),
      AccountMeta(tokenMint),
      AccountMeta(TokenProgram.programId),
      AccountMeta(AssociatedTokenProgram.programId),
      AccountMeta(SystemProgram.programId),
    ];
    final List<Iterable<u8>> data = [
      Buffer.fromUint32(configSpace),
      Buffer.fromUint8(state.bump),
      Buffer.fromUint32(stateSpace),
      Buffer.fromUint8(fee.bump),
      Buffer.fromUint32(feeSpace),
      Buffer.fromUint8(exclusionList.bump),
      Buffer.fromUint32(exclusionListSpace),
      Buffer.fromUint8(equity.bump),
      Buffer.fromUint32(equitySpace),
      Buffer.fromUint8(treasury.bump),
      Buffer.fromUint32(treasurySpace),
      Buffer.fromUint8(jackpot.bump),
      Buffer.fromUint32(jackpotSpace),
      Buffer.fromUint8(stake.bump),
      Buffer.fromUint32(stakeSpace),
    ];
    return _instance.createTransactionIntruction(
      LottoInstruction.create,
      keys: keys, 
      data: data,
    );
  }

  static TransactionInstruction initialize({
    required final PublicKey payer,
    required final PublicKey config,
    required final PublicKey drawAuthority,
    required final PublicKey tokenMint,
    required final ProgramAddress state,
    required final ProgramAddress fee,
    required final ProgramAddress exclusionList,
    required final int exclusionListCapacity,
    required final List<PublicKey> exclusionListAccounts,
    required final ProgramAddress equity,
    required final ProgramAddress treasury,
    required final ProgramAddress jackpot,
    required final ProgramAddress stake,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signer(payer),
      AccountMeta.signerAndWritable(config),
      AccountMeta.signer(drawAuthority),
      AccountMeta(tokenMint),
      AccountMeta.writable(state.publicKey),
      AccountMeta.writable(fee.publicKey),
      AccountMeta.writable(exclusionList.publicKey),
      AccountMeta.writable(equity.publicKey),
      AccountMeta.writable(treasury.publicKey),
      AccountMeta.writable(jackpot.publicKey),
      AccountMeta.writable(stake.publicKey),
      // AccountMeta(TokenProgram.programId),
      // AccountMeta(AssociatedTokenProgram.programId),
      // AccountMeta(SystemProgram.programId),
    ];
    final List<Iterable<u8>> data = [
      Buffer.fromUint8(state.bump),
      Buffer.fromUint8(fee.bump),
      Buffer.fromUint8(exclusionList.bump),
      Buffer.fromUint32(exclusionListCapacity),
      Buffer.fromUint32(exclusionListAccounts.length),
      Buffer.flatten(exclusionListAccounts.map((e) => e.toBytes()).toList(growable: false)),
      Buffer.fromUint8(equity.bump),
      Buffer.fromUint8(treasury.bump),
      Buffer.fromUint8(jackpot.bump),
      Buffer.fromUint8(stake.bump),
    ];
    return _instance.createTransactionIntruction(
      LottoInstruction.initialize,
      keys: keys, 
      data: data,
    );
  }

  static TransactionInstruction splitShares({
    required final PublicKey drawAuthority,
    required final PublicKey config,
    required final ProgramAddress feePDA,
    required final ProgramAddress feeATA,
    required final ProgramAddress equityPDA,
    required final ProgramAddress equityATA,
    required final ProgramAddress treasuryPDA,
    required final ProgramAddress treasuryATA,
    required final ProgramAddress jackpotPDA,
    required final ProgramAddress jackpotATA,
    required final ProgramAddress stakePDA,
    required final ProgramAddress stakeATA,
    required final PublicKey tokenMint,
    required final BigInt? amount,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signer(drawAuthority),
      AccountMeta(config),
      AccountMeta.writable(feePDA.publicKey),
      AccountMeta.writable(feeATA.publicKey),
      AccountMeta.writable(equityPDA.publicKey),
      AccountMeta.writable(equityATA.publicKey),
      AccountMeta.writable(treasuryPDA.publicKey),
      AccountMeta.writable(treasuryATA.publicKey),
      AccountMeta.writable(jackpotPDA.publicKey),
      AccountMeta.writable(jackpotATA.publicKey),
      AccountMeta.writable(stakePDA.publicKey),
      AccountMeta.writable(stakeATA.publicKey),
      AccountMeta(tokenMint),
      AccountMeta(TokenProgram.programId),
    ];
    final List<Iterable<u8>> data = [
      borsh.u64.option().encode(amount),
    ];
    return _instance.createTransactionIntruction(
      LottoInstruction.splitShares,
      keys: keys, 
      data: data,
    );
  }

  static TransactionInstruction draw({
    required final PublicKey drawAuthority,
    required final PublicKey config,
    required final ProgramAddress statePDA,
    required final ProgramAddress jackpotPDA,
    required final ProgramAddress jackpotATA,
    required final PublicKey receiver,
    required final PublicKey receiverATA,
    required final PublicKey draw,
    required final PublicKey tokenMint,
    required final BigInt receiverSeed,
    required final BigInt drawSeed,
  }) {
    final List<AccountMeta> keys = [
      AccountMeta.signer(drawAuthority),
      AccountMeta(config),
      AccountMeta.writable(statePDA.publicKey),
      AccountMeta.writable(jackpotPDA.publicKey),
      AccountMeta.writable(jackpotATA.publicKey),
      AccountMeta.writable(receiver),
      AccountMeta.writable(receiverATA),
      AccountMeta.writable(draw),
      AccountMeta(tokenMint),
      AccountMeta(TokenProgram.programId),
    ];
    final List<Iterable<u8>> data = [
      borsh.u64.encode(receiverSeed),
      borsh.u64.encode(drawSeed),
    ];
    return _instance.createTransactionIntruction(
      LottoInstruction.draw,
      keys: keys, 
      data: data,
    );
  }
}