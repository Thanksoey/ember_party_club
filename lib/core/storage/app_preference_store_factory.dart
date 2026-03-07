import 'app_preference_store.dart';
import 'app_preference_store_stub.dart'
    if (dart.library.html) 'app_preference_store_web.dart'
    if (dart.library.io) 'app_preference_store_io.dart';

AppPreferenceStore createPreferenceStore() => createPreferenceStoreImpl();
