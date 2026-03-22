import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class _Plan {
  final String name;
  final String duration;
  final int price;
  final List<String> features;
  final bool popular;

  const _Plan({
    required this.name,
    required this.duration,
    required this.price,
    required this.features,
    this.popular = false,
  });
}

const _kPlans = [
  _Plan(
    name: 'Basic Plan',
    duration: '7 Days',
    price: 15,
    features: ['Unlimited Planning', 'Full Map Access', 'Smart AI Suggestions', 'Premium Features', 'Forum Access'],
  ),
  _Plan(
    name: 'Premium Plan',
    duration: '14 Days',
    price: 25,
    features: ['Unlimited Planning', 'Full Map Access', 'Smart AI Suggestions', 'Premium Features', 'Forum Access'],
    popular: true,
  ),
  _Plan(
    name: 'Pro Plan',
    duration: '30 Days',
    price: 39,
    features: ['Unlimited Planning', 'Full Map Access', 'Smart AI Suggestions', 'Premium Features', 'Forum Access'],
  ),
];

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  int _selectedPlan = 1; // 0=Basic, 1=Premium, 2=Pro
  bool _showPayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(_showPayment ? 'Payment Information' : 'Complete Your Purchase'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_showPayment) {
              setState(() => _showPayment = false);
            } else {
              context.canPop() ? context.pop() : context.go('/home');
            }
          },
        ),
      ),
      body: _showPayment
          ? _PaymentForm(
              price: _kPlans[_selectedPlan].price,
              onBack: () => setState(() => _showPayment = false),
            )
          : _PlanSelection(
              selectedPlan: _selectedPlan,
              onSelect: (i) => setState(() => _selectedPlan = i),
              onContinue: () => setState(() => _showPayment = true),
            ),
    );
  }
}

class _PlanSelection extends StatelessWidget {
  final int selectedPlan;
  final ValueChanged<int> onSelect;
  final VoidCallback onContinue;

  const _PlanSelection({
    required this.selectedPlan,
    required this.onSelect,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Text(
            'Choose a plan and unlock your personalized travel experience',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_kPlans.length, (i) {
                final plan = _kPlans[i];
                final isSelected = selectedPlan == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onSelect(i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppTheme.primary : AppTheme.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (plan.popular)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                              ),
                              child: const Text(
                                'Most Popular',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            )
                          else
                            const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  plan.duration,
                                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: AppTheme.textPrimary),
                                    children: [
                                      TextSpan(
                                        text: '\$${plan.price}',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' /trip',
                                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...plan.features.map(
                                  (f) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check, size: 13, color: AppTheme.primary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(f, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: isSelected
                                      ? ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Selected', style: TextStyle(fontSize: 12)),
                                        )
                                      : OutlinedButton(
                                          onPressed: () => onSelect(i),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Select Plan', style: TextStyle(fontSize: 12)),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onContinue,
              icon: const Icon(Icons.credit_card, size: 18),
              label: Text('Continue to Payment - \$${_kPlans[selectedPlan].price}'),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentForm extends StatefulWidget {
  final int price;
  final VoidCallback onBack;

  const _PaymentForm({required this.price, required this.onBack});

  @override
  State<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<_PaymentForm> {
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  void _completePurchase() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: AppTheme.success, size: 56),
              SizedBox(height: 12),
              Text('Purchase Successful!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Your plan is now active. Enjoy your trip!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // đóng dialog
                  context.pop(true);      // trả về true cho itinerary_screen
                },
                child: const Text('Go to Home'),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.credit_card, color: AppTheme.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Payment Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Card Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cardNumberCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '1234 5678 9012 3456'),
                    //validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Cardholder Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cardNameCtrl,
                    decoration: const InputDecoration(hintText: 'John Doe'),
                    //validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Expiry Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _expiryCtrl,
                              decoration: const InputDecoration(hintText: 'MM/YY'),
                              //validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CVV', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _cvvCtrl,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: const InputDecoration(hintText: '123'),
                              //validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock_outline, size: 16, color: AppTheme.textMuted),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your payment information is encrypted and secure',
                            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _completePurchase,
                    icon: const Icon(Icons.credit_card, size: 18),
                    label: Text('Complete Purchase - \$${widget.price}'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
