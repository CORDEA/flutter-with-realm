import 'dart:async';

import 'package:flutter/services.dart';

class RealmHelper {
  static const String resultKey = 'result';

  final String _channel = 'realm';

  Future search(Map params) {
    var payload = {'method': 'search'};
    payload['params'] = params;
    return HostMessages.sendJSON(_channel, payload);
  }

  Future load() {
    return HostMessages.sendJSON(_channel, {'method': 'load'});
  }

  Future save(Map params) {
    var payload = {'method': 'save'};
    payload['params'] = params;
    return HostMessages.sendJSON(_channel, payload);
  }

  Future delete() {
    return HostMessages.sendJSON(_channel, {'method': 'delete'});
  }

}