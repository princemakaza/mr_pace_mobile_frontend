import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/profile_management/controller/profile_controller.dart';
import 'package:mrpace/features/profile_management/helper/profile_helper.dart';
import 'package:mrpace/models/profile_model.dart';
import 'package:mrpace/widgets/custom_date_of_birth.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mrpace/widgets/loading_widgets/circular_loader.dart';

class ProfileScreen extends StatefulWidget {
  final String id;

  const ProfileScreen({super.key, required this.id});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = Get.find();
  final ProfileHelper _profileHelper = ProfileHelper();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nationalIdController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationshipController;

  String? _selectedGender;
  String? _selectedTShirtSize;
  File? _profileImage;
  String? _profileImageUrl;
  bool _isUploadingImage = false;
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> _genderOptions = ['male', 'female'];
  final List<String> _tShirtSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _nationalIdController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _addressController = TextEditingController();
    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _emergencyRelationshipController = TextEditingController();
  }

  Future<void> _loadProfileData() async {
    try {
      await _profileController.fetchProfileByUserId(widget.id);

      if (_profileController.profile.value != null) {
        _updateControllersFromProfile(_profileController.profile.value!);
      }
    } catch (e) {
      DevLogs.logError('Error loading profile data: $e');
      _showErrorSnackbar('Failed to load profile data');
    }
  }

  void _updateControllersFromProfile(ProfileModel profile) {
    if (!mounted) return;

    setState(() {
      _firstNameController.text = profile.firstName ?? '';
      _lastNameController.text = profile.lastName ?? '';
      _nationalIdController.text = profile.nationalId ?? '';
      _phoneNumberController.text = profile.phoneNumber ?? '';

      if (profile.dateOfBirth != null) {
        final dob = DateTime.parse(profile.dateOfBirth.toString());
        _dateOfBirthController.text =
            "${dob.day.toString().padLeft(2, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.year}";
      }

      _selectedGender = profile.gender;
      _selectedTShirtSize = profile.tShirtSize;
      _addressController.text = profile.address ?? '';
      _profileImageUrl = profile.profilePicture;

      if (profile.emergencyContact != null) {
        _emergencyNameController.text = profile.emergencyContact!.name ?? '';
        _emergencyPhoneController.text = profile.emergencyContact!.phone ?? '';
        _emergencyRelationshipController.text =
            profile.emergencyContact!.relationship ?? '';
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nationalIdController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationshipController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
          _isUploadingImage = true;
        });

        await _uploadImageToSupabase(File(image.path));
      }
    } catch (e) {
      _showErrorSnackbar('Error picking image: $e');
    }
  }

  Future<void> _uploadImageToSupabase(File imageFile) async {
    try {
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = 'profile_pictures/$fileName';

      await _supabaseClient.storage
          .from('care_app')
          .upload(filePath, imageFile);

      final String publicUrl = _supabaseClient.storage
          .from('care_app')
          .getPublicUrl(filePath);

      if (!mounted) return;
      setState(() {
        _profileImageUrl = publicUrl;
        _isUploadingImage = false;
      });

      _showSuccessSnackbar('Image uploaded successfully!');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploadingImage = false;
        _profileImage = null;
      });
      _showErrorSnackbar('Failed to upload image: $e');
    }
  }

  void _removeImage() {
    if (!mounted) return;
    setState(() {
      _profileImage = null;
      _profileImageUrl = null;
    });
  }

  void _toggleEditMode() {
    if (!mounted) return;
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (_isUploadingImage) {
      _showErrorSnackbar('Please wait for image upload to complete');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    DateTime? parsedDob;
    String? isoDob;
    if (_dateOfBirthController.text.isNotEmpty) {
      try {
        final parts = _dateOfBirthController.text.trim().split('-');
        if (parts.length == 3) {
          parsedDob = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          isoDob = parsedDob.toIso8601String();
        }
      } catch (e) {
        _showErrorSnackbar('Invalid date format');
        return;
      }
    }

    final profile = _profileController.profile.value!;
    final profileData = {
      "_id": profile.id,
      "userId": {
        "_id": widget.id,
        "userName": profile.userId?.userName ?? '',
        "email": profile.userId?.email ?? '',
      },
      "profilePicture": _profileImageUrl,
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "nationalId": _nationalIdController.text.trim(),
      "phoneNumber": _phoneNumberController.text.trim(),
      "dateOfBirth": isoDob,
      "tShirtSize": _selectedTShirtSize,
      "gender": _selectedGender,
      "address": _addressController.text.trim(),
      if (_emergencyNameController.text.isNotEmpty)
        "emergencyContact": {
          "name": _emergencyNameController.text.trim(),
          "phone": _emergencyPhoneController.text.trim(),
          "relationship": _emergencyRelationshipController.text.trim(),
        },
      "__v": 0,
    };

    try {
      final profileModel = ProfileModel.fromMap(profileData);
      final success = await _profileHelper.updateProfile(profileModel);

      if (success) {
        _toggleEditMode();
        // Refresh the profile data
        await _profileController.fetchProfileByUserId(widget.id);
        if (_profileController.profile.value != null) {
          _updateControllersFromProfile(_profileController.profile.value!);
        }
        _showSuccessSnackbar('Profile updated successfully!');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to save profile: ${e.toString()}');
      DevLogs.logError('Profile save error: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.errorColor),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Widget _buildProfileImageWidget() {
    return GestureDetector(
      onTap: _isEditing && !_isUploadingImage ? _pickImage : null,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _isUploadingImage ? Colors.red : AppColors.borderColor,
            width: 2,
          ),
          color: AppColors.cardColor,
        ),
        child: Stack(
          children: [
            if (_profileImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.file(
                  _profileImage!,
                  height: 116,
                  width: 116,
                  fit: BoxFit.cover,
                ),
              )
            else if (_profileImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  _profileImageUrl!,
                  height: 116,
                  width: 116,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.subtextColor,
                  ),
                ),
              )
            else
              Icon(Icons.person, size: 60, color: AppColors.subtextColor),

            if (_isUploadingImage)
              Container(
                height: 116,
                width: 116,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),

            if (_isEditing && _profileImageUrl != null && !_isUploadingImage)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.errorColor,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildViewModeAppBar() {
    return AppBar(
      title: Text(
        'My Profile',
        style: TextStyle(
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textColor),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _toggleEditMode,
          tooltip: 'Edit Profile',
        ),
      ],
    );
  }

  PreferredSizeWidget _buildEditModeAppBar() {
    return AppBar(
      title: Text(
        'Edit Profile',
        style: TextStyle(
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textColor),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Changes?'),
              content: const Text(
                'Are you sure you want to discard all changes?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _toggleEditMode();
                    if (_profileController.profile.value != null) {
                      _updateControllersFromProfile(
                        _profileController.profile.value!,
                      );
                    }
                  },
                  child: const Text('Discard'),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: _saveProfile,
          child: const Text(
            'Save',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _isEditing ? _buildEditModeAppBar() : _buildViewModeAppBar(),
      body: Obx(() {
        if (_profileController.isLoading.value &&
            _profileController.profile.value == null) {
          return const Center(child: CustomLoader(message: 'Loading Profile'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Text(
                        'Profile Picture',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileImageWidget(),
                      if (_isUploadingImage)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Uploading image...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Personal Information Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _firstNameController,
                        labelText: 'First Name',
                        prefixIcon: const Icon(Icons.person),
                        keyboardType: TextInputType.text,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _lastNameController,
                        labelText: 'Last Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        keyboardType: TextInputType.text,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _nationalIdController,
                        labelText: 'National ID',
                        prefixIcon: const Icon(Icons.credit_card),
                        keyboardType: TextInputType.text,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _phoneNumberController,
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                        keyboardType: TextInputType.phone,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      CustomDateOfBirthField(
                        controller: _dateOfBirthController,
                        labelText: 'Date of Birth',
                        prefixIcon: const Icon(Icons.calendar_today),
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      // Gender Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: const Icon(Icons.person_pin),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                        items: _genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender.capitalizeFirst ?? gender),
                          );
                        }).toList(),
                        onChanged: _isEditing
                            ? (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              }
                            : null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // T-Shirt Size Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedTShirtSize,
                        decoration: InputDecoration(
                          labelText: 'T-Shirt Size',
                          prefixIcon: const Icon(Icons.checkroom),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                        ),
                        items: _tShirtSizes.map((String size) {
                          return DropdownMenuItem<String>(
                            value: size,
                            child: Text(size),
                          );
                        }).toList(),
                        onChanged: _isEditing
                            ? (String? newValue) {
                                setState(() {
                                  _selectedTShirtSize = newValue;
                                });
                              }
                            : null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select T-shirt size';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _addressController,
                        labelText: 'Address',
                        prefixIcon: const Icon(Icons.location_on),
                        keyboardType: TextInputType.multiline,
                        enabled: _isEditing,
                      ),
                    ],
                  ),
                ),

                // Emergency Contact Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Contact',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Optional information',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.subtextColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emergencyNameController,
                        labelText: 'Emergency Contact Name',
                        prefixIcon: const Icon(Icons.contact_emergency),
                        keyboardType: TextInputType.text,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emergencyPhoneController,
                        labelText: 'Emergency Contact Phone',
                        prefixIcon: const Icon(Icons.phone_in_talk),
                        keyboardType: TextInputType.phone,
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emergencyRelationshipController,
                        labelText: 'Relationship',
                        prefixIcon: const Icon(Icons.family_restroom),
                        keyboardType: TextInputType.text,
                        enabled: _isEditing,
                      ),
                    ],
                  ),
                ),

                // Save Button (only in edit mode)
                if (_isEditing)
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.surfaceColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().scale(),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
