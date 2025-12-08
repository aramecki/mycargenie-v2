// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:mycargenie_2/invoices/insurance.dart';
import 'package:mycargenie_2/l10n/app_localizations.dart';
import 'package:mycargenie_2/settings/currency_settings.dart';
import 'package:mycargenie_2/theme/icons.dart';
import 'package:mycargenie_2/utils/puzzle.dart';

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final content = ListView(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: insuranceIcon),
          title: Text(
            localizations.thirdPartyInsurance,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () => navigateToPage(context, Insurance()),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: taxIcon),
          title: Text(
            localizations.carTax,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Divider(height: 22),
        ListTile(
          leading: CircleAvatar(child: revisionIcon),
          title: Text(
            localizations.carInspection,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Divider(height: 22),
        Row(children: [Text(localizations.expiring)]),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(localizations.invoices)),
      body: content,
    );
  }
}

void navigateToPage(BuildContext context, dynamic screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}
