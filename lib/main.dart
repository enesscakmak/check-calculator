import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/TipCalculatorModel.dart';
import 'package:utip/widgets/bill_amount_field.dart';
import 'package:utip/widgets/person_counter.dart';
import 'package:utip/widgets/tip_row.dart';
import 'package:utip/widgets/tip_slider.dart';
import 'package:utip/widgets/total_per_person.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TipCalculatorModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UTip(),
    );
  }
}

class UTip extends StatefulWidget {
  const UTip({super.key});

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final model = Provider.of<TipCalculatorModel>(context);

    final style = theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary, fontWeight: FontWeight.bold);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bill Splitter'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TotalPerPerson(
                theme: theme, style: style, total: model.TotalPerPerson),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: theme.colorScheme.primary, width: 2)),
                child: Column(
                  children: [
                    BillAmountField(
                      billAmount: model.billTotal.toString(),
                      onChanged: (value) {
                        model.updateBillTotal(double.parse(value));
                      },
                    ),
                    //Split Bill Area
                    PersonCounter(
                      theme,
                      personCount: model.personCount,
                      onDecrement: () {
                        if (model.personCount > 1) {
                          model.updatePersonCount(model.personCount - 1);
                        }
                      },
                      onIncrement: () {
                        model.updatePersonCount(model.personCount + 1);
                      },
                      theme: theme,
                      // Add the missing onChanged argument
                    ),
                    // TİP SECTİON
                    TipRow(
                      theme: theme,
                      billTotal: model.billTotal,
                      percentage: model.tipPercentage,
                    ),
                    // Slider Text
                    Text("${(model.tipPercentage * 100).round()}%"),
                    // Tip Slider
                    TipSlider(
                      tipPercentage: model.tipPercentage,
                      onChanged: (double value) {
                        model.updateTipPercentage(value);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
