// lib/features/weather/presentation/widgets/city_input.dart
import 'package:flutter/material.dart';

class CityInput extends StatefulWidget {
  final Function(String) onSubmit;

  const CityInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<CityInput> createState() => _CityInputState();
}

class _CityInputState extends State<CityInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'مثال: Tehran',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: _submit,
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _submit(),
    );
  }

  void _submit() {
    final cityName = _controller.text.trim();
    if (cityName.isNotEmpty) {
      widget.onSubmit(cityName);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}