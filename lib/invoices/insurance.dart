import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycargenie_2/home.dart';
import 'package:mycargenie_2/invoices/edit_insurance.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/settings/settings.dart';
import 'package:mycargenie_2/settings/settings_logics.dart';
import 'package:provider/provider.dart';
import '../utils/puzzle.dart';
import '../utils/boxes.dart';

class Insurance extends StatefulWidget {
  const Insurance({super.key});

  @override
  State<Insurance> createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  int? key;

  String _insurer = '';
  String _note = '';
  String? _totalPrice;
  DateTime? _startDate;
  DateTime? _endDate;
  String _dues = '1';

  final now = DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    final vehicleKey = Provider.of<VehicleProvider>(
      context,
      listen: false,
    ).vehicleToLoad;

    log('insuranceBox contains: ${insuranceBox.toMap().toString()}');

    List<dynamic> details = insuranceBox.keys.where((key) {
      final value = insuranceBox.get(key);
      return value != null && value['vehicleKey'] == vehicleKey;
    }).toList();

    log('details are: $details');

    if (details.isNotEmpty) {
      key = details.first;
      log('key is $key');
    } else {
      log('navigating to creation page in initState');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EditInsurance(editKey: null)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settingsProvider = context.read<SettingsProvider>();
    final currencySymbol = settingsProvider.currency;

    String? totalPriceString;
    String? startDateString;
    String? endDateString;

    final content = key == null
        ? SizedBox()
        : ValueListenableBuilder(
            valueListenable: insuranceBox.listenable(keys: [key]),
            builder: (context, box, _) {
              final e = box.get(key);

              _insurer = e['insurer'] ?? '';
              _note = e['note'] ?? '';
              _totalPrice = e['totalPrice']?.toString() ?? '';
              _startDate = e['startDate'] as DateTime;
              _endDate = e['endDate'] as DateTime;
              _dues = e['dues'];

              totalPriceString = _totalPrice != null
                  ? localizations.numCurrency(
                      parseShowedPrice(_totalPrice!),
                      currencySymbol!,
                    )
                  : null;

              startDateString = localizations.ggMmAaaa(
                _startDate!.day,
                _startDate!.month,
                _startDate!.year,
              );

              endDateString = localizations.ggMmAaaa(
                _endDate!.day,
                _endDate!.month,
                _endDate!.year,
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [Text(_insurer)],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(startDateString ?? ''),

                        SizedBox(width: 8),

                        Text(endDateString ?? ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [Expanded(child: Text(_note))],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(_dues),
                        SizedBox(width: 8),
                        Text(totalPriceString!),
                      ],
                    ),
                  ),

                  // Save or update button section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: buildAddButton(
                            context,
                            onPressed: () => navigateToPage(
                              context,
                              EditInsurance(editKey: key),
                            ),
                            text: localizations.editInsuranceDetails,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );

    return Scaffold(
      appBar: AppBar(
        title: Text('Assicurazione RCA'),
        leading: customBackButton(context),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(child: content),
      ),
    );
  }
}
