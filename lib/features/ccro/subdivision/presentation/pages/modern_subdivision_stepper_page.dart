import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../data/local/database.dart' as db;
import '../../../dashboard/presentation/providers/ccro_providers.dart';
import '../widgets/applicant_form_step.dart';
import '../widgets/parcel_drawing_step.dart';
import '../widgets/allocations_step.dart';
import '../widgets/photos_step.dart';
import '../widgets/review_step.dart';

/// Modern subdivision stepper with independent, clickable steps
class ModernSubdivisionStepperPage extends ConsumerStatefulWidget {
  final String projectId;
  final String zoneId;
  final int localityId;
  final String projectName;
  final String? applicationId;

  const ModernSubdivisionStepperPage({
    super.key,
    required this.projectId,
    required this.zoneId,
    required this.localityId,
    required this.projectName,
    this.applicationId,
  });

  @override
  ConsumerState<ModernSubdivisionStepperPage> createState() =>
      _ModernSubdivisionStepperPageState();
}

class _ModernSubdivisionStepperPageState
    extends ConsumerState<ModernSubdivisionStepperPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  String? _applicationId;
  bool _hasLoadedDraft = false;

  // Step data
  db.Party? _applicant;
  db.Parcel? _parcel;
  List<db.Allocation> _allocations = [];
  List<db.ParcelPhoto> _photos = [];

  // Step completion states
  final Map<int, bool> _stepCompleted = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
  };

  final List<String> _stepTitles = [
    'Mwombaji',
    'Kipande',
    'Ugawaji',
    'Picha',
    'Kagua',
  ];

  final List<IconData> _stepIcons = [
    Icons.person_outline,
    Icons.map_outlined,
    Icons.people_outline,
    Icons.photo_camera_outlined,
    Icons.checklist_outlined,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDraft();
    });
  }

  Future<void> _loadDraft() async {
    if (_hasLoadedDraft) return;
    _hasLoadedDraft = true;

    if (widget.applicationId == null) return;

    try {
      final repository = ref.read(ccroRepositoryProvider);
      final appsResult = await repository.getLocalApplications();

      await appsResult.fold((failure) => null, (apps) async {
        final draft =
            apps
                .where((app) => app.clientId == widget.applicationId)
                .firstOrNull;

        if (draft != null && mounted) {
          setState(() {
            _applicationId = draft.clientId;
            _currentStep = draft.currentStep;
          });
          await _loadDraftData(draft.clientId);
        }
      });
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _loadDraftData(String appId) async {
    try {
      final repository = ref.read(ccroRepositoryProvider);

      // Load applicant
      final partiesResult = await repository.getLocalParties();
      await partiesResult.fold((failure) => null, (parties) {
        if (parties.isNotEmpty && mounted) {
          setState(() {
            _applicant = parties.first;
            _stepCompleted[0] = true;
          });
        }
      });

      // Load parcel
      final parcelsResult = await repository.getLocalParcels();
      await parcelsResult.fold((failure) => null, (parcels) {
        final appParcels =
            parcels.where((p) => p.applicationId == appId).toList();
        if (appParcels.isNotEmpty && mounted) {
          setState(() {
            _parcel = appParcels.first;
            _stepCompleted[1] = true;
          });
        }
      });

      // Load allocations
      final allocationsResult = await repository.getLocalAllocations();
      await allocationsResult.fold((failure) => null, (allocations) {
        final parcelAllocations =
            allocations.where((a) => a.parcelId == _parcel?.clientId).toList();
        if (parcelAllocations.isNotEmpty && mounted) {
          setState(() {
            _allocations = parcelAllocations;
            _stepCompleted[2] = _totalAllocation == 100.0;
          });
        }
      });

      // Load photos
      final photosResult = await repository.getLocalParcelPhotos();
      await photosResult.fold((failure) => null, (photos) {
        final parcelPhotos =
            photos.where((p) => p.parcelId == _parcel?.clientId).toList();
        if (parcelPhotos.isNotEmpty && mounted) {
          setState(() {
            _photos = parcelPhotos;
            _stepCompleted[3] = true;
          });
        }
      });
    } catch (e) {
      // Silent fail
    }
  }

  double get _totalAllocation {
    return _allocations.fold(0.0, (sum, a) => sum + a.proposedShare);
  }

  bool get _isValid {
    return _applicant != null &&
        _parcel != null &&
        _allocations.isNotEmpty &&
        _totalAllocation == 100.0;
  }

  double get _progressPercentage {
    int completedSteps = _stepCompleted.values.where((v) => v).length;
    return completedSteps / 5.0;
  }

  Future<void> _autoSaveStep() async {
    if (_applicationId != null) {
      try {
        final repository = ref.read(ccroRepositoryProvider);
        await repository.updateApplicationStep(
          applicationId: _applicationId!,
          currentStep: _currentStep,
        );
      } catch (e) {
        // Silent fail
      }
    }
  }

  Future<void> _clearStepData(int step) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Futa Taarifa'),
            content: Text(
              'Una uhakika unataka kufuta taarifa zote za hatua "${_stepTitles[step]}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Ghairi'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Futa'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(ccroRepositoryProvider);

      switch (step) {
        case 0:
          // Clear applicant
          if (_applicant != null) {
            // TODO: Implement delete party method
          }
          setState(() {
            _applicant = null;
            _stepCompleted[0] = false;
          });
          break;
        case 1:
          // Clear parcel
          if (_parcel != null) {
            // TODO: Implement delete parcel method
          }
          setState(() {
            _parcel = null;
            _stepCompleted[1] = false;
          });
          break;
        case 2:
          // Clear allocations
          // TODO: Implement delete allocation method from database
          setState(() {
            _allocations.clear();
            _stepCompleted[2] = false;
          });
          break;
        case 3:
          // Clear photos
          for (var photo in _photos) {
            await repository.deleteLocalParcelPhoto(photo.clientId);
          }
          setState(() {
            _photos.clear();
            _stepCompleted[3] = false;
          });
          break;
      }

      if (mounted) {
        SnackBarUtils.showSuccess(context, 'Taarifa zimefutwa');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: CustomAppBar(
        title: 'Mgawanyiko wa Ardhi',
        subtitle: widget.projectName,
        showBackButton: true,
        showProfile: false,
      ),
      body: Column(
        children: [
          // Modern progress indicator
          _buildProgressIndicator(isDark),

          // Clickable step headers
          _buildStepHeaders(isDark, theme),

          const Divider(height: 1, color: AppColors.divider),

          // Step content
          Expanded(
            child: Stack(
              children: [
                _buildStepContent(),
                if (_isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),

          // Bottom action bar
          _buildBottomActionBar(isDark, theme),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maendeleo: ${(_progressPercentage * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
              ),
              Text(
                '${_stepCompleted.values.where((v) => v).length}/5 Hatua',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            child: LinearProgressIndicator(
              value: _progressPercentage,
              minHeight: 6,
              backgroundColor:
                  isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeaders(bool isDark, ThemeData theme) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
        itemCount: 5,
        separatorBuilder:
            (context, index) => const SizedBox(width: AppConstants.spacingSm),
        itemBuilder: (context, index) {
          final isActive = _currentStep == index;
          final isCompleted = _stepCompleted[index] ?? false;
          final canAccess = index == 0 || _stepCompleted[index - 1] == true;

          return InkWell(
            onTap:
                canAccess
                    ? () {
                      setState(() => _currentStep = index);
                      _autoSaveStep();
                    }
                    : null,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            child: Container(
              width: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isActive
                        ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                        : (isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.surfaceVariant),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color:
                      isCompleted
                          ? AppColors.success
                          : (isActive
                              ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary)
                              : Colors.transparent),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        _stepIcons[index],
                        color:
                            isActive
                                ? Colors.white
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary),
                        size: 24,
                      ),
                      if (isCompleted)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isDark
                                        ? AppColors.darkSurface
                                        : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _stepTitles[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isActive
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildCurrentStep()],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return ApplicantFormStep(
          zoneId: int.parse(widget.zoneId),
          localityId: widget.localityId,
          applicationId: _applicationId,
          applicant: _applicant,
          onApplicantCreated: (party, appId) {
            setState(() {
              _applicant = party;
              _applicationId = appId;
              _stepCompleted[0] = true;
            });
            _autoSaveStep();
          },
        );
      case 1:
        return ParcelDrawingStep(
          projectId: widget.projectId,
          zoneId: int.parse(widget.zoneId),
          localityId: widget.localityId,
          applicationId: _applicationId,
          parcel: _parcel,
          onParcelCreated: (parcel, appId) {
            setState(() {
              _parcel = parcel;
              _applicationId = appId;
              _stepCompleted[1] = true;
            });
            _autoSaveStep();
          },
        );
      case 2:
        return AllocationsStep(
          parcelId: _parcel?.clientId,
          allocations: _allocations,
          onAllocationsChanged: (allocations) {
            setState(() {
              _allocations = allocations;
              _stepCompleted[2] = _totalAllocation == 100.0;
            });
            _autoSaveStep();
          },
        );
      case 3:
        return PhotosStep(
          parcelId: _parcel?.clientId,
          photos: _photos,
          onPhotosChanged: (photos) {
            setState(() {
              _photos = photos;
              _stepCompleted[3] = photos.isNotEmpty;
            });
            _autoSaveStep();
          },
        );
      case 4:
        return ReviewStep(
          applicant: _applicant,
          parcel: _parcel,
          allocations: _allocations,
          photos: _photos,
          totalAllocation: _totalAllocation,
          isValid: _isValid,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomActionBar(bool isDark, ThemeData theme) {
    final canProceed =
        _currentStep < 4 &&
        ((_currentStep == 0 && _applicant != null) ||
            (_currentStep == 1 && _parcel != null) ||
            (_currentStep == 2 &&
                _allocations.isNotEmpty &&
                _totalAllocation == 100.0) ||
            (_currentStep == 3) ||
            _currentStep == 4);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Clear data button
            if (_currentStep < 4)
              IconButton(
                onPressed: () => _clearStepData(_currentStep),
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                tooltip: 'Futa taarifa za hatua hii',
              ),
            const SizedBox(width: AppConstants.spacingSm),

            // Back button
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _currentStep--);
                    _autoSaveStep();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Rudi'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: AppConstants.spacingSm),

            // Next/Complete button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed:
                    _currentStep == 4
                        ? (_isValid ? _completeApplication : null)
                        : (canProceed
                            ? () {
                              setState(() => _currentStep++);
                              _autoSaveStep();
                            }
                            : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor:
                      isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.surfaceVariant,
                ),
                child: Text(
                  _currentStep == 4 ? 'Kamilisha Ombi' : 'Endelea',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeApplication() async {
    if (!_isValid) {
      SnackBarUtils.showError(
        context,
        'Tafadhali jaza taarifa zote zinazohitajika',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_applicationId != null) {
        final repository = ref.read(ccroRepositoryProvider);

        // Update application status to completed
        await repository.updateApplicationStatus(
          applicationId: _applicationId!,
          status: 'completed',
        );

        if (mounted) {
          SnackBarUtils.showSuccess(
            context,
            'Ombi limekamilika! Litapakiwa mtandao unapopatikana.',
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hitilafu: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
