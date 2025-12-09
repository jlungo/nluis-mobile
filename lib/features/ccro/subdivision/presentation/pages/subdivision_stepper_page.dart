import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/utils/snackbar_utils.dart';
import '../../../../../data/local/database.dart';
import '../../../dashboard/presentation/providers/ccro_providers.dart';
import '../widgets/applicant_form_step.dart';
import '../widgets/parcel_drawing_step.dart';
import '../widgets/allocations_step.dart';
import '../widgets/photos_step.dart';
import '../widgets/review_step.dart';

class SubdivisionStepperPage extends ConsumerStatefulWidget {
  final String projectId;
  final String zoneId;
  final int localityId;
  final String projectName;
  final String? applicationId; // Optional: For editing existing applications

  const SubdivisionStepperPage({
    super.key,
    required this.projectId,
    required this.zoneId,
    required this.localityId,
    required this.projectName,
    this.applicationId,
  });

  @override
  ConsumerState<SubdivisionStepperPage> createState() =>
      _SubdivisionStepperPageState();
}

class _SubdivisionStepperPageState
    extends ConsumerState<SubdivisionStepperPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  String? _applicationId;
  bool _hasLoadedDraft = false;

  // Step data
  Party? _applicant;
  Parcel? _parcel;
  List<Allocation> _allocations = [];
  List<ParcelPhoto> _photos = [];

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _applicant != null;
      case 1:
        return true; // TODO: Fix parcel mapping - temporarily allow skip
      case 2:
        return _allocations.isNotEmpty && _totalAllocation == 100.0;
      case 3:
        return true; // Photos optional
      case 4:
        return _isValid;
      default:
        return false;
    }
  }

  bool get _isValid {
    return _applicant != null &&
        _parcel != null &&
        _allocations.isNotEmpty &&
        _totalAllocation == 100.0;
  }

  double get _totalAllocation {
    return _allocations.fold(0.0, (sum, a) => sum + a.proposedShare);
  }

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

    // Only load draft if applicationId is provided (editing mode)
    if (widget.applicationId == null) {
      // New application - start fresh
      return;
    }

    try {
      final repository = ref.read(ccroRepositoryProvider);

      // Get all applications for this zone
      final appsResult = await repository.getLocalApplications();

      await appsResult.fold((failure) => null, (apps) async {
        // Find the specific application by ID
        final draft = apps
            .where((app) => app.clientId == widget.applicationId)
            .firstOrNull;

        if (draft != null && mounted) {
          setState(() {
            _applicationId = draft.clientId;
            _currentStep = draft.currentStep;
          });

          // Load associated data
          await _loadDraftData(draft.clientId);
        }
      });
    } catch (e) {
      // Silent fail - user can start fresh
    }
  }

  Future<void> _loadDraftData(String appId) async {
    try {
      final repository = ref.read(ccroRepositoryProvider);

      // Load applicant
      final partiesResult = await repository.getLocalParties();
      await partiesResult.fold((failure) => null, (parties) {
        if (parties.isNotEmpty && mounted) {
          setState(() => _applicant = parties.first);
        }
      });

      // Load parcel
      final parcelsResult = await repository.getLocalParcels();
      await parcelsResult.fold((failure) => null, (parcels) {
        final appParcels =
            parcels.where((p) => p.applicationId == appId).toList();
        if (appParcels.isNotEmpty && mounted) {
          setState(() => _parcel = appParcels.first);
        }
      });

      // TODO: Load allocations and photos when implemented
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _saveDraftStep() async {
    if (_applicationId == null) return;

    try {
      final repository = ref.read(ccroRepositoryProvider);
      await repository.updateApplicationStep(
        applicationId: _applicationId!,
        currentStep: _currentStep,
      );
    } catch (e) {
      // Silent fail - not critical
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
      body: Stack(
        children: [
          Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (!_canProceed) {
                SnackBarUtils.showError(
                  context,
                  'Tafadhali jaza taarifa zote zinazohitajika',
                );
                return;
              }

              if (_currentStep < 4) {
                setState(() => _currentStep++);
                _saveDraftStep(); // Auto-save step progress
              } else {
                _completeSubdivision();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
                _saveDraftStep(); // Auto-save step progress
              } else {
                Navigator.pop(context);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: AppConstants.spacingMd),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _canProceed ? details.onStepContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_currentStep == 4 ? 'Kamilisha' : 'Endelea'),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(_currentStep == 0 ? 'Ghairi' : 'Rudi Nyuma'),
                    ),
                    if (_currentStep == 4) ...[
                      const SizedBox(width: AppConstants.spacingSm),
                      OutlinedButton(
                        onPressed: _saveDraft,
                        child: const Text('Hifadhi Rasimu'),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              // Step 1: Applicant Details
              Step(
                title: const Text('Maelezo ya Mwombaji'),
                subtitle: Text(
                  _applicant != null
                      ? '${_applicant!.firstName} ${_applicant!.lastName}'
                      : 'Taarifa za mwombaji',
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: ApplicantFormStep(
                  zoneId: int.parse(widget.zoneId),
                  localityId: widget.localityId,
                  applicationId: _applicationId,
                  applicant: _applicant,
                  onApplicantCreated: (party, appId) {
                    setState(() {
                      _applicant = party;
                      _applicationId = appId;
                    });
                  },
                ),
              ),
              // Step 2: Parcel Definition
              Step(
                title: const Text('Taarifa za Kipande'),
                subtitle: Text(
                  _parcel != null
                      ? 'Eneo: ${((_parcel!.areaSqm ?? 0) / 10000).toStringAsFixed(2)} ha'
                      : 'Ramani na mipaka',
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: ParcelDrawingStep(
                  projectId: widget.projectId,
                  zoneId: int.parse(widget.zoneId),
                  localityId: widget.localityId,
                  applicationId: _applicationId,
                  parcel: _parcel,
                  onParcelCreated: (parcel, appId) {
                    setState(() {
                      _parcel = parcel;
                      _applicationId = appId;
                    });
                  },
                ),
              ),
              // Step 3: Allocation
              Step(
                title: const Text('Ugawaji'),
                subtitle: Text(
                  _allocations.isNotEmpty
                      ? '${_allocations.length} wenye haki ($_totalAllocation%)'
                      : 'Wenye haki na hisa',
                ),
                isActive: _currentStep >= 2,
                state:
                    _currentStep > 2 ? StepState.complete : StepState.indexed,
                content: AllocationsStep(
                  parcelId: _parcel?.clientId,
                  allocations: _allocations,
                  onAllocationsChanged: (allocations) {
                    setState(() => _allocations = allocations);
                  },
                ),
              ),
              // Step 4: Photos
              Step(
                title: const Text('Picha'),
                subtitle: Text(
                  _photos.isNotEmpty
                      ? '${_photos.length} picha'
                      : 'Picha za kipande',
                ),
                isActive: _currentStep >= 3,
                state:
                    _currentStep > 3 ? StepState.complete : StepState.indexed,
                content: PhotosStep(
                  parcelId: _parcel?.clientId,
                  photos: _photos,
                  onPhotosChanged: (photos) {
                    setState(() => _photos = photos);
                  },
                ),
              ),
              // Step 5: Review
              Step(
                title: const Text('Kagua'),
                subtitle: const Text('Thibitisha maelezo'),
                isActive: _currentStep >= 4,
                state: StepState.indexed,
                content: ReviewStep(
                  applicant: _applicant,
                  parcel: _parcel,
                  allocations: _allocations,
                  photos: _photos,
                  totalAllocation: _totalAllocation,
                  isValid: _isValid,
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _saveDraft() async {
    setState(() => _isLoading = true);

    try {
      if (_applicationId != null) {
        final repository = ref.read(ccroRepositoryProvider);

        // Save current step
        await repository.updateApplicationStep(
          applicationId: _applicationId!,
          currentStep: _currentStep,
        );

        if (mounted) {
          SnackBarUtils.showSuccess(
            context,
            'Rasimu imehifadhiwa kwenye hatua ya ${_currentStep + 1}. Unaweza kurudi kuendelea baadaye.',
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

  Future<void> _completeSubdivision() async {
    if (!_isValid) {
      SnackBarUtils.showError(
        context,
        'Tafadhali jaza taarifa zote zinazohitajika',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Update application status to completed (ready for upload)
      if (_applicationId != null) {
        // Mark as completed/waiting for upload
        SnackBarUtils.showSuccess(
          context,
          'Ombi limekamilika! Litapakiwa mtandao unapopatikana.',
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      SnackBarUtils.showError(context, 'Hitilafu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
