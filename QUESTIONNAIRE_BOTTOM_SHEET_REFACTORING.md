# Questionnaire Bottom Sheet Refactoring

## Overview
Refactored `QuestionnaireListBottomSheet` to be a fully reusable widget by removing hardcoded data and accepting questionnaires as an optional parameter.

## Changes Made

### 1. **QuestionnaireListBottomSheet Widget** (`lib/shared/widgets/questionnaire_list_bottom_sheet.dart`)

#### Added Optional Parameter
- **New parameter**: `hardcodedQuestionnaires` (List<Questionnaire>?)
- **Purpose**: Allow passing custom questionnaire lists instead of fetching from API

#### Updated Logic
- **Title Display**: Uses `hardcodedQuestionnaires != null` check instead of module type
  - When hardcoded data provided: Shows "Chagua Fomu" (Choose Form)
  - When fetching from API: Shows "Chagua Dodoso" (Choose Questionnaire)

- **Search Hint**: Updates based on data source
  - Hardcoded: "Tafuta fomu..." (Search forms...)
  - API: "Tafuta dodoso..." (Search questionnaires...)

- **Empty State**: Dynamic message based on data source

#### Added Helper Method
```dart
Widget _buildHardcodedList(
  List<Questionnaire> questionnaires,
  bool isDark,
  ThemeData theme,
)
```
- Handles rendering of hardcoded questionnaires
- Implements search filtering on name and description
- Displays empty state when no matches found
- Maintains same UI/UX as API-fetched questionnaires

#### Updated Static Show Method
```dart
static void show(
  BuildContext context, {
  required String projectId,
  required String projectName,
  required String module,
  String? category,
  required Function(String questionnaireSlug) onQuestionnaireSelected,
  List<Questionnaire>? hardcodedQuestionnaires,  // NEW
})
```

### 2. **Subdivision Applications Page** (`lib/features/ccro/subdivision/presentation/pages/subdivision_applications_page.dart`)

#### Added Import
```dart
import '../../../../../shared/models/questionnaire.dart';
```

#### Updated Database Import
```dart
import '../../../../../data/local/database.dart' as db;
```
- Added alias to resolve name conflict between:
  - `Questionnaire` model class (from shared/models)
  - `Questionnaire` database table (from Drift)

#### Updated Type References
- Changed `SubdivisionApplication` → `db.SubdivisionApplication`
- Updated in: `_draftApplications`, `_completedApplications`, `_uploadedApplications`
- Updated method signature: `_buildApplicationsList(List<db.SubdivisionApplication> applications)`

#### Added Hardcoded CCRO Forms
In `_showQuestionnaireListSheet()` method:
```dart
final ccroForms = <Questionnaire>[
  Questionnaire(
    name: 'Fomu 18A',
    slug: 'fomu-18a',
    category: 1,
    version: 1,
    isActive: true,
    moduleSlug: 'land-sub-divisions',
    moduleName: 'Adjudication',
    questionnaireSectionsCount: 1,
    description: 'Fomu ya Maombi ya Ardhi ya Kijiji kwa Mtu Binafsi',
  ),
  // ... Fomu 18B, 18C, 18D
];
```

#### Updated Bottom Sheet Call
```dart
QuestionnaireListBottomSheet.show(
  context,
  projectId: widget.projectId,
  projectName: widget.projectName,
  module: 'land-sub-divisions',
  hardcodedQuestionnaires: ccroForms,  // PASS HARDCODED DATA
  onQuestionnaireSelected: (questionnaireSlug) { ... },
);
```

## Benefits Achieved

### ✅ Reusability
- Shared widget is now generic and can be used by any module
- No hardcoded data in shared components
- Can work with API-fetched or hardcoded data

### ✅ Separation of Concerns
- Module-specific data kept in module-specific code
- Shared widget handles only UI/UX logic
- Clear boundary between shared and feature code

### ✅ Maintainability
- CCRO forms are defined where they're used
- Easy to update forms without touching shared widgets
- Other modules can still use API-fetched questionnaires

### ✅ Flexibility
- Can pass different form lists for different contexts
- Search and filtering work for both data sources
- Consistent UI/UX regardless of data source

## CCRO Forms Included

1. **Fomu 18A**: Fomu ya Maombi ya Ardhi ya Kijiji kwa Mtu Binafsi
2. **Fomu 18B**: Fomu ya Maombi ya Ardhi ya Kijiji kwa Kundi la Watu
3. **Fomu 18C**: Fomu ya Maombi ya Ardhi ya Kijiji kwa Kundi la Watu wasio Wakazi
4. **Fomu 18D**: Fomu ya Maombi ya Ardhi ya Kijiji kwa Taasisi

## Usage Examples

### With Hardcoded Data (CCRO Module)
```dart
QuestionnaireListBottomSheet.show(
  context,
  projectId: projectId,
  projectName: projectName,
  module: 'land-sub-divisions',
  hardcodedQuestionnaires: ccroForms,
  onQuestionnaireSelected: (slug) { ... },
);
```

### With API-Fetched Data (Other Modules)
```dart
QuestionnaireListBottomSheet.show(
  context,
  projectId: projectId,
  projectName: projectName,
  module: 'some-module',
  category: 'category-slug',
  onQuestionnaireSelected: (slug) { ... },
  // hardcodedQuestionnaires is null, so API will be used
);
```

## Files Modified

1. `lib/shared/widgets/questionnaire_list_bottom_sheet.dart`
   - Added `hardcodedQuestionnaires` parameter
   - Added `_buildHardcodedList` method
   - Updated title, search hint, and empty state logic
   - Removed hardcoded sample data

2. `lib/features/ccro/subdivision/presentation/pages/subdivision_applications_page.dart`
   - Added Questionnaire model import
   - Added database import alias
   - Added hardcoded CCRO forms list
   - Updated type references with db prefix
   - Pass hardcoded forms to bottom sheet

## Testing Checklist

- ✅ Code compiles without errors
- ✅ No lint warnings
- [ ] Test opening forms list in CCRO subdivision module
- [ ] Test search functionality with hardcoded forms
- [ ] Verify form selection navigates correctly
- [ ] Test other modules still fetch from API correctly
- [ ] Verify dark mode appearance

## Future Improvements

1. Consider moving CCRO forms to a constants file if used in multiple places
2. Add form versioning support if forms evolve over time
3. Consider caching API-fetched questionnaires locally
4. Add form download/offline capability if needed
