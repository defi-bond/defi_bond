/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../icons/dream_drops_icons.dart';
import '../../layouts/grid.dart';
import '../../themes/colors/color.dart';
import '../../widgets/buttons/tertiary_button.dart';


/// Number Pad
/// ------------------------------------------------------------------------------------------------

class SPDNumberPad extends StatefulWidget {
  
  /// Basic number pad.
  const SPDNumberPad({
    super.key,
    this.onChanged,
    this.enabled = true,
    this.value,
  });

  final bool enabled;

  final void Function(String value)? onChanged;

  final String? value;

  @override
  State<SPDNumberPad> createState() => _SPDNumberPadState();
}


/// Number Pad State
/// ------------------------------------------------------------------------------------------------

class _SPDNumberPadState extends State<SPDNumberPad> {
  
  late String _value;

  String get _defaultValue => '0';

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? _defaultValue;
  }

  void _setValue(final String value) {
    _value = value;
    widget.onChanged?.call(value);
  }

  @override
  void didUpdateWidget(covariant final SPDNumberPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value ?? _defaultValue;
    }
  }

  Widget _key(final VoidCallback onPressed, final Widget child) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: SPDGrid.x2,
        maxHeight: SPDGrid.x8,
        minWidth: SPDGrid.x10,
        maxWidth: SPDGrid.x10,
      ),
      child: SPDTertiaryButton(
        style: SPDTertiaryButton.styleFrom(
          backgroundColor: SPDColor.shared.primary1,
        ),
        enabled: widget.enabled,
        onPressed: onPressed, 
        child: child,
      ),
    );
  }

  Widget _numberKey(final int number) {
    return _key(
      () {
        if (number == 0 && _value == '0') return;
        _setValue((_value == '0' ? '' : _value) + number.toString());
      },
      Text('$number'),
    );
  }

  Widget _periodKey() {
    return _key(
      () {
        if (!_value.contains('.')) {
          _setValue('$_value.');
        }
      }, 
      Text('.'),
    );
  }

  Widget _deleteKey() {
    return _key(
      () {
        if (_value.isNotEmpty) {
          _setValue(_value.length == 1 ? _defaultValue : _value.substring(0, _value.length - 1));
        }
      }, 
      Icon(
        SPDIcons.chevronleft,
        size: 13.0,
      ),
    );
  }

  Widget _buttonRow(final Widget button0, final Widget button1, final Widget button2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button0,
        button1,
        button2,
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        _buttonRow(_numberKey(1), _numberKey(2), _numberKey(3)),
        _buttonRow(_numberKey(4), _numberKey(5), _numberKey(6)),
        _buttonRow(_numberKey(7), _numberKey(8), _numberKey(9)),
        _buttonRow(_periodKey(), _numberKey(0), _deleteKey()),
      ],
    );
  }
}