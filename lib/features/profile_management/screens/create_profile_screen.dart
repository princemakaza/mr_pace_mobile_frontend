import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mrpace/core/utils/logs.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/profile_management/helper/profile_helper.dart';
import 'package:mrpace/models/create_profile_model.dart';
import 'package:mrpace/widgets/custom_date_of_birth.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _bounceController;
  late AnimationController _rotateController;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();

  String? _selectedGender;
  String? _selectedTShirtSize;
  File? _profileImage;
  String? _profileImageUrl; // Store the Supabase URL
  bool _isUploadingImage = false; // Track upload state
  final ImagePicker _picker = ImagePicker();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  final List<String> _genderOptions = ['male', 'female'];
  final List<String> _tShirtSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Start animations
    _bounceController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotateController.dispose();
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
          _profileImageUrl = null; // Reset URL while uploading
        });

        // Upload to Supabase
        await _uploadImageToSupabase(File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  Future<void> _uploadImageToSupabase(File imageFile) async {
    try {
      // Generate unique filename
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = 'profile_pictures/$fileName';

      // Upload file to Supabase Storage
      await _supabaseClient.storage
          .from('care_app')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final String publicUrl = _supabaseClient.storage
          .from('care_app')
          .getPublicUrl(filePath);

      setState(() {
        _profileImageUrl = publicUrl;
        _isUploadingImage = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Image uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
        _profileImage = null; // Reset on error
      });
      DevLogs.logWarning("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
      _profileImageUrl = null;
      _isUploadingImage = false;
    });
  }

  void _saveProfile() async {
    if (_isUploadingImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please wait for image upload to complete'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    // Convert entered DOB (dd-MM-yyyy) → DateTime → ISO8601
    DateTime? parsedDob;
    String? isoDob;
    if (_dateOfBirthController.text.isNotEmpty) {
      try {
        final parts = _dateOfBirthController.text.trim().split(
          '-',
        ); // [15, 03, 2001]
        if (parts.length == 3) {
          parsedDob = DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
          isoDob = parsedDob.toIso8601String();
          print("✅ ISO Date: $isoDob"); // Debug print
        }
      } catch (e) {
        print("❌ Failed to parse DOB: $e");
      }
    }

    final profileData = {
      'userId': "688c49c5b93594ab91cb1d1f",
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'nationalId': _nationalIdController.text.trim(),
      'phoneNumber': _phoneNumberController.text.trim(),
      'dateOfBirth': isoDob, // ✅ save ISO string instead of raw input
      'gender': _selectedGender,
      'tShirtSize': _selectedTShirtSize,
      'address': _addressController.text.trim(),
      'profilePicture': _profileImageUrl,
      if (_emergencyNameController.text.isNotEmpty)
        'emergencyContact': {
          'name': _emergencyNameController.text.trim(),
          'phone': _emergencyPhoneController.text.trim(),
          'relationship': _emergencyRelationshipController.text.trim(),
        },
    };

    final profileModel = CreateProfileModel.fromMap(profileData);
    final success = await ProfileHelper().createProfile(profileModel);

    if (success) {
      Get.back();
      Get.snackbar(
        "Success",
        "Profile created successfully!",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: AppColors.primaryColor,
      );
    }
  }

  Widget _buildProfileImageWidget() {
    return GestureDetector(
      onTap: _isUploadingImage
          ? null
          : _pickImage, // Disable tap while uploading
      child: Container(
        height: 100,
        width: 100,
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
            // Background image (watermark effect during upload)
            if (_profileImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _isUploadingImage
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.transparent,
                    BlendMode.srcOver,
                  ),
                  child: Image.file(
                    _profileImage!,
                    height: 96,
                    width: 96,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Icon(Icons.camera_alt, size: 40, color: AppColors.subtextColor),

            // Loading indicator
            if (_isUploadingImage)
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),

            // Remove button (only show when image is uploaded and not uploading)
            if (_profileImageUrl != null && !_isUploadingImage)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.errorColor,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Create Profile',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated Pig Icon
              Container(
                height: 120,
                width: 120,
                margin: const EdgeInsets.only(bottom: 24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating background circle
                    Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor.withOpacity(0.3),
                                AppColors.secondaryColor.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        )
                        .animate(controller: _rotateController)
                        .rotate(duration: const Duration(seconds: 2)),

                    // Bouncing pig icon
                    Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/pig_icon.png', // Your pig icon asset
                            height: 60,
                            width: 60,
                            color: AppColors.surfaceColor,
                          ),
                        )
                        .animate(controller: _bounceController)
                        .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.1, 1.1),
                          duration: const Duration(milliseconds: 1500),
                        )
                        .then()
                        .shimmer(
                          duration: const Duration(milliseconds: 1000),
                          color: AppColors.accentColor.withOpacity(0.5),
                        ),
                  ],
                ),
              ),

              // Profile Picture Section
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    Text(
                      'Profile Picture (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                      labelText: 'First Name *',
                      focusedBorderColor: AppColors.primaryColor,

                      prefixIcon: const Icon(Icons.person),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _lastNameController,
                      labelText: 'Last Name *',
                      focusedBorderColor: AppColors.primaryColor,

                      prefixIcon: const Icon(Icons.person_outline),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _nationalIdController,
                      labelText: 'National ID *',
                      focusedBorderColor: AppColors.primaryColor,

                      prefixIcon: const Icon(Icons.credit_card),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _phoneNumberController,
                      labelText: 'Phone Number *',

                      focusedBorderColor: AppColors.primaryColor,

                      prefixIcon: const Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    CustomDateOfBirthField(
                      controller: _dateOfBirthController,
                      labelText: 'Date of Birth *',

                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(height: 16),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender *',
                        prefixIcon: const Icon(Icons.person_pin),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      items: _genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
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
                        labelText: 'T-Shirt Size *',
                        prefixIcon: const Icon(Icons.checkroom),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      items: _tShirtSizes.map((String size) {
                        return DropdownMenuItem<String>(
                          value: size,
                          child: Text(size),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTShirtSize = newValue;
                        });
                      },
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
                      labelText: 'Address *',
                      prefixIcon: const Icon(Icons.location_on),
                      keyboardType: TextInputType.multiline,
                      maxLength: 200,
                    ),
                  ],
                ),
              ),

              // Next of Kin/Emergency Contact Section
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
                      'Next of Kin Details (Optional)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Emergency contact information',
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
                      focusedBorderColor: AppColors.primaryColor,

                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _emergencyPhoneController,
                      focusedBorderColor: AppColors.primaryColor,

                      labelText: 'Emergency Contact Phone',
                      prefixIcon: const Icon(Icons.phone_in_talk),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _emergencyRelationshipController,
                      focusedBorderColor: AppColors.primaryColor,
                      labelText: 'Relationship',
                      prefixIcon: const Icon(Icons.family_restroom),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),

              // Create Profile Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isUploadingImage
                      ? null
                      : _saveProfile, // Disable when uploading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isUploadingImage
                        ? Colors.grey
                        : AppColors.primaryColor,
                    foregroundColor: AppColors.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isUploadingImage
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Uploading...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Create Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ).animate().scale(delay: const Duration(milliseconds: 500)),
            ],
          ),
        ),
      ),
    );
  }
}
