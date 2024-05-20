import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  final Function(String, String, int, double) addGlassCallback;

  const AddItemScreen({Key? key, required this.addGlassCallback}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breweryController = TextEditingController();
  final _amountController = TextEditingController();
  final _ratingController = TextEditingController();
  XFile? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _breweryController.dispose();
    _amountController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      widget.addGlassCallback(
        _nameController.text,
        _breweryController.text,
        int.parse(_amountController.text),
        double.parse(_ratingController.text),
      );

      Navigator.pop(context); // Close the bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name of the Glass',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name of the glass';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _breweryController,
              decoration: const InputDecoration(
                labelText: 'Brewery of the Glass',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the brewery';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount You Have',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ratingController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Rating',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a rating';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid rating';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _image == null
                ? ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Add a Photo'),
                  )
                : Column(
                    children: [
                      Image.network(_image!.path, width: 100, height: 100, fit: BoxFit.cover),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Change Photo'),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
