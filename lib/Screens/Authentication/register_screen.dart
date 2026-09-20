import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_services.dart';
import '../Authentication/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const RegisterScreen({super.key, required this.onThemeChanged});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController nameController = TextEditingController();
  final TextEditingController horseNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  final ImagePicker _imagePicker = ImagePicker();

  File? selectedProfileImage;

  // ============================================================
  // VARIABLES
  // ============================================================

  bool isChecked = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  String? selectedRidingExperience;
  String? selectedRidingLevel;
  String? selectedRidingDiscipline;
  String? selectedPrimaryGoal;

  // ============================================================
  // OPTIONS
  // ============================================================

  final List<String> ridingExperienceOptions = [
    'Less than 1 year',
    '1 - 3 years',
    '3 - 5 years',
    '5+ years',
  ];

  final List<String> ridingLevelOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  final List<String> ridingDisciplineOptions = [
    'Dressage',
    'Show Jumping',
    'Eventing',
    'Endurance',
    'Western Riding',
    'Leisure Riding',
    'Other',
  ];

  final List<String> primaryGoalOptions = [
    'Learn Horse Riding',
    'Improve Riding Skills',
    'Competition',
    'Fitness & Exercise',
    'Professional Career',
    'Recreational Riding',
  ];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    horseNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();

    super.dispose();
  }

  // ============================================================
  // PICK PROFILE PICTURE
  // ============================================================

  Future<void> pickProfileImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile == null) return;

      setState(() {
        selectedProfileImage = File(pickedFile.path);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to select profile picture.')),
      );
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> register() async {
    FocusScope.of(context).unfocus();

    // ------------------------------------------------------------
    // FORM VALIDATION
    // ------------------------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ------------------------------------------------------------
    // PROFILE IMAGE
    // ------------------------------------------------------------

    if (selectedProfileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile picture.')),
      );

      return;
    }

    // ------------------------------------------------------------
    // TERMS
    // ------------------------------------------------------------

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms & Conditions and Privacy Policy',
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // RIDING DETAILS
    // ------------------------------------------------------------

    if (selectedRidingExperience == null ||
        selectedRidingLevel == null ||
        selectedRidingDiscipline == null ||
        selectedPrimaryGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all riding details.')),
      );

      return;
    }

    // ------------------------------------------------------------
    // START LOADING
    // ------------------------------------------------------------

    setState(() {
      isLoading = true;
    });

    try {
      // ==========================================================
      // REGISTER THROUGH OUR FASTAPI BACKEND
      // ==========================================================

      final result = await ApiService.registerUser(
        fullName: nameController.text.trim(),
        horseName: horseNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        age: int.parse(ageController.text.trim()),
        ridingExperience: selectedRidingExperience!,
        ridingLevel: selectedRidingLevel!,
        discipline: selectedRidingDiscipline!,
        primaryGoal: selectedPrimaryGoal!,
      );

      if (!mounted) return;

      // ==========================================================
      // SUCCESS
      // ==========================================================

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ??
                'Account created successfully! Please login.',
          ),
        ),
      );

      // ==========================================================
      // GO TO LOGIN
      // ==========================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginScreen(onThemeChanged: widget.onThemeChanged),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final String message = e.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // HEADER
                // ========================================================

                const SizedBox(height: 20),

                Text(
                  'Create Account',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Create your ASHWA riding profile',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                // ========================================================
                // PROFILE PICTURE
                // ========================================================
                Center(
                  child: GestureDetector(
                    onTap: isLoading ? null : pickProfileImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.surfaceContainer,
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: selectedProfileImage != null
                                ? Image.file(
                                    selectedProfileImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.person_outline,
                                    size: 52,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 2,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'Add Profile Picture',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ========================================================
                // FULL NAME
                // ========================================================
                fieldLabel(context, 'Full Name'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration: inputDecoration(
                    context,
                    hintText: 'Enter your full name',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    if (value.trim().length < 2) {
                      return 'Please enter a valid name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // HORSE NAME
                // ========================================================
                fieldLabel(context, 'Horse Name'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: horseNameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration: inputDecoration(
                    context,
                    hintText: 'Enter your horse name',
                    icon: Icons.pets_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your horse name';
                    }

                    if (value.trim().length < 2) {
                      return 'Please enter a valid horse name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // EMAIL
                // ========================================================
                fieldLabel(context, 'Email'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration: inputDecoration(
                    context,
                    hintText: 'Enter your email',
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // PASSWORD
                // ========================================================
                fieldLabel(context, 'Password'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration:
                      inputDecoration(
                        context,
                        hintText: 'Create a password',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // CONFIRM PASSWORD
                // ========================================================
                fieldLabel(context, 'Confirm Password'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration:
                      inputDecoration(
                        context,
                        hintText: 'Confirm your password',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // AGE
                // ========================================================
                fieldLabel(context, 'Age'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                  decoration: inputDecoration(
                    context,
                    hintText: 'Enter your age',
                    icon: Icons.cake_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your age';
                    }

                    final age = int.tryParse(value.trim());

                    if (age == null) {
                      return 'Please enter a valid age';
                    }

                    if (age < 5 || age > 100) {
                      return 'Please enter a valid age';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // RIDING EXPERIENCE
                // ========================================================
                fieldLabel(context, 'Riding Experience'),

                const SizedBox(height: 8),

                dropdownField(
                  context: context,
                  value: selectedRidingExperience,
                  hintText: 'Select your riding experience',
                  icon: Icons.history_outlined,
                  items: ridingExperienceOptions,
                  onChanged: (value) {
                    setState(() {
                      selectedRidingExperience = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // RIDING LEVEL
                // ========================================================
                fieldLabel(context, 'Riding Level'),

                const SizedBox(height: 8),

                dropdownField(
                  context: context,
                  value: selectedRidingLevel,
                  hintText: 'Select your riding level',
                  icon: Icons.trending_up_outlined,
                  items: ridingLevelOptions,
                  onChanged: (value) {
                    setState(() {
                      selectedRidingLevel = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // RIDING DISCIPLINE
                // ========================================================
                fieldLabel(context, 'Riding Discipline'),

                const SizedBox(height: 8),

                dropdownField(
                  context: context,
                  value: selectedRidingDiscipline,
                  hintText: 'Select your riding discipline',
                  icon: Icons.sports_outlined,
                  items: ridingDisciplineOptions,
                  onChanged: (value) {
                    setState(() {
                      selectedRidingDiscipline = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ========================================================
                // PRIMARY RIDING GOAL
                // ========================================================
                fieldLabel(context, 'Primary Riding Goal'),

                const SizedBox(height: 8),

                dropdownField(
                  context: context,
                  value: selectedPrimaryGoal,
                  hintText: 'Select your primary goal',
                  icon: Icons.flag_outlined,
                  items: primaryGoalOptions,
                  onChanged: (value) {
                    setState(() {
                      selectedPrimaryGoal = value;
                    });
                  },
                ),

                const SizedBox(height: 18),

                // ========================================================
                // TERMS
                // ========================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'I agree to the Terms & Conditions and Privacy Policy',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ========================================================
                // CREATE ACCOUNT BUTTON
                // ========================================================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.blue.withValues(
                        alpha: 0.5,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                // ========================================================
                // OR DIVIDER
                // ========================================================
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  ],
                ),

                const SizedBox(height: 14),

                // ========================================================
                // BACK TO LOGIN
                // ========================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                    onThemeChanged: widget.onThemeChanged,
                                  ),
                                ),
                              );
                            },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN FIELD
  // ============================================================

  Widget dropdownField({
    required BuildContext context,
    required String? value,
    required String hintText,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
      decoration: inputDecoration(context, hintText: hintText, icon: icon),
      dropdownColor: colorScheme.surface,
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget fieldLabel(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      label,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration(
    BuildContext context, {
    required String hintText,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant),
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
