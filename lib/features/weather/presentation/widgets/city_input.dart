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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'مثال: Tehran, London, Tokyo',
          labelText: 'نام شهر',
          prefixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _submit,
            tooltip: 'جستجو',
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _submit(),
      ),
    );
  }

  void _submit() {
    final cityName = _controller.text.trim();

    // Validation با SnackBar
    if (cityName.isEmpty) {
      _showError('لطفا نام شهر را وارد کنید');
      return;
    }

    if (cityName.length < 2) {
      _showError('نام شهر باید حداقل ۲ حرف باشد');
      return;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(cityName)) {
      _showError('لطفا نام شهر را به انگلیسی وارد کنید');
      return;
    }

    // ارسال به BLoC
    widget.onSubmit(cityName);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
