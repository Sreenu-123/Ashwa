import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String age;
  final String horseName;
  final String ridingLevel;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.age,
    required this.horseName,
    required this.ridingLevel,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ================= TEXT CONTROLLERS =================

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController ageController;
  late final TextEditingController horseController;

  // ================= RIDING LEVEL =================

  late String ridingLevel;

  // ================= PROFILE IMAGE =================

  XFile? selectedImage;

  // ================= INIT STATE =================

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);

    emailController = TextEditingController(text: widget.email);

    ageController = TextEditingController(text: widget.age);

    horseController = TextEditingController(text: widget.horseName);

    ridingLevel = widget.ridingLevel;
  }

  // ================= PICK PROFILE IMAGE =================

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    horseController.dispose();

    super.dispose();
  }

  // ================= SAVE PROFILE =================

  void saveProfile() {
    final updatedProfile = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'age': ageController.text.trim(),
      'horseName': horseController.text.trim(),
      'ridingLevel': ridingLevel,
      'profileImagePath': selectedImage?.path,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.blue,
      ),
    );

    Navigator.pop(context, updatedProfile);
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 21,
          ),
        ),

        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      // ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ================= PROFILE PICTURE =================
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 105,
                      height: 105,

                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        shape: BoxShape.circle,
                      ),

                      child: selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                File(selectedImage!.path),
                                width: 105,
                                height: 105,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: colorScheme.onSurface,
                              size: 58,
                            ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 2,

                      child: GestureDetector(
                        onTap: pickProfileImage,

                        child: Container(
                          width: 34,
                          height: 34,

                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,

                            border: Border.all(
                              color: colorScheme.surface,
                              width: 3,
                            ),
                          ),

                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: GestureDetector(
                  onTap: pickProfileImage,

                  child: const Text(
                    'Change Profile Photo',

                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ================= PERSONAL INFORMATION =================
              Text(
                'Personal Information',

                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ================= NAME =================
              profileField(
                controller: nameController,
                label: 'Name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 15),

              // ================= EMAIL =================
              profileField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 15),

              // ================= AGE =================
              profileField(
                controller: ageController,
                label: 'Age',
                icon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 28),

              // ================= RIDING INFORMATION =================
              Text(
                'Riding Information',

                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ================= RIDING LEVEL =================
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,

                  borderRadius: BorderRadius.circular(14),

                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),

                child: DropdownButtonFormField<String>(
                  initialValue: ridingLevel,

                  dropdownColor: colorScheme.surface,

                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: colorScheme.onSurfaceVariant,
                  ),

                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.trending_up,
                      color: Colors.blue,
                    ),

                    labelText: 'Riding Level',

                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),

                    border: InputBorder.none,

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 5,
                    ),
                  ),

                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),

                  items: const [
                    DropdownMenuItem(
                      value: 'Beginner',
                      child: Text('Beginner'),
                    ),

                    DropdownMenuItem(
                      value: 'Intermediate',
                      child: Text('Intermediate'),
                    ),

                    DropdownMenuItem(
                      value: 'Advanced',
                      child: Text('Advanced'),
                    ),

                    DropdownMenuItem(
                      value: 'Professional',
                      child: Text('Professional'),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        ridingLevel = value;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 15),

              // ================= HORSE NAME =================
              profileField(
                controller: horseController,
                label: 'Horse Name',
                icon: Icons.pets_outlined,
              ),

              const SizedBox(height: 35),

              // ================= SAVE BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: saveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Save Changes',

                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ================= CANCEL =================
              SizedBox(
                width: double.infinity,
                height: 50,

                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: Text(
                    'Cancel',

                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= PROFILE FIELD =================

  Widget profileField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      style: TextStyle(color: colorScheme.onSurface, fontSize: 16),

      cursorColor: Colors.blue,

      decoration: InputDecoration(
        labelText: label,

        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),

        prefixIcon: Icon(icon, color: Colors.blue),

        filled: true,

        fillColor: colorScheme.surfaceContainer,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    );
  }
}
