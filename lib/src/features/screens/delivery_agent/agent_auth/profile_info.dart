import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics_express/src/custom_widgets/form_text_field.dart';
import 'package:logistics_express/src/custom_widgets/validators.dart';
import 'package:logistics_express/src/features/screens/delivery_agent/agent_auth/driving_licence.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  File? _selectedImage;
  String? _selectedGender;
  final TextEditingController _dobController = TextEditingController();

  void _takePicture() async {
    final imagePicker = ImagePicker();

    // Show bottom sheet modal to choose image source
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(FontAwesomeIcons.camera),
                title: const Text('Take Picture'),
                onTap: () async {
                  Navigator.of(ctx).pop(); // Close the modal

                  // Pick image from camera
                  final pickedImage = await imagePicker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 600,
                  );

                  if (pickedImage != null) {
                    setState(() {
                      _selectedImage = File(pickedImage.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.images),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(ctx).pop(); // Close the modal

                  // Pick image from gallery
                  final pickedImage = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 600,
                  );

                  if (pickedImage != null) {
                    setState(() {
                      _selectedImage = File(pickedImage.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}'; // Format date as DD/MM/YYYY
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Icon(
      FontAwesomeIcons.user,
      size: 130,
    );

    if (_selectedImage != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ClipOval(
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: const Text('Profile Info'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: content,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 15,
                    child: IconButton(
                      onPressed: _takePicture,
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        color: Theme.of(context).shadowColor,
                      ),
                      tooltip: 'Edit Image',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FormTextField(
                validator: (val) => Validators.validateName(val!),
                hintText: 'Enter Name',
                label: 'Full Name',
                icon: const Icon(FontAwesomeIcons.user),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              FormTextField(
                validator: (val) => Validators.validatePhone(val!),
                hintText: 'Enter Phone No.',
                label: 'Phone Number',
                icon: const Icon(FontAwesomeIcons.phone),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              FormTextField(
                // validator: (val) => Validators.validateName(val!),
                hintText: 'DD/MM/YYYY',
                label: 'Date of Birth',
                icon: const Icon(FontAwesomeIcons.solidCalendarDays),
                controller: _dobController,
                keyboardType: TextInputType.datetime,
                suffixIcon: IconButton(
                  onPressed: _pickDateOfBirth,
                  icon: Icon(FontAwesomeIcons.calendarDay),
                ),
              ),
              const SizedBox(height: 20),
              FormTextField(
                // validator: (val) => Validators.validateName(val!),
                hintText: 'Aadhar card No.',
                label: 'Enter Aadhar card No.',
                icon: const Icon(FontAwesomeIcons.idCard),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    dropdownColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    isExpanded: true,
                    hint: Text('Select Gender'),
                    value: _selectedGender,
                    items: [
                      DropdownMenuItem(
                        value: 'Male',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'Female',
                        child: Text('Female'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => DrivingLicence(),
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
