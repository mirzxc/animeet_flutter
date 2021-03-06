import 'package:animeet/bloc/login/login_cubit.dart';
import 'package:animeet/bloc/match/match_cubit.dart';
import 'package:animeet/bloc/sign_up/signUp_cubit.dart';
import 'package:animeet/bloc/swipe/swipe_bloc.dart';
import 'package:animeet/bloc/user/user_cubit.dart';
import 'package:animeet/data/models/user.dart';
import 'package:animeet/data/services/login/login_repository.dart';
import 'package:animeet/data/services/match/match_repository.dart';
import 'package:animeet/data/services/sign_up/sign_up_repository.dart';
import 'package:animeet/data/services/user/user_repository.dart';
import 'package:animeet/ui/screens/home_screen.dart';
import 'package:animeet/ui/screens/login_screen.dart';
import 'package:animeet/ui/screens/profile_screen.dart';
import 'package:animeet/ui/screens/signUp_screen.dart';
import 'package:animeet/ui/screens/updateUser_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animeet/constants/locator.dart';
import 'package:animeet/bloc/authentication/authentication_cubit.dart';
import 'package:animeet/data/services/authentication/auth_repository.dart';
import 'package:animeet/ui/screens/authentication_screen.dart';

import 'package:animeet/constants/paths.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AUTH:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                AuthenticationCubit(getIt<AuthenticationRepository>())..auth(),
            child: const AuthenticationScreen(),
          ),
        );
      case LOGIN:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LogInCubit(getIt<LoginRepository>()),
            // child: const LogInPage(),
            child: const LogInPage(),
          ),
        );
      // case HOME:
      //   getIt.unSignUp<TweetCubit>();
      //   getIt.SignUpSingleton(TweetCubit(getIt<TweetRepository>()));
      //   getIt.unSignUp<CommentCubit>();
      //   getIt.SignUpSingleton(CommentCubit(getIt<CommentRepository>()));
      //   return CupertinoPageRoute(
      //       builder: (_) => MultiBlocProvider(
      //         providers: [
      //           BlocProvider(
      //             create: (context) => getIt<TweetCubit>()..fetchTweets(),
      //           ),
      //           BlocProvider(
      //             create: (context) => getIt<CommentCubit>(),
      //           ),
      //         ],
      //         child: const HomePage(),
      //       )
      //   );
      case SIGNUP:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SignUpCubit(getIt<SignUpRepository>()),
            child: const SignUpPage(),
          ),
        );
      case HOME:

        getIt.unregister<SwipeBloc>();
        getIt.unregister<UserCubit>();
        getIt.unregister<MatchCubit>();
        getIt.registerSingleton(SwipeBloc(getIt<UserRepository>()));
        getIt.registerSingleton(UserCubit(getIt<UserRepository>()));
        getIt.registerSingleton(MatchCubit(getIt<MatchRepository>()));
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => getIt<SwipeBloc>()),
              BlocProvider(
                create: (context) => getIt<UserCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<MatchCubit>(),
              ),
            ],
            child: const HomePage(),
          ),
        );
      case PROFILE:
        final UserModel args = settings.arguments as UserModel;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<UserCubit>(),
            child: ProfileScreen(user: args),
          ),
        );
      case UPDATE:
        if (getIt.isRegistered<UserCubit>())
          getIt.unregister<UserCubit>();

        getIt.registerSingleton(UserCubit(getIt<UserRepository>()));
        final UserModel args = settings.arguments as UserModel;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<UserCubit>(),
            child: UpdateUserScreen(user: args),
          ),
        );
      default:
        return null;
    }
  }
}
