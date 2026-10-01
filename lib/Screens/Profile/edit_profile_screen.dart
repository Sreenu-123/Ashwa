import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/api_services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController ageController;
  late final TextEditingController horseController;

  // ============================================================
  // RIDING DATA
  // ============================================================

  String? ridingExperience;
  String? ridingLevel;
  String? discipline;
  String? primaryGoal;

  final List<String> ridingExperienceOptions = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5+ years',
  ];

  final List<String> ridingLevelOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  final List<String> disciplineOptions = [
    'Dressage',
    'Show Jumping',
    'Eventing',
    'Endurance',
    'Western',
    'General Riding',
  ];

  final List<String> primaryGoalOptions = [
    'Improve Riding Skills',
    'Competition',
    'Fitness',
    'Horse Training',
    'Learn New Skills',
    'General Riding',
  ];

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  XFile? selectedImage;

  String? currentImageUrl;

  // Cache-busting version.
  // Backend replaces the same image filename, so this forces
  // Flutter to request the latest image.
  int _profileImageVersion = DateTime.now().millisecondsSinceEpoch;

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = true;
  bool isSaving = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    ageController = TextEditingController();
    horseController = TextEditingController();

    loadProfile();
  }

  // ============================================================
  // LOAD CURRENT PROFILE
  // ============================================================

  Future<void> loadProfile() async {
    try {
      final user = await ApiService.getCurrentUser();

      if (!mounted) return;

      final image = user['profile_image']?.toString().trim();

      String? imageUrl;

      if (image != null && image.isNotEmpty) {
        if (image.startsWith('http://') || image.startsWith('https://')) {
          imageUrl = image;
        } else {
          imageUrl = '${ApiService.baseUrl}$image';
        }
      }

      setState(() {
        nameController.text = user['full_name']?.toString() ?? '';

        emailController.text = user['email']?.toString() ?? '';

        ageController.text = user['age']?.toString() ?? '';

        horseController.text = user['horse_name']?.toString() ?? '';

        ridingExperience = user['riding_experience']?.toString();

        ridingLevel = user['riding_level']?.toString();

        discipline = user['discipline']?.toString();

        primaryGoal = user['primary_goal']?.toString();

        currentImageUrl = imageUrl;

        // Generate a new cache-busting value every time
        // the profile is loaded.
        _profileImageVersion = DateTime.now().millisecondsSinceEpoch;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ============================================================
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> pickProfileImage() async {
    if (isSaving) return;

    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (image == null) {
        return;
      }

      /*
       * IMPORTANT
       *
       * iPhone photos can be HEIC/HEIF.
       *
       * Backend accepts:
       * JPG
       * PNG
       * WEBP
       *
       * So we always convert the selected image
       * into JPG before uploading.
       */

      final tempDirectory = await getTemporaryDirectory();

      final outputPath =
          '${tempDirectory.path}/ashwa_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final XFile? compressedImage =
          await FlutterImageCompress.compressAndGetFile(
            image.path,
            outputPath,
            format: CompressFormat.jpeg,
            quality: 85,
            minWidth: 800,
            minHeight: 800,
          );

      if (compressedImage == null) {
        throw Exception('Unable to process the selected image.');
      }

      if (!mounted) return;

      setState(() {
        selectedImage = compressedImage;
      });
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Unable to select image: '
        '${e.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> saveProfile() async {
    if (isSaving) return;

    FocusScope.of(context).unfocus();

    // ----------------------------------------------------------
    // VALUES
    // ----------------------------------------------------------

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final ageText = ageController.text.trim();
    final horseName = horseController.text.trim();

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (name.isEmpty) {
      _showMessage('Please enter your name.');
      return;
    }

    if (email.isEmpty) {
      _showMessage('Please enter your email.');
      return;
    }

    if (!email.contains('@')) {
      _showMessage('Please enter a valid email.');
      return;
    }

    if (ageText.isEmpty) {
      _showMessage('Please enter your age.');
      return;
    }

    final age = int.tryParse(ageText);

    if (age == null || age <= 0 || age > 120) {
      _showMessage('Please enter a valid age.');
      return;
    }

    if (ridingExperience == null || ridingExperience!.isEmpty) {
      _showMessage('Please select your riding experience.');
      return;
    }

    if (ridingLevel == null || ridingLevel!.isEmpty) {
      _showMessage('Please select your riding level.');
      return;
    }

    if (discipline == null || discipline!.isEmpty) {
      _showMessage('Please select your discipline.');
      return;
    }

    if (primaryGoal == null || primaryGoal!.isEmpty) {
      _showMessage('Please select your primary goal.');
      return;
    }

    if (horseName.isEmpty) {
      _showMessage('Please enter your horse name.');
      return;
    }

    // ----------------------------------------------------------
    // START SAVING
    // ----------------------------------------------------------

    setState(() {
      isSaving = true;
    });

    try {
      // ========================================================
      // UPDATE PROFILE DATA
      // ========================================================

      await ApiService.updateCurrentUser(
        fullName: name,
        email: email,
        age: age,
        ridingExperience: ridingExperience!,
        ridingLevel: ridingLevel!,
        discipline: discipline!,
        primaryGoal: primaryGoal!,
        horseName: horseName,
      );

      // ========================================================
      // UPLOAD PROFILE IMAGE
      // ========================================================

      if (selectedImage != null) {
        debugPrint('Uploading profile image: ${selectedImage!.path}');

        await ApiService.uploadProfileImage(imagePath: selectedImage!.path);

        debugPrint('Profile image uploaded successfully.');
      }

      // ========================================================
      // SUCCESS
      // ========================================================

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

      /*
       * true tells ProfileScreen to reload
       * the latest backend data.
       */

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

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
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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

      // ========================================================
      // APP BAR
      // ========================================================
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

      // ========================================================
      // BODY
      // ========================================================
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : SafeArea(
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
                                : _buildCurrentImage(colorScheme),
                          ),

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
                    sectionTitle(context, 'Personal Information'),

                    const SizedBox(height: 15),

                    profileField(
                      controller: nameController,
                      label: 'Name',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 15),

                    profileField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 15),

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
                    sectionTitle(context, 'Riding Information'),

                    const SizedBox(height: 15),

                    // RIDING EXPERIENCE
                    profileDropdown(
                      label: 'Riding Experience',
                      icon: Icons.history_edu_outlined,
                      value: ridingExperience,
                      items: ridingExperienceOptions,
                      onChanged: (value) {
                        setState(() {
                          ridingExperience = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // RIDING LEVEL
                    profileDropdown(
                      label: 'Riding Level',
                      icon: Icons.trending_up,
                      value: ridingLevel,
                      items: ridingLevelOptions,
                      onChanged: (value) {
                        setState(() {
                          ridingLevel = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // DISCIPLINE
                    profileDropdown(
                      label: 'Discipline',
                      icon: Icons.sports_score_outlined,
                      value: discipline,
                      items: disciplineOptions,
                      onChanged: (value) {
                        setState(() {
                          discipline = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // PRIMARY GOAL
                    profileDropdown(
                      label: 'Primary Goal',
                      icon: Icons.flag_outlined,
                      value: primaryGoal,
                      items: primaryGoalOptions,
                      onChanged: (value) {
                        setState(() {
                          primaryGoal = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // HORSE NAME
                    profileField(
                      controller: horseController,
                      label: 'Horse Name',
                      icon: Icons.pets_outlined,
                    ),

                    const SizedBox(height: 35),

                    // ==================================================
                    // SAVE
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.blue.withValues(
                            alpha: 0.5,
                          ),
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
                    // CANCEL
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
  // CURRENT PROFILE IMAGE
  // ============================================================

  Widget _buildCurrentImage(ColorScheme colorScheme) {
    if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
      final imageUrl = '$currentImageUrl?v=$_profileImageVersion';

      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 105,
          height: 105,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, color: colorScheme.onSurface, size: 58);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            );
          },
        ),
      );
    }

    return Icon(Icons.person, color: colorScheme.onSurface, size: 58);
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget sectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      title,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
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
      enabled: !isSaving,
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

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget profileDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    /*
     * Prevent DropdownButton from crashing
     * if backend contains an older value that
     * isn't currently in our options.
     */

    final validValue = items.contains(value) ? value : null;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: validValue,
        dropdownColor: colorScheme.surface,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: colorScheme.onSurfaceVariant,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 5,
          ),
        ),
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: isSaving ? null : onChanged,
      ),
    );
  }
}
