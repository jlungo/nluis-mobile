import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nluis_collect/shared/theme/app_colors.dart';

final photoListProvider = StateProvider.family<List<XFile>, int>(
  (ref, applicationId) => [],
);

class PhotoCapturePage extends ConsumerStatefulWidget {
  final int applicationId;
  final String applicationNumber;

  const PhotoCapturePage({
    super.key,
    required this.applicationId,
    required this.applicationNumber,
  });

  @override
  ConsumerState<PhotoCapturePage> createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends ConsumerState<PhotoCapturePage> {
  final ImagePicker _picker = ImagePicker();
  final int _maxPhotos = 4;

  Future<void> _capturePhoto() async {
    final photos = ref.read(photoListProvider(widget.applicationId));

    if (photos.length >= _maxPhotos) {
      _showMaxPhotosReached();
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        ref.read(photoListProvider(widget.applicationId).notifier).state = [
          ...photos,
          photo,
        ];
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu katika kupiga picha: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final photos = ref.read(photoListProvider(widget.applicationId));

    if (photos.length >= _maxPhotos) {
      _showMaxPhotosReached();
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        ref.read(photoListProvider(widget.applicationId).notifier).state = [
          ...photos,
          photo,
        ];
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu katika kuchagua picha: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showMaxPhotosReached() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Umeshafika kikomo cha picha $_maxPhotos'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _removePhoto(int index) {
    final photos = ref.read(photoListProvider(widget.applicationId));
    ref.read(photoListProvider(widget.applicationId).notifier).state = [
      ...photos.sublist(0, index),
      ...photos.sublist(index + 1),
    ];
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Piga Picha'),
                  onTap: () {
                    Navigator.pop(context);
                    _capturePhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Chagua kutoka Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _savePhotos() async {
    final photos = ref.read(photoListProvider(widget.applicationId));

    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tafadhali ongeza picha angalau moja'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // First, get the parcel ID
      final apiService = ref.read(adjudicationApiServiceProvider);
      final parcelGeoJson = await apiService.getParcelsGeoJson(
        widget.applicationId,
      );

      if (parcelGeoJson['features'] == null ||
          (parcelGeoJson['features'] as List).isEmpty) {
        // No parcel found
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Hakuna kiwanja kilichoandikishwa. Tafadhali rekodi kiwanja kwanza.',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Get parcel ID from the feature
      final parcelId = parcelGeoJson['features'][0]['id'] as int;

      // Convert XFile to File objects
      final photoFiles = photos.map((xFile) => File(xFile.path)).toList();

      // Upload photos
      await apiService.uploadParcelPhotos(
        parcelId,
        photoFiles,
        photoType: 'parcel',
        caption: 'Picha za kiwanja ${widget.applicationNumber}',
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Picha zimehifadhiwa'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context); // Return to application details
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitilafu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(photoListProvider(widget.applicationId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Picha: ${widget.applicationNumber}'),
        actions: [
          if (photos.isNotEmpty)
            TextButton(
              onPressed: _savePhotos,
              child: const Text(
                'Hifadhi',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Piga picha hadi $_maxPhotos za kiwanja (${photos.length}/$_maxPhotos)',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                photos.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hakuna picha',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bonyeza kitufe cha chini kuongeza picha',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        return _PhotoCard(
                          photo: photos[index],
                          index: index,
                          onRemove: () => _removePhoto(index),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton:
          photos.length < _maxPhotos
              ? FloatingActionButton.extended(
                onPressed: _showPhotoOptions,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Ongeza Picha'),
              )
              : null,
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final XFile photo;
  final int index;
  final VoidCallback onRemove;

  const _PhotoCard({
    required this.photo,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(photo.path), fit: BoxFit.cover),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(8),
              ),
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
