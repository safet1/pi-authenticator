// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HOTPToken _$HOTPTokenFromJson(Map<String, dynamic> json) {
  return HOTPToken(
      label: json['label'] as String,
      issuer: json['issuer'] as String,
      uuid: json['uuid'] as String,
      algorithm: _$enumDecodeNullable(_$AlgorithmsEnumMap, json['algorithm']),
      digits: json['digits'] as int,
      secret: (json['secret'] as List)?.map((e) => e as int)?.toList(),
      counter: json['counter'] as int);
}

Map<String, dynamic> _$HOTPTokenToJson(HOTPToken instance) => <String, dynamic>{
      'label': instance.label,
      'uuid': instance.uuid,
      'issuer': instance.issuer,
      'algorithm': _$AlgorithmsEnumMap[instance.algorithm],
      'digits': instance.digits,
      'secret': instance.secret,
      'counter': instance.counter
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$AlgorithmsEnumMap = <Algorithms, dynamic>{
  Algorithms.SHA1: 'SHA1',
  Algorithms.SHA256: 'SHA256',
  Algorithms.SHA512: 'SHA512'
};

TOTPToken _$TOTPTokenFromJson(Map<String, dynamic> json) {
  return TOTPToken(
      label: json['label'] as String,
      issuer: json['issuer'] as String,
      uuid: json['uuid'] as String,
      algorithm: _$enumDecodeNullable(_$AlgorithmsEnumMap, json['algorithm']),
      digits: json['digits'] as int,
      secret: (json['secret'] as List)?.map((e) => e as int)?.toList(),
      period: json['period'] as int);
}

Map<String, dynamic> _$TOTPTokenToJson(TOTPToken instance) => <String, dynamic>{
      'label': instance.label,
      'uuid': instance.uuid,
      'issuer': instance.issuer,
      'algorithm': _$AlgorithmsEnumMap[instance.algorithm],
      'digits': instance.digits,
      'secret': instance.secret,
      'period': instance.period
    };

PushToken _$PushTokenFromJson(Map<String, dynamic> json) {
  return PushToken(
      label: json['label'] as String,
      serial: json['serial'] as String,
      issuer: json['issuer'] as String,
      uuid: json['uuid'] as String,
      sslVerify: json['sslVerify'] as bool,
      enrollmentCredentials: json['enrollmentCredentials'] as String,
      url: json['url'] == null ? null : Uri.parse(json['url'] as String),
      firebaseToken: json['firebaseToken'] as String,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String))
    ..isRolledOut = json['isRolledOut'] as bool
    ..publicServerKey = json['publicServerKey'] == null
        ? null
        : SerializableRSAPublicKey.fromJson(
            json['publicServerKey'] as Map<String, dynamic>)
    ..privateTokenKey = json['privateTokenKey'] == null
        ? null
        : SerializableRSAPrivateKey.fromJson(
            json['privateTokenKey'] as Map<String, dynamic>)
    ..pushRequests = json['pushRequests'] == null
        ? null
        : PushRequestQueue.fromJson(
            json['pushRequests'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PushTokenToJson(PushToken instance) => <String, dynamic>{
      'label': instance.label,
      'uuid': instance.uuid,
      'issuer': instance.issuer,
      'isRolledOut': instance.isRolledOut,
      'publicServerKey': instance.publicServerKey,
      'privateTokenKey': instance.privateTokenKey,
      'firebaseToken': instance.firebaseToken,
      'serial': instance.serial,
      'sslVerify': instance.sslVerify,
      'enrollmentCredentials': instance.enrollmentCredentials,
      'url': instance.url?.toString(),
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'pushRequests': instance.pushRequests
    };

PushRequest _$PushRequestFromJson(Map<String, dynamic> json) {
  return PushRequest(
      json['title'] as String,
      json['question'] as String,
      json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      json['nonce'] as String,
      json['sslVerify'] as bool);
}

Map<String, dynamic> _$PushRequestToJson(PushRequest instance) =>
    <String, dynamic>{
      'nonce': instance.nonce,
      'sslVerify': instance.sslVerify,
      'uri': instance.uri?.toString(),
      'question': instance.question,
      'title': instance.title
    };

PushRequestQueue _$PushRequestQueueFromJson(Map<String, dynamic> json) {
  return PushRequestQueue()
    ..list = (json['list'] as List)
        ?.map((e) =>
            e == null ? null : PushRequest.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PushRequestQueueToJson(PushRequestQueue instance) =>
    <String, dynamic>{'list': instance.list};
