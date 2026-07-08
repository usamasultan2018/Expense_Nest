import 'package:expense_tracker/core/components/app_app_bar.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/controller/currency_controller.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/color_scheme_tile.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/font_tile.dart';
import 'package:expense_tracker/features/dashboard/view/profile/appearance/widgets/theme_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppAppBar.title('Appearance', showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Personalization ──────────────────────────────────────────────
          Text(
            "PERSONALIZATION",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: const Column(
              children: [
                ThemeTile(),
                Divider(height: 1, indent: 72),
                ColorSchemeTile(),
                Divider(height: 1, indent: 72),
                FontTile(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Regional ─────────────────────────────────────────────────────
          Text(
            "REGIONAL",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Consumer<CurrencyController>(
              builder: (context, currency, _) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.currency_exchange_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    "Currency",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "${currency.flag}  ${currency.currencyCode} · ${currency.symbol}",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: () => _showCurrencyPicker(context, currency),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Currency Picker ───────────────────────────────────────────────────────

  void _showCurrencyPicker(BuildContext context, CurrencyController currency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CurrencyPickerSheet(currency: currency),
    );
  }
}

// ── Currency Picker Sheet ─────────────────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final CurrencyController currency;
  const _CurrencyPickerSheet({required this.currency});

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  String _query = '';

  List<Map<String, String>> get _filtered =>
      CurrencyController.supportedCurrencies.where((c) {
        final q = _query.toLowerCase();
        return c['name']!.toLowerCase().contains(q) ||
            c['code']!.toLowerCase().contains(q);
      }).toList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            "Select Currency",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Search by name or code…",
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected = c['code'] == widget.currency.currencyCode;

                return ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      c['flag']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(
                    c['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '${c['code']}  ·  ${c['symbol']}',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.teal,
                        )
                      : null,
                  onTap: () {
                    widget.currency.setCurrency(c['code']!);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
