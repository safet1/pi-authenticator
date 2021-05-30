/*
  privacyIDEA Authenticator

  Authors: Timo Sturm <timo.sturm@netknights.it>

  Copyright (c) 2017-2021 NetKnights GmbH

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pi_authenticator_legacy/pi_authenticator_legacy.dart';
import 'package:privacyidea_authenticator/model/firebase_config.dart';
import 'package:privacyidea_authenticator/model/tokens.dart';
import 'package:privacyidea_authenticator/utils/crypto_utils.dart';
import 'package:privacyidea_authenticator/utils/localization_utils.dart';
import 'package:privacyidea_authenticator/utils/network_utils.dart';
import 'package:privacyidea_authenticator/utils/storage_utils.dart';

class UpdateFirebaseTokenDialog extends StatefulWidget {
  final GlobalKey<ScaffoldState>
      _scaffoldKey; // Used to display messages to user.

  const UpdateFirebaseTokenDialog(
      {Key key, GlobalKey<ScaffoldState> scaffoldKey})
      : this._scaffoldKey = scaffoldKey,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdateFirebaseTokenDialogState();
}

class _UpdateFirebaseTokenDialogState extends State<UpdateFirebaseTokenDialog> {
  Widget _content = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[CircularProgressIndicator()],
  );

  @override
  void initState() {
    super.initState();
    _updateFbTokens();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        title: Text(Localization.of(context).synchronizePushDialogTitle),
        content: _content,
        actions: <Widget>[
          RaisedButton(
            child: Text(Localization.of(context).dismiss),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _updateFbTokens() async {
    log('Starting update of firebase token.',
        name: 'update_firebase_token_dialog.dart');

    List<PushToken> tokenList =
        (await StorageUtil.loadAllTokens()).whereType<PushToken>().toList();

    // Filter poll-only tokens, they cannot be synced here.
    Map<PushToken, FirebaseConfig> configMap = {};
    for (PushToken p in tokenList) {
      configMap[p] = await StorageUtil.loadFirebaseConfig(p);
    }

    tokenList.removeWhere((e) => configMap[e].projectID == null);

    if (tokenList.isEmpty) {
      setState(() {
        _content = Text(Localization.of(context).allTokensSynchronized);
      });
      return;
    }

    String token = await FirebaseMessaging().getToken();

    // TODO Is there a good way to handle these tokens?
    List<PushToken> tokenWithOutUrl =
        tokenList.where((e) => e.url == null).toList();
    List<PushToken> tokenWithUrl =
        tokenList.where((e) => e.url != null).toList();
    List<PushToken> tokenWithFailedUpdate = [];

    for (PushToken p in tokenWithUrl) {
      // POST /ttype/push HTTP/1.1
      //Host: example.com
      //
      //new_fb_token=<new firebase token>
      //serial=<tokenserial>element
      //timestamp=<timestamp>
      //signature=SIGNATURE(<new firebase token>|<tokenserial>|<timestamp>)

      String timestamp = DateTime.now().toUtc().toIso8601String();

      String message = '$token|${p.serial}|$timestamp';

      String signature = p.privateTokenKey == null
          ? await Legacy.sign(p.serial, message)
          : createBase32Signature(p.getPrivateTokenKey(), utf8.encode(message));

      Response response;
      try {
        response = await doPost(sslVerify: p.sslVerify, url: p.url, body: {
          'new_fb_token': token,
          'serial': p.serial,
          'timestamp': timestamp,
          'signature': signature
        });
      } on SocketException catch (e) {
        log('Socket exception occurred: $e',
            name: 'update_firebase_token_dialog.dart');
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              Localization.of(context).errorSynchronizationNoNetworkConnection),
          duration: Duration(seconds: 3),
        ));
        Navigator.pop(context);
        return;
      }

      if (response != null && response.statusCode == 200) {
        log('Updating firebase token for push token: ${p.serial} succeeded!',
            name: 'update_firebase_token_dialog.dart');
      } else {
        log('Updating firebase token for push token: ${p.serial} failed!',
            name: 'update_firebase_token_dialog.dart');
        tokenWithFailedUpdate.add(p);
      }
    }

    if (tokenWithFailedUpdate.isEmpty && tokenWithOutUrl.isEmpty) {
      setState(() {
        _content = Text(Localization.of(context).allTokensSynchronized);
      });
    } else {
      List<Widget> children = [];

      if (tokenWithFailedUpdate.isNotEmpty) {
        children.add(
            Text(Localization.of(context).synchronizationFailedForTheseTokens));
        for (PushToken p in tokenWithFailedUpdate) {
          children.add(Text('• ${p.label}'));
        }
      }

      if (tokenWithOutUrl.isNotEmpty) {
        if (children.isNotEmpty) {
          children.add(Divider());
        }

        children.add(Text(Localization.of(context)
            .synchronizationNotSupportedForTheseTokens));
        for (PushToken p in tokenWithOutUrl) {
          children.add(Text('• ${p.label}'));
        }
      }

      final ScrollController controller = ScrollController();

      setState(() {
        _content = Scrollbar(
          isAlwaysShown: true,
          controller: controller,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        );
      });
    }
  }
}
