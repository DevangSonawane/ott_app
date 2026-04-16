import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionState {
  const SubscriptionState({
    required this.selectedPlanId, // 'free'|'standard'|'premium'
    required this.billingCycle, // 'monthly'|'annual'
  });

  final String selectedPlanId;
  final String billingCycle;

  SubscriptionState copyWith({
    String? selectedPlanId,
    String? billingCycle,
  }) {
    return SubscriptionState(
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      billingCycle: billingCycle ?? this.billingCycle,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier()
      : super(const SubscriptionState(
            selectedPlanId: 'premium', billingCycle: 'monthly'));

  void selectPlan(String planId) {
    state = state.copyWith(selectedPlanId: planId);
  }

  void selectBillingCycle(String billingCycle) {
    state = state.copyWith(billingCycle: billingCycle);
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  (ref) => SubscriptionNotifier(),
);
