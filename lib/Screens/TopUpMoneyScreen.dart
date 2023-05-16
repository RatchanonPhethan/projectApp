import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TopUpMoneyScreen extends StatefulWidget {
  const TopUpMoneyScreen({super.key});

  @override
  State<TopUpMoneyScreen> createState() => _TopUpMoneyScreenState();
}

enum SingingCharacter { lafayette, jefferson }

class _TopUpMoneyScreenState extends State<TopUpMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    SingingCharacter? _character = SingingCharacter.lafayette;

    return Scaffold(
        body: Column(
      children: <Widget>[
        RadioListTile<SingingCharacter>(
          title: const Text('Lafayette'),
          value: SingingCharacter.lafayette,
          groupValue: _character,
          onChanged: (SingingCharacter? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<SingingCharacter>(
          title: const Text('Thomas Jefferson'),
          value: SingingCharacter.jefferson,
          groupValue: _character,
          onChanged: (SingingCharacter? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ],
    ));
  }
}
