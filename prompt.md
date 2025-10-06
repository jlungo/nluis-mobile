Study well this flutter mobile application for Android and iOS and alowly and carefully redevelop/recode it again using this blueprint here, modern and all functionality working is the key: # Flutter App Blueprint — Offline Field Survey App

## 0) Goals & Constraints

* **Mobile-first, lightweight, offline-first** field data collection app.
* **User flow**: Login → **Module switchboard (if >1 module)** → **Dashboard (assigned projects)** → **Per‑project on‑demand download** of initial data (questionnaires + base map) → Go offline to survey & map → Save locally → Sync all or per-item when back online → On logout, ask to clear cached data.
* **No auto-preload**: Nothing heavy downloads until the user chooses a project and confirms the download.
* **Performance**: Snappy UI, minimal background work, on-demand caching.
* **Security**: Strong auth, long-lived offline session; refresh tokens used only when online.

---

## 1) Tech Stack (Flutter)

* **Framework**: Flutter (stable channel), min SDK iOS 14 / Android 8.0.
* **State Management**: **Riverpod (2.x) + StateNotifier** for testable, modular, dependency-injected state.
* **Navigation**: **go_router (13.x)** with declarative routes, nested navigation, typed params, deep links.
* **Animations**: **flutter_animate** (staggered, fades, scales), **Hero**, **Implicit animations**; keep light.
* **Forms**: **reactive_forms** with a custom adapter that maps the API format to controls (see §7).
* **HTTP**: **Dio** with interceptors (auth, retry, logging in debug).
* **Local DB**: **Drift** (SQL) for relational sync & queries.
* **Caching**: Riverpod + Drift repositories; HTTP cache via Dio interceptors.
* **Background jobs**: **workmanager** (Android), conservative background fetch for iOS.
* **Secure storage**: **flutter_secure_storage** for tokens/keys, **shared_preferences** for non-sensitive flags.
* **Maps/Zoning**: **flutter_map**, **turf_dart**, **proj4dart**.
* **File import**: **file_picker**, **excel**, **csv**.
* **GPS**: **geolocator** (optional USB GNSS via usb_serial on Android).
* **i18n**: `flutter_localizations`, `intl` with **Kiswahili (sw)** as default locale.

---

## 2) App Architecture

**Structure preference: Feature → Module → Subfeatures**

```
lib/
  app/                # entry, router, theme, localization
  core/               # error, network, env, utils
  data/               # repositories & data sources
    local/            # Drift DAOs & tables
    remote/           # Dio API clients
  features/
    auth/
    settings/
    land_use/
      dashboard/
      survey/
      zoning/
    ccro/
    monitoring_evaluation/
    compliance/
  shared/
    constants/        # colors, spacing, etc.
    theme/            # theme files
    widgets/
    providers/
    models/
```

* Each **module** (e.g., `land_use`) groups its own dashboard, survey, zoning.
* Shared code (e.g., `FormAdapter`, `Geo` utils, `Sync`) lives under `shared/` or `core/`.

---

## 3) Routing (go_router)

```dart
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', name: 'splash', builder: ...),
    GoRoute(path: '/login', name: 'login', builder: ...),
    GoRoute(path: '/module-switch', name: 'moduleSwitch', builder: ...),
    ShellRoute( // app shell after module selection
      builder: (ctx, st, child) => AppShell(child: child),
      routes: [
        // LAND USE MODULE
        GoRoute(
          path: '/module/land-use/dashboard',
          name: 'luDashboard',
          builder: ...,
        ),
        GoRoute(
          path: '/module/land-use/zoning/:projectId',
          name: 'luZoning',
          builder: ...,
        ),
        GoRoute(
          path: '/module/land-use/survey/:projectId', // list of responses + Add Dodoso
          name: 'luSurveyList',
          builder: ...,
        ),
        GoRoute(
          path: '/module/land-use/survey/:projectId/edit/:responseId',
          name: 'luSurveyEdit', // editor screen for a Dodoso instance
          builder: ...,
        ),
        // other modules (ccro, monitoring_evaluation, compliance) get similar trees
      ],
    ),
  ],
);
```

**Bottom sheet** is invoked from Dashboard (no route); selections navigate to either `luSurveyList` or `luZoning`.

---

## 4) State Management Strategy (Riverpod)

* **Global**: `authStateProvider`, `connectivityProvider`, `syncQueueProvider`, `activeModuleProvider`.
* **Land Use**:

  * `assignedProjectsProvider` → list from API/local for current user (active only).
  * `formsProvider(module: 'land-uses')` → preloaded Dodoso list from API.
  * `responsesProvider(projectId)` → local saved Dodoso instances for a project.
  * `surveyEditorController(responseId)` → manages reactive form state.
  * `zoningController(projectId)` → manages vertices/import/validation.

Example (Assigned Projects):

```dart
@Riverpod(keepAlive: true)
Future<List<Project>> assignedProjects(AssignedProjectsRef ref) async {
  final repo = ref.watch(projectRepoProvider);
  final local = await repo.getAssignedLocal(activeOnly: true);
  unawaited(repo.pullAssignedAndCache());
  return local;
}
```

---

## 5) Data & Sync

### Entities

* **User**
* **Project** (id, name, status, localityId, assignedOn, hasSurvey, hasZoning, updatedAt)
* **ProjectDataPack** (projectId PK, status, downloadedAt, updatedAt, sizeBytes)
* **QuestionnaireType** (id, name, slug)
* **Questionnaire** (id, name, slug, typeId, version, updatedAt)
* **Form (Dodoso)** (slug, name, module_slug, workflow_slug, description, position, fields[])
* **FormField** (id, form_slug, label, type, name, required, position, options[])
* **SurveyResponse** (id, projectId, questionnaireId, answersJson, draft|submitted, updatedAt, dirty, schemaSnapshotJson)
* **BaseMap** (projectId, geojson, updatedAt)
* **ZoningFeature** (id, projectId, type: Polygon|Line|Point, coords[], propertiesJson, draft|submitted, updatedAt, dirty)
* **SyncLog**

### Drift Tables (excerpt)

```sql
Table projects { id TEXT PK; name TEXT; localityId INT; status TEXT; assignedOn INT; hasSurvey BOOL; hasZoning BOOL; updatedAt INT; }
Table project_packs { projectId TEXT PK; status TEXT; downloadedAt INT; updatedAt INT; sizeBytes INT; }
Table questionnaire_types { id INT PK; name TEXT; slug TEXT; localityId INT; }
Table questionnaires { id INT PK; name TEXT; slug TEXT; typeId INT; version TEXT; updatedAt INT; localityId INT; }
Table forms { slug TEXT PK; questionnaireId INT; name TEXT; description TEXT; moduleSlug TEXT; workflowSlug TEXT; position INT; updatedAt INT; }
Table form_fields { id INT PK; formSlug TEXT; label TEXT; type TEXT; name TEXT; required BOOL; position INT; optionsJson TEXT; }
Table survey_responses { id TEXT PK; projectId TEXT; questionnaireId INT; formSlug TEXT?; answersJson TEXT; isDraft BOOL; updatedAt INT; dirty BOOL; schemaSnapshotJson TEXT; }
Table base_maps { projectId TEXT PK; geoJson TEXT; updatedAt INT; }
Table zoning_features { id TEXT PK; projectId TEXT; geomType TEXT; coordsJson TEXT; propertiesJson TEXT; isDraft BOOL; updatedAt INT; dirty BOOL; }
Table sync_logs { id TEXT PK; refType TEXT; refId TEXT; op TEXT; status TEXT; lastError TEXT?; updatedAt INT; }
```

### Download Manager (Project Pack)

* Calculates size estimate (if server provides) and shows progress.
* Steps: questionnaire types → questionnaires → forms → base map.
* Stores `schemaSnapshot` hashes for quick change detection.

### Sync Model

* **Pull**: Only on explicit project pack download or explicit update.
* **Push**: Queue dirty `survey_responses` and `zoning_features`. Push all or per-item.
* **Conflict**: Server wins for schemas/assignments; client wins for drafts; submissions use versioning.
* **Connectivity**: Monitor and queue when offline.

---

## 6) Authentication

* **Base URL**: `http://144.91.125.106:8000/api/v1`
* **Flow**: Email/password → `POST /auth/login/` → `access`, `refresh`, `expires_in`, `user` (with `mobile_modules`). Store tokens in **secure storage**.
* **Long-lived offline session**: Never force logout while offline. Only refresh tokens **when the app attempts an online call**. If refresh fails due to network, keep session and switch to offline mode.
* **Token refresh**: Dio interceptor on 401:

  1. If online, call `POST /auth/refresh/` (or re-login flow if required by server).
  2. Replay failed requests after refresh.
  3. If still unauthorized, show a gentle re-auth prompt.
* **Role checks**: Use server-provided roles to filter editor permissions on forms.

---

## 7) Dynamic Forms (from API — your format)

**Source family** (Land Use module example):

* **Questionnaire types (by locality)**: `GET /localities/{locality_id}/questionnaire-types/`
* **Questionnaires (by locality & type)**: `GET /localities/{locality_id}/questionnaires/?type_id=...&limit=...&offset=...`
* **Forms (by questionnaire id or slug)**: `GET /questionnaires/{questionnaire_id}/forms/` or `/questionnaires/by-slug/{slug}/forms/`

### On‑Demand Project Data Pack

* When the user taps a **project** on Dashboard, show a **confirm dialog** to download initial data:

  * All **questionnaire types** for the project's `locality_id`.
  * The **list of questionnaires** per type (IDs, versions, timestamps).
  * The **forms** (with `form_fields` + `select_options`) for each questionnaire.
  * The **base map** GeoJSON for zoning (endpoint TBD by backend, e.g., `/projects/{id}/basemap/`).
* Cache them locally so Dodoso can be used fully offline.

### Model Mapping → Widgets

* Map your `form_fields` directly to reactive controls (text, number, select, multiselect, file, members, etc.).
* Persist **drafts** per `(projectId, questionnaireId)` with `answers` as `{ form_field: value }`.
* Submit payload to `POST /questionnaire-responses/` with server field IDs.

### Adapter Layer (unchanged in spirit)

* Continue to use a **FormAdapter** that orders fields by `position`, binds by `name`, and applies `required` rules. Store `schema_snapshot` with each response so edits remain stable if the server updates later.

---

## 8) Zoning Interface (Map-centric, boundary-constrained, point-based)

### Base Map

* Download **GeoJSON** base map as part of the **Project Data Pack**. Cache per project.
* Render via `flutter_map` GeoJSON layer.
* **Constraint**: All zoning features **must lie within** the base boundary. Enforce with `turf_dart` (`booleanPointInPolygon`, `booleanContains`).

### Geometry from Points (GPS / Manual / Excel)

* GPS capture, manual Lat/Lon or UTM entry, or Excel/CSV upload (`order, lat, lon` or UTM columns). Convert UTM↔WGS84 with `proj4dart`.
* Validate vertices on entry; highlight any outside-boundary points; prevent Save until valid.

### Offline First

* Zoning is enabled only after the **base map** is present. If missing, show prompt to download the Project Data Pack.

---

## 9) Page-by-Page Implementation

### 9.1 Splash Screen

* Gradient background; center logo with scale+fade (800ms). Version text at bottom.

### 9.2 Login Page

* Glassmorphism card, floating labels. Validation & smooth errors. (No biometrics.)

### 9.3 **Module Switchboard**

* If the user has multiple modules, show a grid of module cards (from API). Selecting a module filters forms/projects/base maps.

### 9.4 Module Dashboard (Land Use)

* Lists **active projects** assigned to the logged-in user (from API/local).
* On project tap → **Bottom Sheet**:

  * If project **data pack not present**: Show **Download Initial Data** (questionnaires + base map). After success, reveal actions.
  * If data pack present:

    1. **Perform Survey (Dodoso)** → `/module/land-use/survey/:projectId`
    2. **Zoning** → `/module/land-use/zoning/:projectId`

**Download Confirm Dialog (snippet)**

```dart
Future<void> _confirmDownloadPack(BuildContext ctx, Project p) async {
  final ok = await showDialog<bool>(
    context: ctx,
    builder: (_) => AlertDialog(
      title: Text('Download data for ${p.projectName}?'),
      content: const Text('This will save questionnaires and base map for offline use.'),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(_, false), child: const Text('Cancel')),
        ElevatedButton(onPressed: ()=>Navigator.pop(_, true), child: const Text('Download')),
      ],
    ),
  );
  if (ok == true) ref.read(projectPackControllerProvider(p.id).notifier).download();
}
```

**Bottom Sheet Snippet**

```dart
void _showProjectActions(BuildContext ctx, WidgetRef ref, Project p, bool hasPack) {
  showModalBottomSheet(
    context: ctx,
    builder: (_) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (!hasPack)
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Download Initial Data'),
            onTap: () => _confirmDownloadPack(ctx, p),
          ),
        if (hasPack) ...[
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Perform Survey (Dodoso)'),
            onTap: () => context.goNamed('luSurveyList', params: {'projectId': p.id}),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Zoning'),
            onTap: () => context.goNamed('luZoning', params: {'projectId': p.id}),
          ),
        ]
      ]),
    ),
  );
}
```

### 9.5 Land Use Dashboard

* List/Grid hybrid; pull-to-refresh; infinite scroll; status badges.
  Land Use Dashboard
* List/Grid hybrid; pull-to-refresh; infinite scroll; status badges.
  Land Use Dashboard
* List/Grid hybrid; `SliverAppBar` with filters; pull-to-refresh; infinite scroll.
* Status badges; progress indicators.

### 9.6 Project Detail Page

* Parallax header; Tabs: Overview | Surveys | Zoning | Timeline.

### 9.7 Survey Flow (Dodoso)

* **On-demand**: Dodoso (forms) are downloaded only when the user downloads the **Project Data Pack**.
* **Survey List Screen**: shows filled Dodoso for the project with summary (draft/submitted, last updated).
* **Add Dodoso** button → choose from **available questionnaires** bundled in the project pack (by type → questionnaire → forms).
* Editor: reactive fields; draft autosave; edit/reopen; submit enqueues to sync.
* If user is **offline** and tries to open a questionnaire not in the pack, show **Offline dialog/snackbar** and block the action.

**Offline Prompt**

```dart
void showOfflinePrompt(BuildContext ctx) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    const SnackBar(content: Text('You are offline. Some actions need connectivity.')),
  );
}
```

### 9.8 Zoning

* Enabled only after base map is downloaded. Containment checks per §8.
  Zoning
* Floating tool palette (Add Vertex, Import, Validate, Save). Bottom sheet with vertex list.
* Containment checks against base map as per §8.
  Zoning
* Floating tool palette (Add Vertex, Import, Validate, Save). Bottom sheet with vertex list.
* Containment checks against base map as per §8.

### 9.9 Settings & Profile

* Grouped list with theme picker, avatar edit, About.