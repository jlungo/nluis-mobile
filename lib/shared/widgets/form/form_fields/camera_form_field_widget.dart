import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../../constants/app_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/dialog_utils.dart';

class CameraFormFieldWidget extends StatefulWidget {
  final String label;
  final bool required;
  final File? value;
  final void Function(File?)? onChanged;
  final bool enabled;
  final bool allowGallery;
  final CropAspectRatio? cropAspectRatio;
  final int? maxWidth;
  final int? maxHeight;
  final int imageQuality;

  const CameraFormFieldWidget({
    super.key,
    required this.label,
    this.required = false,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.allowGallery = true,
    this.cropAspectRatio,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality = 85,
  });

  @override
  State<CameraFormFieldWidget> createState() => _CameraFormFieldWidgetState();
}

class _CameraFormFieldWidgetState extends State<CameraFormFieldWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _showImageSourceDialog() async {
    if (!widget.enabled || widget.onChanged == null) return;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    await DialogUtils.showCustomDialog<void>(
      context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Chagua chanzo cha picha',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkPrimary : AppColors.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              ),
              title: const Text('Piga picha'),
              subtitle: const Text('Tumia kamera kupiga picha mpya'),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _captureImage(ImageSource.camera);
              },
            ),
            if (widget.allowGallery) ...[
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkPrimary : AppColors.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                ),
                title: const Text('Chagua kutoka kwenye maktaba'),
                subtitle: const Text('Chagua picha iliyopo kwenye simu'),
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  _captureImage(ImageSource.gallery);
                },
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Ghairi',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureImage(ImageSource source) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: widget.maxWidth?.toDouble(),
        maxHeight: widget.maxHeight?.toDouble(),
        imageQuality: widget.imageQuality,
      );

      if (pickedFile != null) {
        // Crop the image
        final croppedFile = await _cropImage(pickedFile.path);
        if (croppedFile != null) {
          widget.onChanged?.call(croppedFile);
        }
      }
    } catch (e) {
      if (mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Hitilafu',
          message: 'Imeshindikana kupiga picha. Jaribu tena.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: widget.cropAspectRatio,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Kata picha',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: widget.cropAspectRatio != null,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
            hideBottomControls: false,
            cropGridStrokeWidth: 2,
            cropGridColor: Theme.of(context).colorScheme.primary,
            activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
          ),
          IOSUiSettings(
            title: 'Kata picha',
            doneButtonTitle: 'Maliza',
            cancelButtonTitle: 'Ghairi',
            aspectRatioLockEnabled: widget.cropAspectRatio != null,
            resetAspectRatioEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        // Save cropped image to app directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(croppedFile.path).copy('${appDir.path}/$fileName');
        
        // Delete the temporary cropped file
        await File(croppedFile.path).delete();
        
        return savedImage;
      }
    } catch (e) {
      if (mounted) {
        DialogUtils.showErrorDialog(
          context,
          title: 'Hitilafu',
          message: 'Imeshindikana kukata picha. Jaribu tena.',
        );
      }
    }
    return null;
  }

  void _removeImage() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged?.call(null);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            if (widget.required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: isDark ? AppColors.errorDark : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        
        // Image preview
        if (widget.value != null) ...[
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              child: Stack(
                children: [
                  // Image
                  Center(
                    child: Image.file(
                      widget.value!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 48,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Imeshindikana kuonyesha picha',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Action buttons overlay
                  if (widget.enabled) ...[
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _showImageSourceDialog,
                              tooltip: 'Badilisha picha',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _removeImage,
                              tooltip: 'Ondoa picha',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          
          // Image info
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSm),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkPrimary : AppColors.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FutureBuilder<FileStat>(
                    future: widget.value!.stat(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${path.basename(widget.value!.path)} • ${_formatFileSize(snapshot.data!.size)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkPrimary : AppColors.primary,
                          ),
                        );
                      }
                      return Text(
                        path.basename(widget.value!.path),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkPrimary : AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
        ],

        // Capture button
        if (_isProcessing) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkPrimary : AppColors.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Inachakata picha...',
                  style: TextStyle(
                    color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: widget.enabled ? _showImageSourceDialog : null,
            icon: Icon(
              widget.value != null ? Icons.camera_alt : Icons.add_a_photo,
              color: widget.enabled 
                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                  : (isDark ? AppColors.darkTextHint : AppColors.textHint),
            ),
            label: Text(
              widget.value != null ? 'Piga picha nyingine' : 'Piga picha',
              style: TextStyle(
                color: widget.enabled 
                    ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                    : (isDark ? AppColors.darkTextHint : AppColors.textHint),
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: BorderSide(
                color: widget.enabled 
                    ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                    : (isDark ? AppColors.darkTextHint : AppColors.textHint),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
