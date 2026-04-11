import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionState {
  const SubscriptionState({
    required this.selectedTier, // 'super'|'premium'
    required this.billingCycle, // 'monthly'|'quarterly'|'yearly'
  });

  final String selectedTier;
  final String billingCycle;

  SubscriptionState copyWith({
    String? selectedTier,
    String? billingCycle,
  }) {
    return SubscriptionState(
      selectedTier: selectedTier ?? this.selectedTier,
      billingCycle: billingCycle ?? this.billingCycle,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier()
      : super(const SubscriptionState(
            selectedTier: 'premium', billingCycle: 'monthly'));

  void selectTier(String tier) {
    state = state.copyWith(selectedTier: tier);
  }

  void selectBillingCycle(String billingCycle) {
    state = state.copyWith(billingCycle: billingCycle);
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  (ref) => SubscriptionNotifier(),
);
