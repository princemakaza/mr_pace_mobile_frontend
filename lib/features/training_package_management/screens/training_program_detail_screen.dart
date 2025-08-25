import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:mrpace/core/utils/pallete.dart' show AppColors;
import 'package:mrpace/models/training_bought_package_model.dart';

class TrainingProgramDetailScreen extends StatefulWidget {
  final TrainingPackageBoughtModel trainingPackage;

  const TrainingProgramDetailScreen({Key? key, required this.trainingPackage})
    : super(key: key);

  @override
  State<TrainingProgramDetailScreen> createState() =>
      _TrainingProgramDetailScreenState();
}

class _TrainingProgramDetailScreenState
    extends State<TrainingProgramDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedTabIndex = 0;
  int _currentGalleryIndex = 0;
  bool _isGalleryOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync:
          this, // Using SingleTickerProviderStateMixin as vsync :cite[1]:cite[10]
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Properly disposing the controller :cite[1]:cite[10]
    super.dispose();
  }

  void _openGallery(int index, List<String> images) {
    setState(() {
      _currentGalleryIndex = index;
    });

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black87),
            pageController: PageController(initialPage: index),
            onPageChanged: (index) {
              setState(() {
                _currentGalleryIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final program = widget.trainingPackage.trainingProgramPackageId;
    if (program == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Text(
            'Training program not found',
            style: TextStyle(color: AppColors.textColor, fontSize: 14),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(program),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildHeaderSection(program),
                  _buildTabSection(),
                  _buildTabContent(program),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(TrainingProgramPackageId program) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (program.coverImage != null)
              GestureDetector(
                onTap: () => _openGallery(0, [program.coverImage!]),
                child: _buildNetworkImage(
                  program.coverImage!,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(TrainingProgramPackageId program) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title ?? 'Training Program',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coach: ${program.coach ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.subtextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPriceCard(program),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCards(program),
        ],
      ),
    );
  }

  Widget _buildPriceCard(TrainingProgramPackageId program) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (program.regularPrice != null &&
              program.regularPrice! > (program.price ?? 0))
            Text(
              '\$${program.regularPrice!.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          Text(
            '\$${(program.price ?? 0).toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(TrainingProgramPackageId program) {
    return Row(
      children: [
        _buildInfoCard(
          Icons.calendar_today,
          '${program.durationInWeeks ?? 0} weeks',
          AppColors.secondaryColor,
        ),
        const SizedBox(width: 12),
        _buildInfoCard(
          Icons.fitness_center,
          program.difficultyLevel ?? 'Unknown',
          AppColors.accentColor,
        ),
        const SizedBox(width: 12),
        _buildInfoCard(
          Icons.directions_run,
          program.targetRaceType ?? 'General',
          AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    final tabs = ['Overview', 'Workouts', 'Progress'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTabIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.subtextColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(TrainingProgramPackageId program) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab(program);
      case 1:
        return _buildWorkoutsTab(program);
      case 2:
        return _buildProgressTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOverviewTab(TrainingProgramPackageId program) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Description',
            program.description ?? 'No description available',
            Icons.description,
          ),
          const SizedBox(height: 12),
          _buildSectionCard(
            'Coach Biography',
            program.coachBiography ?? 'No biography available',
            Icons.person,
          ),
          const SizedBox(height: 12),
          if (program.galleryImages?.isNotEmpty == true)
            _buildGallerySection(program),
          const SizedBox(height: 12),
          _buildPurchaseInfo(),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.subtextColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(TrainingProgramPackageId program) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.photo_library, size: 16, color: AppColors.primaryColor),
            SizedBox(width: 6),
            Text(
              'Gallery',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: program.galleryImages!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _openGallery(index, program.galleryImages!),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildNetworkImage(
                      program.galleryImages![index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutsTab(TrainingProgramPackageId program) {
    final dailyTrainings = program.dailyTrainings ?? [];

    if (dailyTrainings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'No workouts available',
            style: TextStyle(fontSize: 12, color: AppColors.subtextColor),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dailyTrainings.length,
        itemBuilder: (context, index) {
          final workout = dailyTrainings[index];
          return _buildWorkoutCard(workout, index);
        },
      ),
    );
  }

  Widget _buildWorkoutCard(DailyTraining workout, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: workout.isRestDay == true
                      ? AppColors.accentColor
                      : AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${workout.dayNumber ?? index + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title ?? 'Day ${workout.dayNumber ?? index + 1}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    if (workout.date != null)
                      Text(
                        '${workout.date!.day}/${workout.date!.month}/${workout.date!.year}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.subtextColor,
                        ),
                      ),
                  ],
                ),
              ),
              if (workout.durationInMinutes != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${workout.durationInMinutes}min',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
            ],
          ),
          if (workout.description != null) ...[
            const SizedBox(height: 8),
            Text(
              workout.description!,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.subtextColor,
              ),
            ),
          ],
          if (workout.images?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: workout.images!.length,
                itemBuilder: (context, imgIndex) {
                  return GestureDetector(
                    onTap: () => _openGallery(imgIndex, workout.images!),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _buildNetworkImage(
                          workout.images![imgIndex],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          if (workout.intensityLevel != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  size: 12,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Intensity: ${workout.intensityLevel}',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.timeline,
                  size: 32,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Payment Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.trainingPackage.paymentStatus ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Purchased on: ${_formatDate(widget.trainingPackage.boughtAt)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.subtextColor,
                  ),
                ),
                Text(
                  'Amount Paid: \$${(widget.trainingPackage.pricePaid ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.subtextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_bag, size: 16, color: AppColors.primaryColor),
              SizedBox(width: 6),
              Text(
                'Purchase Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Status',
            widget.trainingPackage.paymentStatus ?? 'Unknown',
          ),
          _buildInfoRow(
            'Purchase Date',
            _formatDate(widget.trainingPackage.boughtAt),
          ),
          _buildInfoRow(
            'Amount Paid',
            '\$${(widget.trainingPackage.pricePaid ?? 0).toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.subtextColor),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage(String url, {BoxFit fit = BoxFit.cover}) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryColor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.cardColor,
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              color: AppColors.subtextColor,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor() {
    switch (widget.trainingPackage.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'paid':
        return AppColors.successColor;
      case 'pending':
        return AppColors.warningColor;
      case 'failed':
      case 'cancelled':
        return AppColors.errorColor;
      default:
        return AppColors.subtextColor;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}
