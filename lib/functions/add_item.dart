import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'database_helper.dart';

class AddItemScreen extends StatefulWidget {
  final Function(String, String, int, double) addGlassCallback;
  final Map<String, dynamic>? existingGlass;

  const AddItemScreen({Key? key, required this.addGlassCallback, this.existingGlass}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breweryController = TextEditingController();
  final _commentController = TextEditingController();
  int _amount = 0;
  double _rating = 0.0;
  File? _image;
  List<String> _serveStyles = ['Tap', 'Bottle', 'Can', 'Taster'];
  Map<String, bool> _selectedServeStyles = {
    'Tap': false,
    'Bottle': false,
    'Can': false,
    'Taster': false,
  };
  List<String> _flavorProfiles = ['Hoppy', 'Sweet', 'Strong', 'Honey'];
  List<String> _selectedFlavors = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingGlass != null) {
      _nameController.text = widget.existingGlass!['name'];
      _breweryController.text = widget.existingGlass!['brewery'];
      _commentController.text = widget.existingGlass!['comment'] ?? '';
      _amount = widget.existingGlass!['amount'] ?? 0;
      _rating = widget.existingGlass!['rating'] ?? 0.0;
      _selectedServeStyles = {
        for (var style in _serveStyles) style: widget.existingGlass!['serve_style']?.contains(style) ?? false
      };
      _selectedFlavors = widget.existingGlass!['flavor_profile']?.split(', ') ?? [];
      if (widget.existingGlass!['image_path'] != null) {
        _image = File(widget.existingGlass!['image_path']);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breweryController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // Resize the image
        final File file = File(image.path);
        final img.Image decodedImage = img.decodeImage(await file.readAsBytes())!;
        final img.Image resizedImage = img.copyResize(decodedImage, width: 800);

        // Save the resized image
        final String resizedImagePath = image.path.replaceAll(".png", "_resized.png");
        final File resizedImageFile = File(resizedImagePath);
        resizedImageFile.writeAsBytesSync(img.encodePng(resizedImage));

        setState(() {
          _image = resizedImageFile;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _addServeStyle() {
    TextEditingController _styleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Serve Style"),
          content: TextField(
            controller: _styleController,
            decoration: InputDecoration(hintText: "Enter serve style"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  String style = _styleController.text;
                  if (style.isNotEmpty && !_serveStyles.contains(style)) {
                    _serveStyles.add(style);
                    _selectedServeStyles[style] = false;
                  }
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _addFlavorProfile() {
    TextEditingController _flavorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Flavor Profile"),
          content: TextField(
            controller: _flavorController,
            decoration: InputDecoration(hintText: "Enter flavor profile"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  String flavor = _flavorController.text;
                  if (flavor.isNotEmpty && !_flavorProfiles.contains(flavor)) {
                    _flavorProfiles.add(flavor);
                  }
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      final serveStyles = _selectedServeStyles.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      final glass = {
        'name': _nameController.text,
        'brewery': _breweryController.text,
        'comment': _commentController.text,
        'amount': _amount,
        'rating': _rating,
        'serve_style': serveStyles.join(', '),
        'flavor_profile': _selectedFlavors.join(', '),
        'image_path': _image?.path,
      };

      print('Before inserting/updating glass: $glass'); // Debugging statement

      if (widget.existingGlass != null) {
        glass['id'] = widget.existingGlass!['id'];
        await DatabaseHelper.instance.updateGlass(glass);
      } else {
        await DatabaseHelper.instance.insertGlass(glass);
      }

      print('After inserting/updating glass: $glass'); // Debugging statement

      widget.addGlassCallback(
        _nameController.text,
        _breweryController.text,
        _amount,
        _rating,
      );

      Navigator.pop(context); // Close the bottom sheet
    }
  }

  Future<void> _deleteItem() async {
    if (widget.existingGlass != null) {
      await DatabaseHelper.instance.deleteGlass(widget.existingGlass!['id']);
      Navigator.pop(context); // Close the bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glass addition'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.existingGlass != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteItem,
            ),
        ],
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
              Row(
                children: [
                  _image == null
                      ? Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
                        )
                      : Image.file(_image!, width: 80, height: 80, fit: BoxFit.cover),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            labelText: 'How was it? Leave a comment',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_amount > 0) _amount--;
                        });
                      },
                    ),
                    Text('$_amount'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _amount++;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('RATING', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _rating,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
                divisions: 50,
                label: _rating.toString(),
                min: 0.0,
                max: 5.0,
              ),
              SizedBox(height: 20),
              Text('SERVE STYLE', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: _serveStyles.map((style) {
                  return ChoiceChip(
                    label: Text(style),
                    selected: _selectedServeStyles[style]!,
                    onSelected: (selected) {
                      setState(() {
                        _selectedServeStyles[style] = selected;
                      });
                    },
                  );
                }).toList(),
              ),
              TextButton(
                onPressed: _addServeStyle,
                child: Text("Add Serve Style"),
              ),
              SizedBox(height: 20),
              Text('FLAVOR PROFILE', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: _flavorProfiles.map((flavor) {
                  return ChoiceChip(
                    label: Text(flavor),
                    selected: _selectedFlavors.contains(flavor),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedFlavors.add(flavor);
                        } else {
                          _selectedFlavors.remove(flavor);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              TextButton(
                onPressed: _addFlavorProfile,
                child: Text("Add Flavor Profile"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addItem,
                child: const Text('Check-in'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
