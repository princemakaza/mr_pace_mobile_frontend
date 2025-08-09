import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/submit_registration_model.dart';
import 'package:mrpace/widgets/custom_date_of_birth.dart';
import 'package:mrpace/widgets/text_fields/custom_text_field.dart';
import '../../../models/all_races_model.dart';
import '../../../widgets/loading_widgets/circular_loader.dart';
import '../helpers/registration_helper.dart';
import 'success_registraion.dart';

class RaceRegistrationDialog extends StatefulWidget {
  final AllRacesModel raceModel;
  const RaceRegistrationDialog({super.key, required this.raceModel});
  @override
  State<RaceRegistrationDialog> createState() => _RaceRegistrationDialogState();
}
class _RaceRegistrationDialogState extends State<RaceRegistrationDialog> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedGender;
  String? _selectedTShirtSize;
  String? _selectedRaceEvent;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _tShirtSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  final RaceRegistrationHelper raceRegistrationHelper =
      RaceRegistrationHelper();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Race Registration',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                    ).animate().fadeIn(duration: 300.ms),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: AppColors.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Race Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.raceModel.name ?? 'Race Name',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Event: ${_selectedRaceEvent ?? 'Select an event'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtextColor,
                      ),
                    ),
                    Text(
                      'Price: \$${widget.raceModel.registrationPrice ?? '0'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: -0.1, duration: 400.ms),

              const SizedBox(height: 24),

              // Personal Information Section
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Race Event Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRaceEvent,
                decoration: InputDecoration(
                  labelText: 'Race Event',
                  prefixIcon: Icon(
                    Icons.directions_run,
                    color: AppColors.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                items:
                    widget.raceModel.raceEvents?.map((RaceEvent event) {
                      return DropdownMenuItem<String>(
                        value: event.distanceRace,
                        child: Text(
                          '${event.distanceRace} (Limit: ${event.reachLimit})',
                        ),
                      );
                    }).toList() ??
                    [],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRaceEvent = newValue;
                  });
                },
              ).animate().slideX(begin: 0.1, duration: 800.ms),

              const SizedBox(height: 16),

              // First Name
              CustomTextField(
                prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                controller: _firstNameController,
                labelText: 'First Name',
              ).animate().slideX(begin: 0.1, duration: 400.ms),

              const SizedBox(height: 16),

              // Last Name
              CustomTextField(
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppColors.primaryColor,
                ),
                controller: _lastNameController,
                labelText: 'Last Name',
              ).animate().slideX(begin: 0.1, duration: 450.ms),

              const SizedBox(height: 16),

              // Date of Birth - Updated to use CustomDateOfBirthField
              CustomDateOfBirthField(
                controller: _dateOfBirthController,
                labelText: 'Date of Birth (DD-MM-YYYY)',
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                ),
              ).animate().slideX(begin: 0.1, duration: 500.ms),

              const SizedBox(height: 16),

              // National ID
              CustomTextField(
                prefixIcon: Icon(Icons.badge, color: AppColors.primaryColor),
                controller: _nationalIdController,
                labelText: 'National ID',
              ).animate().slideX(begin: 0.1, duration: 550.ms),

              const SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(
                    Icons.person_2,
                    color: AppColors.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
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
              ).animate().slideX(begin: 0.1, duration: 600.ms),

              const SizedBox(height: 16),

              // Phone Number
              CustomTextField(
                prefixIcon: Icon(Icons.phone, color: AppColors.primaryColor),
                controller: _phoneNumberController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ).animate().slideX(begin: 0.1, duration: 650.ms),

              const SizedBox(height: 16),

              // Email
              CustomTextField(
                prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                controller: _emailController,
                labelText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
              ).animate().slideX(begin: 0.1, duration: 700.ms),

              const SizedBox(height: 16),

              // T-Shirt Size Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTShirtSize,
                decoration: InputDecoration(
                  labelText: 'T-Shirt Size',
                  prefixIcon: Icon(
                    Icons.checkroom,
                    color: AppColors.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
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
              ).animate().slideX(begin: 0.1, duration: 750.ms),

              const SizedBox(height: 32),

              // Submit Button
              GestureDetector(
                onTap: () async {
                  final registrationModel = SubmitRegistrationModel(
                    userId: '688c49c5b93594ab91cb1d1f',
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    race: widget.raceModel.id ?? '',
                    raceName: widget.raceModel.name ?? '',
                    racePrice:
                        int.tryParse(
                          widget.raceModel.registrationPrice ?? '0',
                        ) ??
                        0,
                    raceEvent: _selectedRaceEvent ?? '',
                    dateOfBirth: _dateOfBirthController.text,
                    nationalId: _nationalIdController.text,
                    gender: _selectedGender ?? '',
                    phoneNumber: _phoneNumberController.text,
                    email: _emailController.text,
                    tShirtSize: _selectedTShirtSize ?? '',
                  );

                  await raceRegistrationHelper.submitRaceRegistration(
                    registrationModel,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Register for Race",
                      style: GoogleFonts.poppins(
                        color: AppColors.backgroundColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ).animate().scale(duration: 300.ms, delay: 850.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _nationalIdController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
