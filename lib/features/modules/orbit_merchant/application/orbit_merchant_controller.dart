import 'dart:math';

import 'package:flutter/foundation.dart';

enum OrbitResource { ore, crystal, gas }

enum OrbitTradeAction { buy, sell }

class OrbitTurnLog {
  const OrbitTurnLog({
    required this.round,
    required this.resource,
    required this.action,
    required this.price,
    required this.cashAfterAction,
    required this.netWorthAfterAction,
  });

  final int round;
  final OrbitResource resource;
  final OrbitTradeAction action;
  final int price;
  final int cashAfterAction;
  final int netWorthAfterAction;
}

class OrbitMerchantState {
  const OrbitMerchantState({
    required this.round,
    required this.maxRounds,
    required this.cash,
    required this.cargo,
    required this.prices,
    required this.logs,
    required this.isFinished,
  });

  final int round;
  final int maxRounds;
  final int cash;
  final Map<OrbitResource, int> cargo;
  final Map<OrbitResource, int> prices;
  final List<OrbitTurnLog> logs;
  final bool isFinished;

  int netWorth() {
    var value = cash;
    for (final resource in OrbitResource.values) {
      value += (cargo[resource] ?? 0) * (prices[resource] ?? 0);
    }
    return value;
  }
}

class OrbitMerchantController extends ChangeNotifier {
  OrbitMerchantController()
    : _random = Random(67),
      _state = _buildInitialState(Random(67));

  static const int _maxRounds = 8;

  final Random _random;
  OrbitMerchantState _state;

  OrbitMerchantState get state => _state;

  static OrbitMerchantState _buildInitialState(Random random) {
    return OrbitMerchantState(
      round: 1,
      maxRounds: _maxRounds,
      cash: 24,
      cargo: {
        OrbitResource.ore: 0,
        OrbitResource.crystal: 0,
        OrbitResource.gas: 0,
      },
      prices: _buildRandomPrices(random),
      logs: const [],
      isFinished: false,
    );
  }

  static Map<OrbitResource, int> _buildRandomPrices(Random random) {
    return {
      OrbitResource.ore: 3 + random.nextInt(5),
      OrbitResource.crystal: 5 + random.nextInt(6),
      OrbitResource.gas: 4 + random.nextInt(5),
    };
  }

  void buy(OrbitResource resource) {
    if (_state.isFinished) {
      return;
    }
    final price = _state.prices[resource] ?? 0;
    if (_state.cash < price) {
      return;
    }
    final nextCash = _state.cash - price;
    final nextCargo = Map<OrbitResource, int>.from(_state.cargo);
    nextCargo[resource] = (nextCargo[resource] ?? 0) + 1;
    _advanceTurn(
      resource: resource,
      action: OrbitTradeAction.buy,
      price: price,
      cashAfterAction: nextCash,
      cargoAfterAction: nextCargo,
    );
  }

  void sell(OrbitResource resource) {
    if (_state.isFinished) {
      return;
    }
    final amount = _state.cargo[resource] ?? 0;
    if (amount <= 0) {
      return;
    }
    final price = _state.prices[resource] ?? 0;
    final nextCash = _state.cash + price;
    final nextCargo = Map<OrbitResource, int>.from(_state.cargo);
    nextCargo[resource] = amount - 1;
    _advanceTurn(
      resource: resource,
      action: OrbitTradeAction.sell,
      price: price,
      cashAfterAction: nextCash,
      cargoAfterAction: nextCargo,
    );
  }

  void reset() {
    final seed = _random.nextInt(999999);
    _state = _buildInitialState(Random(seed));
    notifyListeners();
  }

  void _advanceTurn({
    required OrbitResource resource,
    required OrbitTradeAction action,
    required int price,
    required int cashAfterAction,
    required Map<OrbitResource, int> cargoAfterAction,
  }) {
    final finished = _state.round >= _state.maxRounds;
    final nextPrices = finished
        ? _state.prices
        : _buildNextPrices(_state.prices);
    final nextState = OrbitMerchantState(
      round: finished ? _state.round : _state.round + 1,
      maxRounds: _state.maxRounds,
      cash: cashAfterAction,
      cargo: cargoAfterAction,
      prices: nextPrices,
      logs: const [],
      isFinished: finished,
    );

    final logs = [
      OrbitTurnLog(
        round: _state.round,
        resource: resource,
        action: action,
        price: price,
        cashAfterAction: cashAfterAction,
        netWorthAfterAction: nextState.netWorth(),
      ),
      ..._state.logs,
    ];

    _state = OrbitMerchantState(
      round: nextState.round,
      maxRounds: nextState.maxRounds,
      cash: nextState.cash,
      cargo: nextState.cargo,
      prices: nextState.prices,
      logs: logs,
      isFinished: nextState.isFinished,
    );
    notifyListeners();
  }

  Map<OrbitResource, int> _buildNextPrices(Map<OrbitResource, int> current) {
    final next = <OrbitResource, int>{};
    for (final resource in OrbitResource.values) {
      final currentPrice = current[resource] ?? 4;
      final delta = _random.nextInt(5) - 2;
      final nextPrice = (currentPrice + delta).clamp(2, 12);
      next[resource] = nextPrice;
    }
    return next;
  }
}
