import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

class DataHolder {
  QBSession _session;
  QBUser _qbUser;

  static DataHolder _instance;

  static DataHolder getInstance() {
    if (_instance == null) {
      _instance = DataHolder();
    }
    return _instance;
  }

  void setSession(QBSession session) {
    this._session = session;
  }

  QBSession getSession() {
    return _session;
  }

  void setUser(QBUser qbUser) {
    this._qbUser = qbUser;
  }

  QBUser getUser() {
    return _qbUser;
  }
}
