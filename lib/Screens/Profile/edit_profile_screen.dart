import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_services.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String age;
  final String horseName;
  final String ridingLevel;
  final String? currentProfileImagePath;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.age,
    required this.horseName,
    required this.ridingLevel,
    this.currentProfileImagePath,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController ageController;
  late final TextEditingController horseController;

  // ============================================================
  // RIDING LEVEL
  // ============================================================

  late String ridingLevel;

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  XFile? selectedImage;

  // ============================================================
  // SAVE STATE
  // ============================================================

  bool isSaving = false;

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);

    emailController = TextEditingController(text: widget.email);

    ageController = TextEditingController(text: widget.age);

    horseController = TextEditingController(text: widget.horseName);

    ridingLevel = widget.ridingLevel;
  }

  // ============================================================
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      selectedImage = image;
    });
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> saveProfile() async {
    // ==========================================================
    // PREVENT MULTIPLE SAVE CLICKS
    // ==========================================================

    if (isSaving) {
      return;
    }

    // ==========================================================
    // GET VALUES
    // ==========================================================

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final ageText = ageController.text.trim();
    final horseName = horseController.text.trim();

    // ==========================================================
    // VALIDATION
    // ==========================================================

    if (name.isEmpty) {
      _showMessage('Please enter your name.');
      return;
    }

    if (email.isEmpty) {
      _showMessage('Please enter your email.');
      return;
    }

    if (ageText.isEmpty) {
      _showMessage('Please enter your age.');
      return;
    }

    final age = int.tryParse(ageText);

    if (age == null || age <= 0) {
      _showMessage('Please enter a valid age.');
      return;
    }

    if (horseName.isEmpty) {
      _showMessage('Please enter your horse name.');
      return;
    }

    // ==========================================================
    // START SAVING
    // ==========================================================

    setState(() {
      isSaving = true;
    });

    try {
      // ========================================================
      // GET CURRENT BACKEND USER
      // ========================================================
      //
      // We need the existing:
      // - riding_experience
      // - discipline
      // - primary_goal
      //
      // because this screen doesn't edit those fields.
      // ========================================================

      final currentUser = await ApiService.getCurrentUser();

      // ========================================================
      // UPDATE USER IN BACKEND
      // ========================================================

      final result = await ApiService.updateCurrentUser(
        fullName: name,
        email: email,
        age: age,
        ridingExperience: currentUser['riding_experience']?.toString() ?? '',
        ridingLevel: ridingLevel,
        discipline: currentUser['discipline']?.toString() ?? '',
        primaryGoal: currentUser['primary_goal']?.toString() ?? '',
        horseName: horseName,
      );

      // ========================================================
      // CHECK WIDGET
      // ========================================================

      if (!mounted) {
        return;
      }

      // ========================================================
      // SUCCESS MESSAGE
      // ========================================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      // ========================================================
      // RETURN UPDATED PROFILE TO PROFILE SCREEN
      // ========================================================

      final updatedProfile = {
        'name': result['user']?['full_name'] ?? name,
        'email': result['user']?['email'] ?? email,
        'age': (result['user']?['age'] ?? age).toString(),
        'horseName': result['user']?['horse_name'] ?? horseName,
        'ridingLevel': result['user']?['riding_level'] ?? ridingLevel,
        'profileImagePath': selectedImage?.path,
      };

      Navigator.pop(context, updatedProfile);
    } catch (e) {
      // ========================================================
      // ERROR
      // ========================================================

      if (!mounted) {
        return;
      }

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    horseController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        elevation: 0,

        leading: IconButton(
          onPressed: isSaving
              ? null
              : () {
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

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // PROFILE PHOTO
              // ==================================================

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
                          : _buildExistingImage(colorScheme),
                    ),

                    // ==========================================
                    // CAMERA BUTTON
                    // ==========================================
                    Positioned(
                      right: 0,
                      bottom: 2,
                      child: GestureDetector(
                        onTap: isSaving ? null : pickProfileImage,
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

              // ==================================================
              // CHANGE PHOTO
              // ==================================================
              Center(
                child: GestureDetector(
                  onTap: isSaving ? null : pickProfileImage,
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

              // ==================================================
              // PERSONAL INFORMATION
              // ==================================================
              Text(
                'Personal Information',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // NAME
              // ==================================================
              profileField(
                controller: nameController,
                label: 'Name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 15),

              // ==================================================
              // EMAIL
              // ==================================================
              profileField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 15),

              // ==================================================
              // AGE
              // ==================================================
              profileField(
                controller: ageController,
                label: 'Age',
                icon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 28),

              // ==================================================
              // RIDING INFORMATION
              // ==================================================
              Text(
                'Riding Information',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // RIDING LEVEL
              // ==================================================
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant),
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

                  onChanged: isSaving
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              ridingLevel = value;
                            });
                          }
                        },
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // HORSE NAME
              // ==================================================
              profileField(
                controller: horseController,
                label: 'Horse Name',
                icon: Icons.pets_outlined,
              ),

              const SizedBox(height: 35),

              // ==================================================
              // SAVE BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: isSaving ? null : saveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.blue.withValues(alpha: 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // CANCEL BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 50,

                child: TextButton(
                  onPressed: isSaving
                      ? null
                      : () {
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

  // ============================================================
  // EXISTING PROFILE IMAGE
  // ============================================================

  Widget _buildExistingImage(ColorScheme colorScheme) {
    final path = widget.currentProfileImagePath;

    if (path != null && path.isNotEmpty) {
      final file = File(path);

      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(file, width: 105, height: 105, fit: BoxFit.cover),
        );
      }
    }

    return Icon(Icons.person, color: colorScheme.onSurface, size: 58);
  }

  // ============================================================
  // PROFILE FIELD
  // ============================================================

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

      enabled: !isSaving,

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
