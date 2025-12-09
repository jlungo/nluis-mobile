# CCRO Subdivision Workflow - Complete Implementation Plan

## ✅ COMPLETED WORK (2024-12-01)

### 1. Applications List Page ✅
- **Created:** `SubdivisionApplicationsPage` - Shows all applications by status
- **Design:** Mimics `survey_list_page.dart` with cards and tabs
- **Tabs:** Rasimu (Draft), Zimekamilika (Completed), Zimepakiwa (Uploaded)
- **FAB:** "Ombi Jipya" button to create new application
- **Navigation:** Click card to edit existing application
- **Route:** Updated to show list page instead of direct stepper

### 2. Draft on Step 1 (Applicant) ✅
- **Fixed:** Application is now saved as draft when Step 1 (Applicant) is completed
- **Updated:** `ApplicantFormStep` creates/updates draft application
- **Behavior:** Draft appears in "Rasimu" tab immediately after saving applicant
- **ApplicationId:** Properly passed through callbacks and stored

### 3. Edit Flow Fixed ✅
- **"Bofya Kurekebisha"** now goes directly to mapping page (no input method sheet)
- **"Rekodi Kipande"** button on mapping page shows input method selection
- **Flow:** Click edit → Map page → Click "Rekodi Kipande" → Choose method

### 4. Step 3 (Allocations) Complete ✅
- **Dialog:** Full allocation entry dialog with party selection
- **Features:**
  - Select from saved parties (applicant)
  - Choose right type (Ownership, Usufruct, Lease)
  - Enter share percentage
  - Validates that shares don't exceed 100%
  - Shows remaining share
- **Display:** Shows added allocations with person icon and percentage
- **Total:** Visual indicator showing if total equals 100%

### 5. Files Modified:
- `subdivision_applications_page.dart` - NEW: List of all applications
- `subdivision_application_card.dart` - NEW: Card for each application
- `subdivision_stepper_page.dart` - Updated: Load specific application by ID
- `applicant_form_step.dart` - Updated: Create draft on save
- `allocations_step.dart` - Updated: Full allocation dialog
- `parcel_drawing_step.dart` - Updated: Direct navigation to map
- `app_router.dart` - Updated: Route to list page

---

## 📋 REMAINING IMPLEMENTATION - Based on Zoning Pattern

### Overview

The CCRO subdivision process uses a **5-step stepper** with the following workflow:
1. **Step 1**: Zone Selection (Select subdivision zone)
2. **Step 2**: View Zone Geometry (View selected zone on map)
3. **Step 3**: Record Parcel (Capture parcel geometry)
4. **Step 4**: Add Parties/Owners (Applicant details)
5. **Step 5**: Capture Photos (Parcel photos)
6. **Review & Submit** (Final review before submission)

Unlike Zoning (single-feature workflow), CCRO has **multi-step workflow** with draft persistence at ANY step.

---

## 🎯 IMPLEMENTATION PLAN

### PHASE 1: Database Schema (Already Done ✅)

**Status:** Complete

**Tables Created:**
- `subdivision_zones` - Zone data
- `subdivision_applications` - Main application (has `currentStep` field)
- `parties` - Applicant/owner information
- `parcels` - Parcel geometry and metadata
- `parcel_drafts` - Temporary geometry-only storage (Step 3)
- `allocations` - Party-to-parcel mappings
- `parcel_photos` - Photo records

**Key Field:** `currentStep` in `subdivision_applications` tracks which step user is on.

---

### PHASE 2: Draft & Status Management (TO DO)

#### 2.1 Update Subdivision Application Model

**File:** `lib/features/ccro/subdivision/domain/entities/subdivision_application.dart`

**Add Fields:**
```dart
class SubdivisionApplication {
  final String clientId;
  final int zoneId;
  final int localityId;
  final String? applicantId; // Party client ID
  final String status; // 'draft', 'completed', 'uploaded'
  final int currentStep; // 1-6, tracks progress
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool uploaded;
  final DateTime? uploadedAt;
  
  // Helper methods
  bool get isDraft => status == 'draft' && currentStep < 6;
  bool get isCompleted => status == 'completed' || currentStep == 6;
  bool get isUploaded => uploaded;
  
  // Calculate completion percentage
  double get completionPercentage => (currentStep / 6) * 100;
}
```

#### 2.2 Create Application Repository Methods

**File:** `lib/features/ccro/subdivision/domain/repositories/subdivision_application_repository.dart`

**Add Methods:**
```dart
abstract class SubdivisionApplicationRepository {
  // Get applications by status
  Future<Either<Failure, List<SubdivisionApplication>>> getDraftApplications();
  Future<Either<Failure, List<SubdivisionApplication>>> getCompletedApplications();
  Future<Either<Failure, List<SubdivisionApplication>>> getUploadedApplications();
  
  // Update application progress
  Future<Either<Failure, void>> updateApplicationStep(String clientId, int step);
  Future<Either<Failure, void>> updateApplicationStatus(String clientId, String status);
  
  // Mark as uploaded
  Future<Either<Failure, void>> markAsUploaded(String clientId);
}
```

---

### PHASE 3: "Kazi Zangu" Page Implementation (TO DO)

**File:** `lib/features/ccro/dashboard/presentation/pages/my_applications_page.dart`

#### 3.1 Create Providers

**File:** `lib/features/ccro/dashboard/presentation/providers/application_providers.dart`

```dart
// Draft applications provider
final draftApplicationsProvider = FutureProvider<List<SubdivisionApplication>>((ref) async {
  final repository = ref.watch(subdivisionApplicationRepositoryProvider);
  final result = await repository.getDraftApplications();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (applications) => applications,
  );
});

// Completed applications provider
final completedApplicationsProvider = FutureProvider<List<SubdivisionApplication>>((ref) async {
  final repository = ref.watch(subdivisionApplicationRepositoryProvider);
  final result = await repository.getCompletedApplications();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (applications) => applications,
  );
});

// Uploaded applications provider
final uploadedApplicationsProvider = FutureProvider<List<SubdivisionApplication>>((ref) async {
  final repository = ref.watch(subdivisionApplicationRepositoryProvider);
  final result = await repository.getUploadedApplications();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (applications) => applications,
  );
});

// Counts provider (for badges)
final applicationCountsProvider = FutureProvider<(int, int, int)>((ref) async {
  final drafts = await ref.watch(draftApplicationsProvider.future);
  final completed = await ref.watch(completedApplicationsProvider.future);
  final uploaded = await ref.watch(uploadedApplicationsProvider.future);
  
  return (drafts.length, completed.length, uploaded.length);
});
```

#### 3.2 Update UI

**Pattern:** Follow Madodoso page structure

```dart
class MyApplicationsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countsAsync = ref.watch(applicationCountsProvider);
    
    final counts = countsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => (0, 0, 0),
    );
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: CustomAppBar(
          title: 'Kazi Zangu',
          bottom: _ApplicationTabBar(counts: counts),
        ),
        body: TabBarView(
          children: [
            _ApplicationList(
              status: ApplicationStatus.draft,
              provider: draftApplicationsProvider,
              emptyMessage: 'Hakuna maombi ya rasimu',
            ),
            _ApplicationList(
              status: ApplicationStatus.completed,
              provider: completedApplicationsProvider,
              emptyMessage: 'Hakuna maombi yaliyokamilika',
            ),
            _ApplicationList(
              status: ApplicationStatus.uploaded,
              provider: uploadedApplicationsProvider,
              emptyMessage: 'Hakuna maombi yaliyopakiwa',
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 3.3 Application List Item Card

**Create:** `lib/features/ccro/dashboard/presentation/widgets/application_card.dart`

```dart
class ApplicationCard extends StatelessWidget {
  final SubdivisionApplication application;
  final ApplicationStatus status;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _buildStepIndicator(),
        title: Text('Application ${application.clientId.substring(0, 8)}...'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zone: ${application.zoneId}'),
            SizedBox(height: 4),
            // Progress bar for drafts
            if (status == ApplicationStatus.draft)
              LinearProgressIndicator(
                value: application.completionPercentage / 100,
              ),
            Text('Step ${application.currentStep} of 6'),
          ],
        ),
        trailing: _buildStatusBadge(),
        onTap: () => _navigateToStepper(context),
      ),
    );
  }
  
  Widget _buildStepIndicator() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStepColor(),
      ),
      child: Center(
        child: Text(
          '${application.currentStep}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
  
  void _navigateToStepper(BuildContext context) {
    // Navigate to stepper page with application
    context.pushNamed(
      'subdivisionStepper',
      pathParameters: {
        'projectId': application.projectId,
        'zoneId': application.zoneId.toString(),
        'localityId': application.localityId.toString(),
      },
      queryParameters: {
        'applicationId': application.clientId,
      },
    );
  }
}
```

---

### PHASE 4: Stepper Progress Management (TO DO)

**File:** `lib/features/ccro/subdivision/presentation/pages/subdivision_stepper_page.dart`

#### 4.1 Load Application State

```dart
class SubdivisionStepperPage extends ConsumerStatefulWidget {
  final String? applicationId; // Passed when resuming draft
  
  @override
  ConsumerState<SubdivisionStepperPage> createState() => _SubdivisionStepperPageState();
}

class _SubdivisionStepperPageState extends ConsumerState<SubdivisionStepperPage> {
  int _currentStep = 0;
  String? _applicationId;
  
  @override
  void initState() {
    super.initState();
    _applicationId = widget.applicationId;
    
    if (_applicationId != null) {
      // Load existing application and resume at saved step
      _loadApplicationProgress();
    }
  }
  
  Future<void> _loadApplicationProgress() async {
    final repository = ref.read(subdivisionApplicationRepositoryProvider);
    final result = await repository.getApplication(_applicationId!);
    
    result.fold(
      (failure) {
        // Handle error
      },
      (application) {
        setState(() {
          _currentStep = application.currentStep - 1; // 0-indexed
        });
      },
    );
  }
  
  Future<void> _saveProgress(int step) async {
    if (_applicationId != null) {
      final repository = ref.read(subdivisionApplicationRepositoryProvider);
      await repository.updateApplicationStep(_applicationId!, step + 1);
    }
  }
}
```

#### 4.2 Update Step Completion Handler

```dart
void _onStepContinue() async {
  if (_currentStep < 5) {
    setState(() {
      _currentStep++;
    });
    await _saveProgress(_currentStep);
  } else {
    // All steps completed - mark as completed
    await _markAsCompleted();
  }
}

Future<void> _markAsCompleted() async {
  if (_applicationId != null) {
    final repository = ref.read(subdivisionApplicationRepositoryProvider);
    await repository.updateApplicationStatus(_applicationId!, 'completed');
    await repository.updateApplicationStep(_applicationId!, 6);
    
    // Show success message and navigate to "Kazi Zangu"
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ombi limekamilika! Inaweza kupakiwa sasa.')),
      );
      context.goNamed('myApplications');
    }
  }
}
```

---

### PHASE 5: Step Indicators (TO DO)

**File:** Create `lib/features/ccro/subdivision/presentation/widgets/step_status_indicator.dart`

```dart
class StepStatusIndicator extends StatelessWidget {
  final int currentStep;
  final SubdivisionApplication? application;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        final stepNumber = index + 1;
        final isCompleted = stepNumber < currentStep;
        final isCurrent = stepNumber == currentStep;
        final isDraft = stepNumber == currentStep && application?.isDraft == true;
        
        return Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.success
                    : isCurrent
                        ? isDraft
                            ? AppColors.warning
                            : AppColors.primary
                        : AppColors.textHint,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '$stepNumber',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              _getStepLabel(stepNumber),
              style: TextStyle(
                fontSize: 10,
                color: isCurrent ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        );
      }),
    );
  }
  
  String _getStepLabel(int step) {
    switch (step) {
      case 1: return 'Eneo';
      case 2: return 'Ramani';
      case 3: return 'Kipande';
      case 4: return 'Mhusika';
      case 5: return 'Picha';
      case 6: return 'Kagua';
      default: return '';
    }
  }
}
```

---

### PHASE 6: Upload Implementation (TO DO)

**File:** `lib/features/ccro/subdivision/data/services/subdivision_upload_service.dart`

```dart
class SubdivisionUploadService {
  final SubdivisionApplicationRepository applicationRepository;
  final PartyRepository partyRepository;
  final ParcelRepository parcelRepository;
  final AllocationRepository allocationRepository;
  final PhotoRepository photoRepository;
  
  Future<Either<Failure, void>> uploadApplication(String applicationId) async {
    try {
      // 1. Get application
      final app = await applicationRepository.getApplication(applicationId);
      
      // 2. Upload party (applicant)
      final party = await partyRepository.getPartiesForApplication(applicationId);
      final partyResult = await partyRepository.uploadParty(party.first);
      
      // 3. Create subdivision application on server
      final appResult = await applicationRepository.uploadApplication(app);
      
      // 4. Upload parcel
      final parcel = await parcelRepository.getParcelsForSubdivision(applicationId);
      final parcelResult = await parcelRepository.uploadParcel(parcel.first);
      
      // 5. Create allocation
      final allocation = await allocationRepository.getAllocationsForApplication(applicationId);
      final allocationResult = await allocationRepository.uploadAllocation(allocation.first);
      
      // 6. Upload photos
      final photos = await photoRepository.getPhotosForParcel(parcel.first.clientId);
      for (final photo in photos) {
        await photoRepository.uploadPhoto(photo);
      }
      
      // 7. Mark as uploaded locally
      await applicationRepository.markAsUploaded(applicationId);
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to upload application: $e'));
    }
  }
}
```

---

## 🔄 COMPLETE USER WORKFLOW

### Draft → Completed → Uploaded

```
NEW APPLICATION:
├─ User starts subdivision process
├─ Creates Zone Selection (Step 1)
├─ Views Zone (Step 2)
├─ Records Parcel (Step 3) ← Can save as draft here
├─ currentStep = 3, status = 'draft'
└─ Application appears in "Kazi Zangu" → "Rasimu" tab

RESUME DRAFT:
├─ User opens "Kazi Zangu" → "Rasimu"
├─ Taps on draft application
├─ Opens stepper at Step 3 (currentStep)
├─ Continues: Adds Party (Step 4), Photos (Step 5), Review (Step 6)
├─ On Step 6 completion: currentStep = 6, status = 'completed'
└─ Application moves to "Zimekamilika" tab

UPLOAD COMPLETED:
├─ User opens "Kazi Zangu" → "Zimekamilika"
├─ Taps "Upload" on application
├─ Upload service sends all data to server
├─ On success: uploaded = true, uploadedAt = now
└─ Application moves to "Zimepakiwa" tab
```

---

## 📊 IMPLEMENTATION PRIORITY

### HIGH PRIORITY (Do These First):
1. ✅ Input method selection on button click (DONE)
2. ⏳ Application repository methods for draft/completed/uploaded
3. ⏳ "Kazi Zangu" page with providers and UI
4. ⏳ Stepper progress save/resume logic
5. ⏳ Step status indicators

### MEDIUM PRIORITY:
6. Upload service implementation
7. Error handling and retry logic
8. Offline sync queue

### LOW PRIORITY:
9. Search and filter in "Kazi Zangu"
10. Export to PDF/CSV
11. Analytics and reporting

---

## 🧪 TESTING CHECKLIST

### Draft Management:
- [ ] Create new application, stop at Step 3
- [ ] Application appears in "Rasimu" tab with correct step
- [ ] Open draft from "Rasimu" tab
- [ ] Stepper opens at correct step (Step 3)
- [ ] Progress bar shows correct completion %

### Completion Flow:
- [ ] Complete all 6 steps
- [ ] Application moves to "Zimekamilika" tab
- [ ] No longer appears in "Rasimu" tab

### Upload Flow:
- [ ] Upload completed application
- [ ] All data sent to server in correct order
- [ ] Application moves to "Zimepakiwa" tab
- [ ] No longer appears in "Zimekamilika" tab

### Edge Cases:
- [ ] Multiple drafts at different steps
- [ ] Resume draft, go back to earlier step
- [ ] Cancel during draft editing
- [ ] Network failure during upload
- [ ] Duplicate submission prevention

---

## 📁 FILE STRUCTURE SUMMARY

```
lib/features/ccro/
├── subdivision/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── subdivision_application.dart (UPDATE: add status, currentStep)
│   │   └── repositories/
│   │       └── subdivision_application_repository.dart (UPDATE: add status methods)
│   │
│   ├── data/
│   │   ├── repositories/
│   │   │   └── subdivision_application_repository_impl.dart (IMPLEMENT)
│   │   └── services/
│   │       └── subdivision_upload_service.dart (NEW)
│   │
│   └── presentation/
│       ├── pages/
│       │   ├── subdivision_stepper_page.dart (UPDATE: load/save progress)
│       │   └── parcel_mapping_page.dart (✅ DONE)
│       ├── widgets/
│       │   ├── parcel_drawing_step.dart (✅ DONE)
│       │   └── step_status_indicator.dart (NEW)
│       └── providers/
│           └── application_providers.dart (NEW)
│
└── dashboard/
    └── presentation/
        ├── pages/
        │   └── my_applications_page.dart (UPDATE: wire up providers)
        ├── widgets/
        │   └── application_card.dart (NEW)
        └── providers/
            └── application_providers.dart (NEW)
```

---

## ✅ NEXT IMMEDIATE STEPS

1. **Test Current Implementation:**
   - Run app and test input method selection flow
   - Verify manual entry, tapping, and auto recording all work

2. **Implement Application Repository Methods:**
   - Add draft/completed/uploaded queries
   - Add status update methods

3. **Wire Up "Kazi Zangu" Page:**
   - Create providers
   - Update UI with application lists
   - Add navigation to stepper

4. **Add Progress Tracking:**
   - Update stepper to save currentStep
   - Implement resume functionality

**Estimated Time:** 
- Repository methods: 2-3 hours
- "Kazi Zangu" page: 3-4 hours
- Progress tracking: 2-3 hours
- Testing: 2 hours
**Total:** ~10-12 hours

---

**Last Updated:** 2024-12-01 19:12 UTC+3
**Status:** Input method selection fixed ✅, remaining workflow implementation documented
