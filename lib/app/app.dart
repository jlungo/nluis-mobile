import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/app_database.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../core/services/draft_service.dart';
import '../core/services/file_upload_service.dart';
import '../core/services/export_service.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth/auth_event.dart';
import '../features/auth/presentation/bloc/auth/auth_state.dart';
import '../features/auth/presentation/bloc/login/login_bloc.dart';
import '../features/projects/data/datasources/project_local_datasource.dart';
import '../features/projects/data/datasources/project_remote_datasource.dart';
import '../features/projects/data/repositories/project_repository_impl.dart';
import '../features/projects/domain/repositories/project_repository.dart';
import '../features/projects/presentation/bloc/projects_bloc.dart';
import '../features/land_use/dashboard/data/datasources/survey_stats_local_datasource.dart';
import '../features/land_use/dashboard/data/repositories/survey_stats_repository_impl.dart';
import '../features/land_use/dashboard/domain/repositories/survey_stats_repository.dart';
import '../features/land_use/dashboard/presentation/bloc/survey_stats_bloc.dart';
import '../features/land_use/survey/data/datasources/survey_local_datasource.dart';
import '../features/land_use/survey/data/repositories/survey_repository_impl.dart';
import '../features/land_use/survey/data/repositories/survey_upload_repository_impl.dart';
import '../features/land_use/survey/data/datasources/survey_upload_remote_datasource.dart';
import '../features/land_use/survey/domain/repositories/survey_repository.dart';
import '../features/land_use/survey/domain/repositories/survey_upload_repository.dart';
import '../features/land_use/survey/presentation/bloc/survey_list_bloc.dart';
import '../features/land_use/survey/presentation/bloc/survey_upload_bloc.dart';
import '../features/land_use/survey/data/datasources/questionnaire_remote_datasource.dart';
import '../features/land_use/survey/data/repositories/questionnaire_repository_impl.dart';
import '../features/land_use/survey/domain/repositories/questionnaire_repository.dart';
import '../features/land_use/survey/presentation/bloc/questionnaire_bloc.dart';
import '../features/land_use/survey/data/datasources/questionnaire_detail_remote_datasource.dart';
import '../features/land_use/survey/data/repositories/questionnaire_detail_repository_impl.dart';
import '../features/land_use/survey/domain/repositories/questionnaire_detail_repository.dart';
import '../features/land_use/survey/presentation/bloc/survey_form_bloc.dart';
import '../shared/theme/app_theme.dart';
import 'router/app_router.dart';

class App extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const App({super.key, required this.sharedPreferences});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final DioClient _dioClient;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _dioClient = DioClient(
      sharedPreferences: widget.sharedPreferences,
      networkInfo: NetworkInfoImpl(Connectivity()),
      onTokenRefreshFailedWhileOnline: () async {
        _authBloc.add(const SessionExpired());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>(create: (context) => AppDatabase()),
        RepositoryProvider<NetworkInfo>(
          create: (context) => NetworkInfoImpl(Connectivity()),
        ),
        RepositoryProvider<DioClient>(create: (context) => _dioClient),
        RepositoryProvider<AuthRepository>(
          create:
              (context) => AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(
                  context.read<DioClient>(),
                ),
                localDataSource: AuthLocalDataSourceImpl(
                  sharedPreferences: widget.sharedPreferences,
                ),
              ),
        ),
        RepositoryProvider<QuestionnaireRepository>(
          create:
              (context) => QuestionnaireRepositoryImpl(
                remoteDataSource: QuestionnaireRemoteDataSourceImpl(
                  context.read<DioClient>(),
                ),
                networkInfo: context.read<NetworkInfo>(),
              ),
        ),
        RepositoryProvider<QuestionnaireDetailRepository>(
          create:
              (context) => QuestionnaireDetailRepositoryImpl(
                remoteDataSource: QuestionnaireDetailRemoteDataSourceImpl(
                  context.read<DioClient>(),
                ),
                networkInfo: context.read<NetworkInfo>(),
              ),
        ),
        RepositoryProvider<SurveyRepository>(
          create:
              (context) => SurveyRepositoryImpl(
                localDataSource: SurveyLocalDataSourceImpl(
                  database: context.read<AppDatabase>(),
                ),
              ),
        ),
        RepositoryProvider<SurveyUploadRepository>(
          create:
              (context) => SurveyUploadRepositoryImpl(
                remoteDataSource: SurveyUploadRemoteDataSourceImpl(
                  context.read<DioClient>(),
                  context.read<FileUploadService>(),
                ),
                networkInfo: context.read<NetworkInfo>(),
                database: context.read<AppDatabase>(),
              ),
        ),
        RepositoryProvider<SurveyStatsRepository>(
          create:
              (context) => SurveyStatsRepositoryImpl(
                localDataSource: SurveyStatsLocalDataSourceImpl(
                  database: context.read<AppDatabase>(),
                ),
              ),
        ),
        RepositoryProvider<ProjectRepository>(
          create:
              (context) => ProjectRepositoryImpl(
                remoteDataSource: ProjectRemoteDataSourceImpl(
                  context.read<DioClient>(),
                ),
                localDataSource: ProjectLocalDataSourceImpl(
                  sharedPreferences: widget.sharedPreferences,
                  database: context.read<AppDatabase>(),
                ),
                networkInfo: context.read<NetworkInfo>(),
              ),
        ),
        RepositoryProvider<DraftService>(
          create: (context) => DraftService(context.read<AppDatabase>()),
        ),
        RepositoryProvider<FileUploadService>(
          create: (context) => FileUploadService(context.read<DioClient>()),
        ),
        RepositoryProvider<ExportService>(
          create: (context) => ExportService(context.read<AppDatabase>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) {
              _authBloc = AuthBloc(repository: context.read<AuthRepository>());
              return _authBloc;
            },
          ),
          BlocProvider<LoginBloc>(
            create:
                (context) =>
                    LoginBloc(repository: context.read<AuthRepository>()),
          ),
          BlocProvider<ProjectsBloc>(
            create:
                (context) =>
                    ProjectsBloc(repository: context.read<ProjectRepository>()),
          ),
          BlocProvider<SurveyStatsBloc>(
            create:
                (context) => SurveyStatsBloc(
                  repository: context.read<SurveyStatsRepository>(),
                ),
          ),
          BlocProvider<SurveyListBloc>(
            create:
                (context) => SurveyListBloc(
                  repository: context.read<SurveyRepository>(),
                ),
          ),
          BlocProvider<QuestionnaireBloc>(
            create:
                (context) => QuestionnaireBloc(
                  repository: context.read<QuestionnaireRepository>(),
                ),
          ),
          BlocProvider<SurveyFormBloc>(
            create:
                (context) => SurveyFormBloc(
                  questionnaireDetailRepository:
                      context.read<QuestionnaireDetailRepository>(),
                  draftService: context.read<DraftService>(),
                ),
          ),
          BlocProvider<SurveyUploadBloc>(
            create:
                (context) => SurveyUploadBloc(
                  repository: context.read<SurveyUploadRepository>(),
                ),
          ),
        ],
        child: Builder(
          builder: (context) {
            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Unauthenticated || state is SessionExpiredState) {
                  appRouter.go('/login');
                }
              },
              child: MaterialApp.router(
                title: 'NLUIS Collect',
                theme: AppTheme.lightTheme,
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter,
              ),
            );
          },
        ),
      ),
    );
  }
}
