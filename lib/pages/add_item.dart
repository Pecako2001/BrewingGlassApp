import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/pages/item_repos.dart'; // Make sure this is added to your pubspec.yaml

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breweryController = TextEditingController();
  final _amountController = TextEditingController();
  XFile? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _breweryController.dispose();
    _amountController.dispose();
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
      ItemRepository().addItem({
        'name': _nameController.text,
        'brewery': _breweryController.text,
        'amount': _amountController.text,
        'image': _image?.path
      });

      Navigator.pop(context);  // Optionally pop after adding an item
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
      ),
    );
  }
}