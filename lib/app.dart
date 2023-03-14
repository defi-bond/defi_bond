/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/layouts/grid.dart';
import 'package:stake_pool_lotto/layouts/padding.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
import 'package:stake_pool_lotto/widgets/buttons/primary_button.dart';
import 'package:stake_pool_lotto/widgets/buttons/secondary_button.dart';
import 'navigator/navigator_checkpoint.dart';
import 'providers/account_balance_provider.dart';
import 'providers/jackpot_provider.dart';
import 'providers/price_provider.dart';
import 'routes/route.dart';
import 'screens/scaffolds/app_scaffold.dart';
import 'storage/user_data_storage.dart';
import 'themes/theme.dart';
import 'widgets/indicators/circular_progress_indicator.dart';
import '../widgets/images/info_graphic.dart';


/// App
/// ------------------------------------------------------------------------------------------------

class SPDApp extends StatefulWidget {

  /// The application.
  const SPDApp({super.key});

  /// Create an instance of the class' state widget.
  @override
  SPDAppState createState() => SPDAppState();
}


/// App State
/// ------------------------------------------------------------------------------------------------

class SPDAppState extends State<SPDApp> {

  bool _initialized = false;

  late Future<void> _futureDependencies;

  late SPDNavigatorCheckpoint _navigatorCheckpoint;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _navigatorCheckpoint = SPDNavigatorCheckpoint(save: SPDRoute.shared.save);
    _futureDependencies = _initDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    JackpotProvider.shared.dispose();
    PriceProvider.shared.dispose();
    AccountBalanceProvider.shared.dispose();
  }

  Future<List> _initDependencies() {
    return Future.wait([
      SPDUserDataStorage.shared.initialise(), 
      SolanaWalletProvider.initialize(), 
    ]);
  }

  void _initView(final SolanaWalletProvider provider) {
    if (!_initialized) {
      _initialized = true;
      FlutterNativeSplash.remove();
      JackpotProvider.shared.initialize();
      PriceProvider.shared.initialize();
      AccountBalanceProvider.shared.initialize();
      provider.adapter.addListener(() => _onAuthorizedStateChanged(provider));
      JackpotProvider.shared.update(provider);
      PriceProvider.shared.update(provider);
      AccountBalanceProvider.shared.update(provider);
    }
  }

  void _onAuthorizedStateChanged(final SolanaWalletProvider provider) {
    AccountBalanceProvider.shared.update(provider).ignore();
  }

  Widget _futureBuilder(final BuildContext context, final AsyncSnapshot<void> snapshot) {

    if (snapshot.connectionState != ConnectionState.done) {
      return const SPDCircularProgressIndicator();
    }

    final ThemeData theme = SPDTheme.shared.apply(Brightness.dark);
    final Object? error = snapshot.error;
    if (error != null) {
      return MaterialApp(
        theme: theme,
        home: Scaffold(
          body: SPDInfoGraphic.error(
            error: error,
          ),
        ),
      );
    }

    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    _initView(provider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JackpotProvider.shared),
        ChangeNotifierProvider(create: (context) => PriceProvider.shared),
        ChangeNotifierProvider(create: (context) => AccountBalanceProvider.shared),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          extensions: [
            SolanaWalletThemeExtension(
              primaryButtonStyle: SPDPrimaryButton.defaultStyle(),
              secondaryButtonStyle: SPDSecondaryButton.defaultStyle(),
            ),
          ],
        ),
        initialRoute: SPDAppScaffold.routeName,
        onGenerateRoute: SPDRoute.shared.onGenerateRoute,
        onGenerateInitialRoutes: SPDRoute.shared.onGenerateInitialRoutes,
        navigatorObservers: [_navigatorCheckpoint, SPDAppScaffold.observer],
      ),
    );
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(final BuildContext context) {
    return SolanaWalletProvider.create(
      identity: AppIdentity(),
      cluster: Cluster.devnet,
      child: FutureBuilder(
        future: _futureDependencies,
        builder: _futureBuilder,
      )
    );
  }
}