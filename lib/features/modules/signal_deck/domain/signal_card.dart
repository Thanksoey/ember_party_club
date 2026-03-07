enum SignalSuit {
  ember,
  tide,
  spark,
}

enum SignalAbility {
  chain,
  counter,
  surge,
  anchor,
}

class SignalCard {
  const SignalCard({
    required this.id,
    required this.suit,
    required this.power,
    required this.ability,
  });

  final String id;
  final SignalSuit suit;
  final int power;
  final SignalAbility ability;
}
