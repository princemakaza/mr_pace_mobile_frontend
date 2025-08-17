import 'package:flutter/material.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/models/sports_news_model.dart' show SportNewsModel;
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsDetailsScreen extends StatefulWidget {
  final SportNewsModel newsModel;

  const NewsDetailsScreen({
    Key? key,
    required this.newsModel,
  }) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 400), () {
      _slideController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildShimmerImage({required double height}) {
    return Shimmer.fromColors(
      baseColor: AppColors.borderColor,
      highlightColor: AppColors.surfaceColor,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String imageUrl, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmerImage(height: height),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: AppColors.subtextColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Image not available',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.subtextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    final images = <String>[];
    
    if (widget.newsModel.imageUrl != null && widget.newsModel.imageUrl!.isNotEmpty) {
      images.add(widget.newsModel.imageUrl!);
    }
    
    if (widget.newsModel.moreImages != null && widget.newsModel.moreImages!.isNotEmpty) {
      images.addAll(widget.newsModel.moreImages!);
    }

    if (images.isEmpty) {
      return Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 64,
              color: AppColors.subtextColor,
            ),
            const SizedBox(height: 12),
            Text(
              'No images available',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.subtextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildNetworkImage(images[index], height: 250),
                );
              },
            ),
          ),
          if (images.length > 1) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentImageIndex == entry.key ? 24.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentImageIndex == entry.key
                        ? AppColors.primaryColor
                        : AppColors.borderColor,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'basketball':
        return Icons.sports_basketball;
      case 'rugby':
        return Icons.sports_rugby;
      case 'tennis':
        return Icons.sports_tennis;
      case 'athletics':
        return Icons.directions_run;
      case 'boxing':
        return Icons.sports_martial_arts;
      case 'formula 1':
        return Icons.sports_motorsports;
      case 'golf':
        return Icons.sports_golf;
      default:
        return Icons.sports;
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'football':
        return AppColors.successColor;
      case 'cricket':
        return AppColors.accentColor;
      case 'basketball':
        return Colors.orange;
      case 'rugby':
        return Colors.brown;
      case 'tennis':
        return Colors.purple;
      case 'athletics':
        return Colors.blue;
      case 'boxing':
        return AppColors.errorColor;
      case 'formula 1':
        return Colors.black;
      case 'golf':
        return Colors.green;
      default:
        return AppColors.primaryColor;
    }
  }

  Widget _buildCategoryChip() {
    if (widget.newsModel.category == null || widget.newsModel.category!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getCategoryColor(widget.newsModel.category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getCategoryColor(widget.newsModel.category).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(widget.newsModel.category),
            size: 16,
            color: _getCategoryColor(widget.newsModel.category),
          ),
          const SizedBox(width: 6),
          Text(
            widget.newsModel.category!.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              color: _getCategoryColor(widget.newsModel.category),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.subtextColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.subtextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _shareOnWhatsApp() async {
    final String title = widget.newsModel.title ?? 'News Update';
    final String content = widget.newsModel.content ?? '';
    final String imageUrl = widget.newsModel.imageUrl ?? '';
    final String category = widget.newsModel.category ?? '';
    final String source = widget.newsModel.source ?? '';
    
    String message = '🏆 *$title*\n\n';
    
    if (category.isNotEmpty) {
      message += '📂 Category: *$category*\n';
    }
    
    if (source.isNotEmpty) {
      message += '📰 Source: $source\n\n';
    } else {
      message += '\n';
    }
    
    if (content.isNotEmpty) {
      final truncatedContent = content.length > 300 
          ? '${content.substring(0, 300)}...' 
          : content;
      message += '$truncatedContent\n\n';
    }
    
    if (imageUrl.isNotEmpty) {
      message += '🖼️ View Image: $imageUrl\n\n';
    }
    
    message += '📱 This news is brought to you by MrPace App\n';
    message += '🔗 Download on PlayStore: https://play.google.com/store/apps/details?id=com.mrpace.sports';
    
    final String encodedMessage = Uri.encodeComponent(message);
    final String whatsappUrl = 'whatsapp://send?text=$encodedMessage';
    
    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        await Share.share(message, subject: title);
      }
    } catch (e) {
      await Share.share(message, subject: title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundColor,
            foregroundColor: AppColors.textColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textColor,
                  size: 18,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _shareOnWhatsApp,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366), // WhatsApp green
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF25D366).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                tooltip: 'Share on WhatsApp',
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel
                  _buildImageCarousel(),
                  
                  const SizedBox(height: 24),
                  
                  // Category and Info Row
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        _buildCategoryChip(),
                        const Spacer(),
                        if (widget.newsModel.publishedAt != null)
                          _buildInfoChip(
                            _formatDate(widget.newsModel.publishedAt),
                            Icons.access_time,
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Title
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        widget.newsModel.title ?? 'No Title Available',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Source
                  if (widget.newsModel.source != null && widget.newsModel.source!.isNotEmpty)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.source,
                              size: 16,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Source: ${widget.newsModel.source}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Content
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Text(
                          widget.newsModel.content ?? 'No content available.',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textColor,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Share Button
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _shareOnWhatsApp,
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Share on WhatsApp',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF25D366).withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}