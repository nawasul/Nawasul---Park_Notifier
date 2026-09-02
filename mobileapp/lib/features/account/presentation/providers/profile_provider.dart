import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/mock/mock_auth_data.dart';

class ProfileNotifier extends Notifier<MockUser> {
  @override
  MockUser build() => MockAuthData.primaryUser;

  void updateProfile({String? name, String? city}) {
    state = state.copyWith(name: name, city: city);
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, MockUser>(ProfileNotifier.new);
