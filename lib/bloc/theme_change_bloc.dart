import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'theme_change_event.dart';
import 'theme_change_state.dart';

class ThemeChangeBloc extends HydratedBloc<ThemeChangeEvent, ThemeChangeState> {
  ThemeChangeBloc() : super(LightThemeState());

  @override
  ThemeChangeState fromJson(Map<String, dynamic> json) {
    bool isLightMode = json["isLightMode"] as bool;
    if (isLightMode) {
      return LightThemeState();
    } else {
      return DarkThemeState();
    }
  }

  @override
  Map<String, dynamic> toJson(ThemeChangeState state) {
    return {"isLightMode": state.themeState.isLightMode};
  }

  Stream<ThemeChangeState> mapEventToState(ThemeChangeEvent event) async* {
    if (event is OnThemeChangedEvent) {
      yield* _onChangedTheme(event.lightMode);
    }
  }

  Stream<ThemeChangeState> _onChangedTheme(bool lightMode) async* {
    if (lightMode) {
      yield DarkThemeState();
    } else {
      yield LightThemeState();
    }
  }
}
