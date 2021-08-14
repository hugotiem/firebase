import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('onEvent $event');
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    print('onTransition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase blocBase, Change change) {
    print('onChange $change');
    super.onChange(blocBase, change);
  }

  @override
  void onError(BlocBase blocBase, Object error, StackTrace stackTrace) {
    print('onError $error');
    super.onError(blocBase, error, stackTrace);
  }
}
