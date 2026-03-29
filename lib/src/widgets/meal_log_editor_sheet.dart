import 'package:carolie_tracking_app/src/domain/entities/meal_log.dart';
import 'package:flutter/material.dart';

Future<MealLogEditResult?> showMealLogEditorSheet(
  BuildContext context, {
  MealLog? mealLog,
  String? suggestedName,
  int? suggestedCalories,
  String? suggestedMealType,
  String? suggestedPortion,
  String? suggestedSource,
}) {
  return showModalBottomSheet<MealLogEditResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return MealLogEditorSheet(
        mealLog: mealLog,
        suggestedName: suggestedName,
        suggestedCalories: suggestedCalories,
        suggestedMealType: suggestedMealType,
        suggestedPortion: suggestedPortion,
        suggestedSource: suggestedSource,
      );
    },
  );
}

class MealLogEditResult {
  const MealLogEditResult({
    required this.mealName,
    required this.calories,
    required this.mealType,
    required this.portion,
    required this.source,
  });

  final String mealName;
  final int calories;
  final String mealType;
  final String portion;
  final String source;
}

class MealLogEditorSheet extends StatefulWidget {
  const MealLogEditorSheet({
    super.key,
    this.mealLog,
    this.suggestedName,
    this.suggestedCalories,
    this.suggestedMealType,
    this.suggestedPortion,
    this.suggestedSource,
  });

  final MealLog? mealLog;
  final String? suggestedName;
  final int? suggestedCalories;
  final String? suggestedMealType;
  final String? suggestedPortion;
  final String? suggestedSource;

  @override
  State<MealLogEditorSheet> createState() => _MealLogEditorSheetState();
}

class _MealLogEditorSheetState extends State<MealLogEditorSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _mealNameController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _mealTypeController;
  late final TextEditingController _portionController;
  late final TextEditingController _sourceController;

  @override
  void initState() {
    super.initState();
    _mealNameController = TextEditingController(
      text: widget.mealLog?.mealName ?? widget.suggestedName ?? '',
    );
    _caloriesController = TextEditingController(
      text: '${widget.mealLog?.calories ?? widget.suggestedCalories ?? 0}',
    );
    _mealTypeController = TextEditingController(
      text: widget.mealLog?.mealType ?? widget.suggestedMealType ?? 'Lunch',
    );
    _portionController = TextEditingController(
      text: widget.mealLog?.portion ?? widget.suggestedPortion ?? '1 serving',
    );
    _sourceController = TextEditingController(
      text: widget.mealLog?.source ?? widget.suggestedSource ?? 'manual',
    );
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _caloriesController.dispose();
    _mealTypeController.dispose();
    _portionController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset + 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mealLog == null ? 'Log meal' : 'Edit meal',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              const SizedBox(height: 20),
              _EditorField(
                controller: _mealNameController,
                label: 'Meal name',
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Enter a meal name';
                  }
                  return null;
                },
              ),
              _EditorField(
                controller: _caloriesController,
                label: 'Calories',
                keyboardType: TextInputType.number,
                validator: (value) {
                  final calories = int.tryParse(value ?? '');
                  if (calories == null || calories <= 0) {
                    return 'Enter valid calories';
                  }
                  return null;
                },
              ),
              _EditorField(
                controller: _mealTypeController,
                label: 'Meal type',
              ),
              _EditorField(
                controller: _portionController,
                label: 'Portion',
              ),
              _EditorField(
                controller: _sourceController,
                label: 'Source',
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(widget.mealLog == null ? 'Save meal' : 'Update meal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pop(
      MealLogEditResult(
        mealName: _mealNameController.text.trim(),
        calories: int.parse(_caloriesController.text.trim()),
        mealType: _mealTypeController.text.trim(),
        portion: _portionController.text.trim(),
        source: _sourceController.text.trim(),
      ),
    );
  }
}

class _EditorField extends StatelessWidget {
  const _EditorField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
