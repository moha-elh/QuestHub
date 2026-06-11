// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Room {

/// Firestore doc id — injected when reading, never written into the doc.
@JsonKey(includeToJson: false) String get id; String get hostId; String get code; DateTime get createdAt; RoomStatus get status; bool get isPublic; int get maxPlayers; Map<String, RoomPlayer> get players; DateTime? get startedAt;
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCopyWith<Room> get copyWith => _$RoomCopyWithImpl<Room>(this as Room, _$identity);

  /// Serializes this Room to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Room&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.code, code) || other.code == code)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,code,createdAt,status,isPublic,maxPlayers,const DeepCollectionEquality().hash(players),startedAt);

@override
String toString() {
  return 'Room(id: $id, hostId: $hostId, code: $code, createdAt: $createdAt, status: $status, isPublic: $isPublic, maxPlayers: $maxPlayers, players: $players, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res>  {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) = _$RoomCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String hostId, String code, DateTime createdAt, RoomStatus status, bool isPublic, int maxPlayers, Map<String, RoomPlayer> players, DateTime? startedAt
});




}
/// @nodoc
class _$RoomCopyWithImpl<$Res>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostId = null,Object? code = null,Object? createdAt = null,Object? status = null,Object? isPublic = null,Object? maxPlayers = null,Object? players = null,Object? startedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as Map<String, RoomPlayer>,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Room].
extension RoomPatterns on Room {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Room value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Room value)  $default,){
final _that = this;
switch (_that) {
case _Room():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Room value)?  $default,){
final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String hostId,  String code,  DateTime createdAt,  RoomStatus status,  bool isPublic,  int maxPlayers,  Map<String, RoomPlayer> players,  DateTime? startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.hostId,_that.code,_that.createdAt,_that.status,_that.isPublic,_that.maxPlayers,_that.players,_that.startedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String hostId,  String code,  DateTime createdAt,  RoomStatus status,  bool isPublic,  int maxPlayers,  Map<String, RoomPlayer> players,  DateTime? startedAt)  $default,) {final _that = this;
switch (_that) {
case _Room():
return $default(_that.id,_that.hostId,_that.code,_that.createdAt,_that.status,_that.isPublic,_that.maxPlayers,_that.players,_that.startedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String hostId,  String code,  DateTime createdAt,  RoomStatus status,  bool isPublic,  int maxPlayers,  Map<String, RoomPlayer> players,  DateTime? startedAt)?  $default,) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.hostId,_that.code,_that.createdAt,_that.status,_that.isPublic,_that.maxPlayers,_that.players,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Room extends Room {
  const _Room({@JsonKey(includeToJson: false) required this.id, required this.hostId, required this.code, required this.createdAt, this.status = RoomStatus.waiting, this.isPublic = false, this.maxPlayers = 8, final  Map<String, RoomPlayer> players = const <String, RoomPlayer>{}, this.startedAt}): _players = players,super._();
  factory _Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

/// Firestore doc id — injected when reading, never written into the doc.
@override@JsonKey(includeToJson: false) final  String id;
@override final  String hostId;
@override final  String code;
@override final  DateTime createdAt;
@override@JsonKey() final  RoomStatus status;
@override@JsonKey() final  bool isPublic;
@override@JsonKey() final  int maxPlayers;
 final  Map<String, RoomPlayer> _players;
@override@JsonKey() Map<String, RoomPlayer> get players {
  if (_players is EqualUnmodifiableMapView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_players);
}

@override final  DateTime? startedAt;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCopyWith<_Room> get copyWith => __$RoomCopyWithImpl<_Room>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Room&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.code, code) || other.code == code)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hostId,code,createdAt,status,isPublic,maxPlayers,const DeepCollectionEquality().hash(_players),startedAt);

@override
String toString() {
  return 'Room(id: $id, hostId: $hostId, code: $code, createdAt: $createdAt, status: $status, isPublic: $isPublic, maxPlayers: $maxPlayers, players: $players, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) = __$RoomCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String hostId, String code, DateTime createdAt, RoomStatus status, bool isPublic, int maxPlayers, Map<String, RoomPlayer> players, DateTime? startedAt
});




}
/// @nodoc
class __$RoomCopyWithImpl<$Res>
    implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostId = null,Object? code = null,Object? createdAt = null,Object? status = null,Object? isPublic = null,Object? maxPlayers = null,Object? players = null,Object? startedAt = freezed,}) {
  return _then(_Room(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: null == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as Map<String, RoomPlayer>,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RoomPlayer {

 String get displayName; DateTime get joinedAt; DateTime get lastSeenAt; String? get avatarUrl; bool get isReady; int get score; bool get skipUsed; int get questsCompleted;
/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPlayerCopyWith<RoomPlayer> get copyWith => _$RoomPlayerCopyWithImpl<RoomPlayer>(this as RoomPlayer, _$identity);

  /// Serializes this RoomPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPlayer&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.score, score) || other.score == score)&&(identical(other.skipUsed, skipUsed) || other.skipUsed == skipUsed)&&(identical(other.questsCompleted, questsCompleted) || other.questsCompleted == questsCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,joinedAt,lastSeenAt,avatarUrl,isReady,score,skipUsed,questsCompleted);

@override
String toString() {
  return 'RoomPlayer(displayName: $displayName, joinedAt: $joinedAt, lastSeenAt: $lastSeenAt, avatarUrl: $avatarUrl, isReady: $isReady, score: $score, skipUsed: $skipUsed, questsCompleted: $questsCompleted)';
}


}

/// @nodoc
abstract mixin class $RoomPlayerCopyWith<$Res>  {
  factory $RoomPlayerCopyWith(RoomPlayer value, $Res Function(RoomPlayer) _then) = _$RoomPlayerCopyWithImpl;
@useResult
$Res call({
 String displayName, DateTime joinedAt, DateTime lastSeenAt, String? avatarUrl, bool isReady, int score, bool skipUsed, int questsCompleted
});




}
/// @nodoc
class _$RoomPlayerCopyWithImpl<$Res>
    implements $RoomPlayerCopyWith<$Res> {
  _$RoomPlayerCopyWithImpl(this._self, this._then);

  final RoomPlayer _self;
  final $Res Function(RoomPlayer) _then;

/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? joinedAt = null,Object? lastSeenAt = null,Object? avatarUrl = freezed,Object? isReady = null,Object? score = null,Object? skipUsed = null,Object? questsCompleted = null,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,skipUsed: null == skipUsed ? _self.skipUsed : skipUsed // ignore: cast_nullable_to_non_nullable
as bool,questsCompleted: null == questsCompleted ? _self.questsCompleted : questsCompleted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomPlayer].
extension RoomPlayerPatterns on RoomPlayer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomPlayer value)  $default,){
final _that = this;
switch (_that) {
case _RoomPlayer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  DateTime joinedAt,  DateTime lastSeenAt,  String? avatarUrl,  bool isReady,  int score,  bool skipUsed,  int questsCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
return $default(_that.displayName,_that.joinedAt,_that.lastSeenAt,_that.avatarUrl,_that.isReady,_that.score,_that.skipUsed,_that.questsCompleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  DateTime joinedAt,  DateTime lastSeenAt,  String? avatarUrl,  bool isReady,  int score,  bool skipUsed,  int questsCompleted)  $default,) {final _that = this;
switch (_that) {
case _RoomPlayer():
return $default(_that.displayName,_that.joinedAt,_that.lastSeenAt,_that.avatarUrl,_that.isReady,_that.score,_that.skipUsed,_that.questsCompleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  DateTime joinedAt,  DateTime lastSeenAt,  String? avatarUrl,  bool isReady,  int score,  bool skipUsed,  int questsCompleted)?  $default,) {final _that = this;
switch (_that) {
case _RoomPlayer() when $default != null:
return $default(_that.displayName,_that.joinedAt,_that.lastSeenAt,_that.avatarUrl,_that.isReady,_that.score,_that.skipUsed,_that.questsCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomPlayer implements RoomPlayer {
  const _RoomPlayer({required this.displayName, required this.joinedAt, required this.lastSeenAt, this.avatarUrl, this.isReady = false, this.score = 0, this.skipUsed = false, this.questsCompleted = 0});
  factory _RoomPlayer.fromJson(Map<String, dynamic> json) => _$RoomPlayerFromJson(json);

@override final  String displayName;
@override final  DateTime joinedAt;
@override final  DateTime lastSeenAt;
@override final  String? avatarUrl;
@override@JsonKey() final  bool isReady;
@override@JsonKey() final  int score;
@override@JsonKey() final  bool skipUsed;
@override@JsonKey() final  int questsCompleted;

/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomPlayerCopyWith<_RoomPlayer> get copyWith => __$RoomPlayerCopyWithImpl<_RoomPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomPlayer&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.score, score) || other.score == score)&&(identical(other.skipUsed, skipUsed) || other.skipUsed == skipUsed)&&(identical(other.questsCompleted, questsCompleted) || other.questsCompleted == questsCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,joinedAt,lastSeenAt,avatarUrl,isReady,score,skipUsed,questsCompleted);

@override
String toString() {
  return 'RoomPlayer(displayName: $displayName, joinedAt: $joinedAt, lastSeenAt: $lastSeenAt, avatarUrl: $avatarUrl, isReady: $isReady, score: $score, skipUsed: $skipUsed, questsCompleted: $questsCompleted)';
}


}

/// @nodoc
abstract mixin class _$RoomPlayerCopyWith<$Res> implements $RoomPlayerCopyWith<$Res> {
  factory _$RoomPlayerCopyWith(_RoomPlayer value, $Res Function(_RoomPlayer) _then) = __$RoomPlayerCopyWithImpl;
@override @useResult
$Res call({
 String displayName, DateTime joinedAt, DateTime lastSeenAt, String? avatarUrl, bool isReady, int score, bool skipUsed, int questsCompleted
});




}
/// @nodoc
class __$RoomPlayerCopyWithImpl<$Res>
    implements _$RoomPlayerCopyWith<$Res> {
  __$RoomPlayerCopyWithImpl(this._self, this._then);

  final _RoomPlayer _self;
  final $Res Function(_RoomPlayer) _then;

/// Create a copy of RoomPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? joinedAt = null,Object? lastSeenAt = null,Object? avatarUrl = freezed,Object? isReady = null,Object? score = null,Object? skipUsed = null,Object? questsCompleted = null,}) {
  return _then(_RoomPlayer(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,skipUsed: null == skipUsed ? _self.skipUsed : skipUsed // ignore: cast_nullable_to_non_nullable
as bool,questsCompleted: null == questsCompleted ? _self.questsCompleted : questsCompleted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
