import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/core/config/di/locator.dart';
import 'package:muslim/src/core/config/locale/app_locale.dart';
import 'package:muslim/src/core/config/router/app_router.dart';
import 'package:muslim/src/core/config/theme/theme_config.dart';
import 'package:muslim/src/core/setting/setting.dart';
import 'package:muslim/src/presentation/business_logic/auth_bloc/auth_bloc.dart';
import 'package:muslim/src/presentation/business_logic/internet_cubit/internet_cubit.dart';
import 'package:muslim/src/presentation/business_logic/locale_cubit/locale_cubit.dart';
import 'package:muslim/src/presentation/business_logic/user_bloc/user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Setting.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (_) => locator<LocaleCubit>()..getSavedLanguage(),
        ),
        BlocProvider<InternetCubit>(
          create: (_) => locator<InternetCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => locator<AuthBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (_) => locator<UserBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              if (state is ChangeLocaleState) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeConfig.darkTheme,
                  title: 'Muslim',
                  locale: state.locale,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    AppLocale.delegate
                  ],
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('ar', 'AE'),
                    Locale('fr', 'FR'),
                  ],
                  localeResolutionCallback:
                      (currentLanguage, supportedLanguage) {
                    if (currentLanguage != null) {
                      for (Locale locale in supportedLanguage) {
                        if (locale.languageCode ==
                            currentLanguage.languageCode) {
                          return currentLanguage;
                        }
                      }
                    }
                    return supportedLanguage.first;
                  },
                  routes: AppRouter.routes,
                  initialRoute: '/',
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
