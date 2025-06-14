import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  final List<String> choices;
  final ValueChanged<String>? onSelected; // callback

  const Options({super.key, required this.choices, this.onSelected});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.choices.first;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      alignment: WrapAlignment.center,
      children: widget.choices.map((choice) {
        return ChoiceChip(
          label: Text(choice),
          avatar: Icon(
            choice == 'Image'
                ? Icons.image
                : choice == 'Audio'
                ? Icons.audiotrack
                : Icons.text_fields,
          ),
          selected: _selected == choice,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selected = choice;
                if (widget.onSelected != null) {
                  widget.onSelected!(choice); // notify parent
                }
              }
            });
          },
        );
      }).toList(),
    );
  }
}
