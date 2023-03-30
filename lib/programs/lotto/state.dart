/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';


/// Lotto Account Types
/// ------------------------------------------------------------------------------------------------

/// The types of program derived addresses managed by the Lotto program.
enum LottoAccountType {

  /// The type given to a new account that has not been initialized.
  uninitialized,
  
  /// The game's configurations/settings.
  config,

  /// The game's current state.
  state,
  
  /// A share in the staking rewards (e.g. jackpot).
  share,

  /// Stake pool's fee account.
  fee,

  /// A draw result.
  draw,

  /// Accounts excluded from winning the draw.
  exclusionList,
}


/// Lotto Seeds
/// ------------------------------------------------------------------------------------------------

/// The seeds of program derived addresses managed by the Lotto program.
enum LottoSeed {

    /// The current state.
    state,

    /// The Stake Pool's epoch fee.
    fee,

    /// The latest draw result.
    draw,
    
    /// Accounts excluded from winning the draw (e.g. program or partner accounts).
    exclusionList,

    /// The creator's share.
    equity,

    /// The treasury account.
    treasury,

    /// The jackpot.
    jackpot,

    /// The game's stake (locked).
    stake,
}


/// Lotto Account
/// ------------------------------------------------------------------------------------------------

abstract class LottoAccount extends BorshSerializable {
    
    /// A Lotto account (implemented by all account).
    const LottoAccount({
      required this.accountType,
    });
    
    /// The account type.
    final LottoAccountType accountType;
    
    /// True if the account has been initialized.
    bool get isInitialized => accountType != LottoAccountType.uninitialized;

    /// True if the account has been initialized with the expected [LottoAccountType].
    bool get isValid;
}


/// Lotto Program Account
/// ------------------------------------------------------------------------------------------------

abstract class LottoProgramAccount extends LottoAccount {

  /// A Lotto account owned by the program.
  const LottoProgramAccount({
    required super.accountType,
    required this.authority,
  });
  
  /// The account authorized to modify this account.
  final PublicKey authority;
}


/// Lotto Program Account
/// ------------------------------------------------------------------------------------------------

abstract class LottoProgramDerivedAccount extends LottoProgramAccount {

  /// A Lotto account owned by the program with a derived address.
  const LottoProgramDerivedAccount({
    required super.accountType,
    required super.authority,
    required this.bump,
  });

  /// The derived account's bump seed.
  final int bump;
}


/// Lotto Config
/// ------------------------------------------------------------------------------------------------

class LottoConfig extends LottoAccount {
  
  /// The configurations and settings.
  const LottoConfig({
    required super.accountType,
    required this.isActive,
    required this.epochsPerDraw,
    required this.maxRollover, 
    required this.oddsThresholdNumerator, 
    required this.oddsThresholdDenominator, 
    required this.drawAuthority, 
    required this.tokenMint, 
  }): assert(accountType == LottoAccountType.uninitialized 
      || accountType == LottoAccountType.config);

  /// Whether or not the game is active.
  final bool isActive;

  /// The minimum number of epochs required between draws.
  final int epochsPerDraw;

  /// The maximum number of consecutive rollovers before a winner must be chosen.
  final int maxRollover;

  /// The maximum odds of a single account expressed by the percentage (0-100)
  /// `(odds_threshold_numerator/odds_threshold_denominator)*100`.
  final int oddsThresholdNumerator;

  /// The maximum odds of a single account expressed by the percentage (0-100)
  /// `(odds_threshold_numerator/odds_threshold_denominator)*100`.
  final int oddsThresholdDenominator;
  
  /// The account authorized to run a draw.
  final PublicKey drawAuthority;

  /// The Stake Pool token's mint address.
  final PublicKey tokenMint;

  @override
  bool get isValid => accountType == LottoAccountType.config;

  @override
  BorshSchema get schema => codec.schema;
  
  static final codec = borsh.struct({
    'account_type': borsh.enumeration(LottoAccountType.values),
    'is_active': borsh.boolean,
    'epochs_per_draw': borsh.u8,
    'max_rollover': borsh.u8,
    'odds_threshold_numerator': borsh.u32,
    'odds_threshold_denominator': borsh.u32,
    'draw_authority': borsh.publicKey,
    'token_mint': borsh.publicKey,
  });

  factory LottoConfig.fromAccountInfo(final AccountInfo info) {
    final Uint8List buffer = base64.decode(info.binaryData[0]);
    return borsh.deserialize(codec.schema, buffer, LottoConfig.fromJson);
  }

  static LottoConfig? tryFromAccountInfo(final AccountInfo? info)
    => info != null ? LottoConfig.fromAccountInfo(info) : null;

  factory LottoConfig.fromJson(final Map<String, dynamic> json) => LottoConfig(
    accountType: json['account_type'], 
    isActive: json['is_active'],
    epochsPerDraw: json['epochs_per_draw'], 
    maxRollover: json['max_rollover'],
    oddsThresholdNumerator: json['odds_threshold_numerator'], 
    oddsThresholdDenominator: json['odds_threshold_denominator'], 
    drawAuthority: PublicKey.fromBase58(json['draw_authority']),
    tokenMint: PublicKey.fromBase58(json['token_mint']),
  );

  static LottoConfig? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LottoConfig.fromJson(json) : null;

  factory LottoConfig.empty() => LottoConfig(
    accountType: LottoAccountType.uninitialized, 
    isActive: false,
    epochsPerDraw: 0, 
    maxRollover: 0,
    oddsThresholdNumerator: 0, 
    oddsThresholdDenominator: 0,
    drawAuthority: PublicKey.zero(),
    tokenMint: PublicKey.zero(),
  );

  @override
  Map<String, dynamic> toJson() => {
    'account_type': accountType,
    'is_active': isActive,
    'epochs_per_draw': epochsPerDraw,
    'max_rollover': maxRollover,
    'odds_threshold_numerator': oddsThresholdNumerator,
    'odds_threshold_denominator': oddsThresholdDenominator,
    'draw_authority': drawAuthority.toBase58(),
    'token_mint': tokenMint.toBase58(),
  };
}


/// Lotto State
/// ------------------------------------------------------------------------------------------------

class LottoState extends LottoProgramDerivedAccount {

  /// The current state of the game.
  const LottoState({
    required super.accountType,
    required super.authority, 
    required super.bump, 
    required this.drawId,
    required this.rollover,
  }): assert(accountType == LottoAccountType.uninitialized 
      || accountType == LottoAccountType.state);

  /// The latest draw result.
  final BigInt drawId;

  /// The number of consecutive rollovers.
  final int rollover;

  @override
  bool get isValid => accountType == LottoAccountType.state;
  
  @override
  BorshSchema get schema => codec.schema;
  
  static final codec = borsh.struct({
    'account_type': borsh.enumeration(LottoAccountType.values),
    'authority': borsh.publicKey,
    'bump': borsh.u8,
    'draw_id': borsh.u64,
    'rollover': borsh.u8,
  });

  factory LottoState.fromAccountInfo(final AccountInfo info) {
    final Uint8List buffer = base64.decode(info.binaryData[0]);
    return borsh.deserialize(codec.schema, buffer, LottoState.fromJson);
  }

  factory LottoState.fromJson(final Map<String, dynamic> json) => LottoState(
    accountType: json['account_type'], 
    authority: PublicKey.fromBase58(json['authority']),
    bump: json['bump'], 
    drawId: json['draw_id'],
    rollover: json['rollover'],
  );

  static LottoState? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LottoState.fromJson(json) : null;

  factory LottoState.empty() => LottoState(
    accountType: LottoAccountType.uninitialized, 
    authority: PublicKey.zero(),
    bump: 0,
    drawId: BigInt.zero, 
    rollover: 0,
  );

  @override
  Map<String, dynamic> toJson() => {
    'account_type': accountType,
    'authority': authority.toBase58(),
    'bump': bump,
    'draw_id': drawId,
    'rollover': rollover,
  };
}


/// Lotto Share
/// ------------------------------------------------------------------------------------------------

class LottoShare extends LottoProgramDerivedAccount {

  /// An account that receives a share of the stake pool's rewards ([LottoFee]).
  const LottoShare({
    required super.accountType,
    required super.authority, 
    required super.bump, 
    required this.numerator,
    required this.denominator, 
  }): assert(accountType == LottoAccountType.uninitialized 
      || accountType == LottoAccountType.share);

  /// The rewards share expressed by the percentage (0-100) `(numerator/denominator)*100`.
  final int numerator;

  /// The rewards share expressed by the percentage (0-100) `(numerator/denominator)*100`.
  final int denominator;

  @override
  bool get isValid => accountType == LottoAccountType.share;
  
  @override
  BorshSchema get schema => codec.schema;
  
  static final codec = borsh.struct({
    'account_type': borsh.enumeration(LottoAccountType.values),
    'authority': borsh.publicKey,
    'bump': borsh.u8,
    'numerator': borsh.u32,
    'denominator': borsh.u32,
  });

  factory LottoShare.fromAccountInfo(final AccountInfo info) {
    final Uint8List buffer = base64.decode(info.binaryData[0]);
    return borsh.deserialize(codec.schema, buffer, LottoShare.fromJson);
  }

  factory LottoShare.fromJson(final Map<String, dynamic> json) => LottoShare(
    accountType: json['account_type'], 
    authority: PublicKey.fromBase58(json['authority']),
    bump: json['bump'], 
    numerator: json['numerator'],
    denominator: json['denominator'],
  );

  static LottoShare? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LottoShare.fromJson(json) : null;

  factory LottoShare.empty() => LottoShare(
    accountType: LottoAccountType.uninitialized, 
    authority: PublicKey.zero(), 
    bump: 0, 
    numerator: 0,
    denominator: 0,
  );

  @override
  Map<String, dynamic> toJson() => {
    'account_type': accountType,
    'authority': authority.toBase58(),
    'bump': bump,
    'numerator': numerator,
    'denominator': denominator,
  };
}


/// Lotto Draw
/// ------------------------------------------------------------------------------------------------

class LottoDraw extends LottoProgramAccount {
  
  /// A draw result.
  const LottoDraw({
    required super.accountType,
    required super.authority, 
    required this.id,
    required this.amount,
    required this.receiverSeed, 
    required this.receiver,
    required this.rollover,
    required this.slot,
    required this.epochStartTimestamp,
    required this.epoch,
    required this.unixTimestamp,
  }): assert(accountType == LottoAccountType.uninitialized 
      || accountType == LottoAccountType.draw);

  /// Unique id / sequence number.
  final BigInt id;

  /// The amount in lamports.
  final BigInt amount;

  /// The randomly generated value used to select the winner.
  final BigInt receiverSeed;

  /// The winning account.
  final PublicKey receiver;

  /// The rollover count at the time of this draw.
  final int rollover;

  /// The network/bank slot at which the draw took place.
  final BigInt slot;

  /// The timestamp of the first slot in `epoch`.
  final int epochStartTimestamp;

  /// The bank Epoch at which the draw took place.
  final BigInt epoch;

  /// The timestamp at which the draw took place.
  final int unixTimestamp;

  @override
  bool get isValid => accountType == LottoAccountType.draw;

  @override
  BorshSchema get schema => codec.schema;
  
  static final codec = borsh.struct({
    'account_type': borsh.enumeration(LottoAccountType.values),
    'authority': borsh.publicKey,
    'id': borsh.u64,
    'amount': borsh.u64,
    'receiver_seed': borsh.u64,
    'receiver': borsh.publicKey,
    'rollover': borsh.u8,
    'slot': borsh.u64,
    'epoch_start_timestamp': borsh.i64,
    'epoch': borsh.u64,
    'unix_timestamp': borsh.i64,
  });

  factory LottoDraw.fromAccountInfo(final AccountInfo info) {
    final Uint8List buffer = base64.decode(info.binaryData[0]);
    return borsh.deserialize(codec.schema, buffer, LottoDraw.fromJson);
  }

  static LottoDraw? tryFromAccountInfo(final AccountInfo? info) 
    => info != null ? LottoDraw.fromAccountInfo(info) : null;

  factory LottoDraw.fromJson(final Map<String, dynamic> json) => LottoDraw(
    accountType: json['account_type'], 
    authority: PublicKey.fromBase58(json['authority']),
    id: json['id'],
    amount: json['amount'],
    receiverSeed: json['receiver_seed'],
    receiver: json['receiver'],
    rollover: json['rollover'],
    slot: json['slot'],
    epochStartTimestamp: json['epoch_start_timestamp'],
    epoch: json['epoch'],
    unixTimestamp: json['unix_timestamp'],
  );

  static LottoDraw? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LottoDraw.fromJson(json) : null;

  factory LottoDraw.empty() => LottoDraw(
    accountType: LottoAccountType.uninitialized, 
    authority: PublicKey.zero(), 
    id: BigInt.zero,
    amount: BigInt.zero,
    receiverSeed: BigInt.zero,
    receiver: PublicKey.zero(),
    rollover: 0,
    slot: BigInt.zero,
    epochStartTimestamp: 0,
    epoch: BigInt.zero,
    unixTimestamp: 0,
  );
  
  @override
  Map<String, dynamic> toJson() => {
    'account_type': accountType,
    'authority': authority.toBase58(),
    'id': id,
    'amount': amount,
    'receiver_seed': receiverSeed,
    'receiver': receiver.toBase58(),
    'rollover': rollover,
    'slot': slot,
    'epoch_start_timestamp': epochStartTimestamp,
    'epoch': epoch,
    'unix_timestamp': unixTimestamp,
  };
}


/// Lotto Fee
/// ------------------------------------------------------------------------------------------------

class LottoFee extends LottoProgramDerivedAccount {

  /// The account that collects the Stake Pool's epoch fee.
  const LottoFee({
    required super.accountType,
    required super.authority, 
    required super.bump,
  }): assert(accountType == LottoAccountType.uninitialized 
      || accountType == LottoAccountType.fee);

  @override
  bool get isValid => accountType == LottoAccountType.fee;

  @override
  BorshSchema get schema => codec.schema;
  
  static final codec = borsh.struct({
    'account_type': borsh.enumeration(LottoAccountType.values),
    'authority': borsh.publicKey,
    'bump': borsh.u8,
  });

  factory LottoFee.fromAccountInfo(final AccountInfo info) {
    final Uint8List buffer = base64.decode(info.binaryData[0]);
    return borsh.deserialize(codec.schema, buffer, LottoFee.fromJson);
  }

  static LottoFee? tryFromAccountInfo(final AccountInfo? info) 
    => info != null ? LottoFee.fromAccountInfo(info) : null;

  factory LottoFee.fromJson(final Map<String, dynamic> json) => LottoFee(
    accountType: json['account_type'], 
    authority: PublicKey.fromBase58(json['authority']),
    bump: json['bump'], 
  );

  static LottoFee? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LottoFee.fromJson(json) : null;

  factory LottoFee.empty() => LottoFee(
    accountType: LottoAccountType.uninitialized, 
    authority: PublicKey.zero(),
    bump: 0, 
  );

  @override
  Map<String, dynamic> toJson() => {
    'account_type': accountType,
    'authority': authority.toBase58(),
    'bump': bump,
  };
}


/// Lotto Exclusion List
/// ------------------------------------------------------------------------------------------------

class LottoExclusionList extends LottoProgramDerivedAccount {

  /// A list of accounts that are ineligible to win the Lotto draw.
  const LottoExclusionList({
    required super.accountType,
    required super.authority, 
    required super.bump,
    required this.capacity,
    required this.accounts,
  }): assert(capacity >= 0 && capacity <= maxCapacity),
      assert(accountType == LottoAccountType.uninitialized 
        || accountType == LottoAccountType.exclusionList);

  static const int maxCapacity = 100;

  final int capacity;

  final List<PublicKey> accounts;

  @override
  bool get isValid => accountType == LottoAccountType.exclusionList;

  @override
  BorshSchema get schema => codec.schema;
  
  static final codec = borsh.struct({
    'account_type': borsh.enumeration(LottoAccountType.values),
    'authority': borsh.publicKey,
    'bump': borsh.u8,
    'capacity': borsh.u32,
    'accounts': borsh.vec(borsh.publicKey, maxCapacity),
  });

  factory LottoExclusionList.fromAccountInfo(final AccountInfo info) {
    final Uint8List buffer = base64.decode(info.binaryData[0]);
    return borsh.deserialize(codec.schema, buffer, LottoExclusionList.fromJson);
  }

  factory LottoExclusionList.fromJson(final Map<String, dynamic> json) => LottoExclusionList(
    accountType: json['account_type'], 
    authority: PublicKey.fromBase58(json['authority']),
    bump: json['bump'],  
    capacity: json['capacity'], 
    accounts: List.from(json['accounts']).map((e) => PublicKey.fromBase58(e)).toList(growable: false),
  );

  static LottoExclusionList? tryFromJson(final Map<String, dynamic>? json) 
    => json != null ? LottoExclusionList.fromJson(json) : null;

  factory LottoExclusionList.empty() => LottoExclusionList(
    accountType: LottoAccountType.uninitialized, 
    authority: PublicKey.zero(),
    bump: 0, 
    capacity: LottoExclusionList.maxCapacity,
    accounts: const [],
  );

  @override
  Map<String, dynamic> toJson() => {
    'account_type': accountType,
    'authority': authority.toBase58(),
    'bump': bump,
    'capacity': capacity,
    'accounts': accounts.map((e) => e.toBase58()),
  };
}