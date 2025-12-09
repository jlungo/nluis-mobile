import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../data/local/database.dart';
import '../../../dashboard/presentation/providers/ccro_providers.dart';

class PhotosStep extends ConsumerStatefulWidget {
  final String? parcelId;
  final List<ParcelPhoto> photos;
  final Function(List<ParcelPhoto>) onPhotosChanged;

  const PhotosStep({
    super.key,
    this.parcelId,
    required this.photos,
    required this.onPhotosChanged,
  });

  @override
  ConsumerState<PhotosStep> createState() => _PhotosStepState();
}

class _PhotosStepState extends ConsumerState<PhotosStep> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Picha za Kipande',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        
        if (widget.photos.isEmpty)
          Card(
            color: isDark ? AppColors.darkSurface : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              side: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: Container(
              height: 200,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 64,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'Hakuna picha',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    'Piga picha za kipande cha ardhi',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppConstants.spacingSm,
              mainAxisSpacing: AppConstants.spacingSm,
            ),
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              final photo = widget.photos[index];
              return _buildPhotoCard(photo, theme, isDark, context);
            },
          ),
        
        const SizedBox(height: AppConstants.spacingMd),
        
        // Photo count indicator
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                Icons.photo_library,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Jumla ya Picha: ${widget.photos.length}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              ),
              const Spacer(),
              if (widget.photos.length >= 2)
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
            ],
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingMd),
        
        // Modern add photo buttons - always visible
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (widget.parcelId != null && !_isProcessing)
                    ? () => _capturePhoto(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.camera_alt, size: 20),
                label: const Text('Kamera'),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: (widget.parcelId != null && !_isProcessing)
                    ? () => _selectFromGallery(context)
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.photo_library, size: 20),
                label: const Text('Faili'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoCard(ParcelPhoto photo, ThemeData theme, bool isDark, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (File(photo.photoPath).existsSync())
            Image.file(
              File(photo.photoPath),
              fit: BoxFit.cover,
            )
          else
            Container(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
              child: Icon(
                Icons.broken_image,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                onPressed: () => _deletePhoto(photo, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePhoto(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _savePhoto(image, 'other', context);
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hitilafu ya kamera: $e');
      }
    }
  }

  Future<void> _selectFromGallery(BuildContext context) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() => _isProcessing = true);
        for (final image in images) {
          await _savePhoto(image, 'other', context);
        }
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        SnackBarUtils.showError(context, 'Hitilafu ya gallery: $e');
      }
    }
  }

  Future<void> _savePhoto(XFile image, String photoType, BuildContext context) async {
    if (!mounted) return;
    
    setState(() => _isProcessing = true);

    try {
      final repository = ref.read(ccroRepositoryProvider);
      final clientId = const Uuid().v4();

      // Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${appDir.path}/parcel_photos');
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(image.path);
      final fileName = '${widget.parcelId}_$timestamp$extension';
      final savedPath = '${photosDir.path}/$fileName';

      // Copy image to app directory
      await File(image.path).copy(savedPath);

      // Save to database
      final photoData = {
        'client_id': clientId,
        'parcel_id': widget.parcelId!,
        'photo_path': savedPath,
        'photo_type': photoType,
        'description': null,
      };

      final result = await repository.saveLocalParcelPhoto(photoData);

      await result.fold(
        (failure) {
          if (mounted) {
            SnackBarUtils.showError(context, failure.message);
          }
        },
        (_) async {
          // Fetch updated photos
          final photosResult = await repository.getLocalParcelPhotos();
          photosResult.fold(
            (failure) {
              if (mounted) {
                SnackBarUtils.showError(context, failure.message);
              }
            },
            (allPhotos) {
              final parcelPhotos = allPhotos
                  .where((p) => p.parcelId == widget.parcelId)
                  .toList();
              widget.onPhotosChanged(parcelPhotos);
              if (mounted) {
                SnackBarUtils.showSuccess(context, 'Picha imehifadhiwa');
              }
            },
          );
        },
      );
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _deletePhoto(ParcelPhoto photo, BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Futa Picha'),
        content: const Text('Je, una uhakika unataka kufuta picha hii?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ghairi'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Futa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Delete file if exists
        final file = File(photo.photoPath);
        if (await file.exists()) {
          await file.delete();
        }

        // Remove from database
        final repository = ref.read(ccroRepositoryProvider);
        await repository.deleteLocalParcelPhoto(photo.clientId);

        // Update UI
        final updatedPhotos = widget.photos.where((p) => p.clientId != photo.clientId).toList();
        widget.onPhotosChanged(updatedPhotos);

        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Picha imefutwa');
        }
      } catch (e) {
        if (mounted) {
          SnackBarUtils.showError(context, 'Hitilafu ya kufuta: $e');
        }
      }
    }
  }
}
