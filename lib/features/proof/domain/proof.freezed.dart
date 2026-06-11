// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proof.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Proof {

@JsonKey(includeToJson: false) String get id; String get submitterId; String get submitterName; String? get submitterAvatarUrl; String get questId; String get questTitle; int get questPoints; String get imageUrl; String get thumbnailUrl; Map<String, String> get votes; ProofStatus get status; DateTime get submittedAt; DateTime? get votingDeadline; DateTime? get resolvedAt;
/// Create a copy of Proof
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProofCopyWith<Proof> get copyWith => _$ProofCopyWithImpl<Proof>(this as Proof, _$identity);

  /// Serializes this Proof to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Proof&&(identical(other.id, id) || other.id == id)&&(identical(other.submitterId, submitterId) || other.submitterId == submitterId)&&(identical(other.submitterName, submitterName) || other.submitterName == submitterName)&&(identical(other.submitterAvatarUrl, submitterAvatarUrl) || other.submitterAvatarUrl == submitterAvatarUrl)&&(identical(other.questId, questId) || other.questId == questId)&&(identical(other.questTitle, questTitle) || other.questTitle == questTitle)&&(identical(other.questPoints, questPoints) || other.questPoints == questPoints)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.votes, votes)&&(identical(other.status, status) || other.status == status)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.votingDeadline, votingDeadline) || other.votingDeadline == votingDeadline)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,submitterId,submitterName,submitterAvatarUrl,questId,questTitle,questPoints,imageUrl,thumbnailUrl,const DeepCollectionEquality().hash(votes),status,submittedAt,votingDeadline,resolvedAt);

@override
String toString() {
  return 'Proof(id: $id, submitterId: $submitterId, submitterName: $submitterName, submitterAvatarUrl: $submitterAvatarUrl, questId: $questId, questTitle: $questTitle, questPoints: $questPoints, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, votes: $votes, status: $status, submittedAt: $submittedAt, votingDeadline: $votingDeadline, resolvedAt: $resolvedAt)';
}


}

/// @nodoc
abstract mixin class $ProofCopyWith<$Res>  {
  factory $ProofCopyWith(Proof value, $Res Function(Proof) _then) = _$ProofCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String submitterId, String submitterName, String? submitterAvatarUrl, String questId, String questTitle, int questPoints, String imageUrl, String thumbnailUrl, Map<String, String> votes, ProofStatus status, DateTime submittedAt, DateTime? votingDeadline, DateTime? resolvedAt
});




}
/// @nodoc
class _$ProofCopyWithImpl<$Res>
    implements $ProofCopyWith<$Res> {
  _$ProofCopyWithImpl(this._self, this._then);

  final Proof _self;
  final $Res Function(Proof) _then;

/// Create a copy of Proof
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? submitterId = null,Object? submitterName = null,Object? submitterAvatarUrl = freezed,Object? questId = null,Object? questTitle = null,Object? questPoints = null,Object? imageUrl = null,Object? thumbnailUrl = null,Object? votes = null,Object? status = null,Object? submittedAt = null,Object? votingDeadline = freezed,Object? resolvedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,submitterId: null == submitterId ? _self.submitterId : submitterId // ignore: cast_nullable_to_non_nullable
as String,submitterName: null == submitterName ? _self.submitterName : submitterName // ignore: cast_nullable_to_non_nullable
as String,submitterAvatarUrl: freezed == submitterAvatarUrl ? _self.submitterAvatarUrl : submitterAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,questId: null == questId ? _self.questId : questId // ignore: cast_nullable_to_non_nullable
as String,questTitle: null == questTitle ? _self.questTitle : questTitle // ignore: cast_nullable_to_non_nullable
as String,questPoints: null == questPoints ? _self.questPoints : questPoints // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProofStatus,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,votingDeadline: freezed == votingDeadline ? _self.votingDeadline : votingDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Proof].
extension ProofPatterns on Proof {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Proof value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Proof() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Proof value)  $default,){
final _that = this;
switch (_that) {
case _Proof():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Proof value)?  $default,){
final _that = this;
switch (_that) {
case _Proof() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String submitterId,  String submitterName,  String? submitterAvatarUrl,  String questId,  String questTitle,  int questPoints,  String imageUrl,  String thumbnailUrl,  Map<String, String> votes,  ProofStatus status,  DateTime submittedAt,  DateTime? votingDeadline,  DateTime? resolvedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Proof() when $default != null:
return $default(_that.id,_that.submitterId,_that.submitterName,_that.submitterAvatarUrl,_that.questId,_that.questTitle,_that.questPoints,_that.imageUrl,_that.thumbnailUrl,_that.votes,_that.status,_that.submittedAt,_that.votingDeadline,_that.resolvedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String submitterId,  String submitterName,  String? submitterAvatarUrl,  String questId,  String questTitle,  int questPoints,  String imageUrl,  String thumbnailUrl,  Map<String, String> votes,  ProofStatus status,  DateTime submittedAt,  DateTime? votingDeadline,  DateTime? resolvedAt)  $default,) {final _that = this;
switch (_that) {
case _Proof():
return $default(_that.id,_that.submitterId,_that.submitterName,_that.submitterAvatarUrl,_that.questId,_that.questTitle,_that.questPoints,_that.imageUrl,_that.thumbnailUrl,_that.votes,_that.status,_that.submittedAt,_that.votingDeadline,_that.resolvedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String submitterId,  String submitterName,  String? submitterAvatarUrl,  String questId,  String questTitle,  int questPoints,  String imageUrl,  String thumbnailUrl,  Map<String, String> votes,  ProofStatus status,  DateTime submittedAt,  DateTime? votingDeadline,  DateTime? resolvedAt)?  $default,) {final _that = this;
switch (_that) {
case _Proof() when $default != null:
return $default(_that.id,_that.submitterId,_that.submitterName,_that.submitterAvatarUrl,_that.questId,_that.questTitle,_that.questPoints,_that.imageUrl,_that.thumbnailUrl,_that.votes,_that.status,_that.submittedAt,_that.votingDeadline,_that.resolvedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Proof extends Proof {
  const _Proof({@JsonKey(includeToJson: false) required this.id, required this.submitterId, required this.submitterName, this.submitterAvatarUrl, required this.questId, required this.questTitle, required this.questPoints, required this.imageUrl, required this.thumbnailUrl, final  Map<String, String> votes = const <String, String>{}, this.status = ProofStatus.pending, required this.submittedAt, this.votingDeadline, this.resolvedAt}): _votes = votes,super._();
  factory _Proof.fromJson(Map<String, dynamic> json) => _$ProofFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String submitterId;
@override final  String submitterName;
@override final  String? submitterAvatarUrl;
@override final  String questId;
@override final  String questTitle;
@override final  int questPoints;
@override final  String imageUrl;
@override final  String thumbnailUrl;
 final  Map<String, String> _votes;
@override@JsonKey() Map<String, String> get votes {
  if (_votes is EqualUnmodifiableMapView) return _votes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_votes);
}

@override@JsonKey() final  ProofStatus status;
@override final  DateTime submittedAt;
@override final  DateTime? votingDeadline;
@override final  DateTime? resolvedAt;

/// Create a copy of Proof
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProofCopyWith<_Proof> get copyWith => __$ProofCopyWithImpl<_Proof>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProofToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Proof&&(identical(other.id, id) || other.id == id)&&(identical(other.submitterId, submitterId) || other.submitterId == submitterId)&&(identical(other.submitterName, submitterName) || other.submitterName == submitterName)&&(identical(other.submitterAvatarUrl, submitterAvatarUrl) || other.submitterAvatarUrl == submitterAvatarUrl)&&(identical(other.questId, questId) || other.questId == questId)&&(identical(other.questTitle, questTitle) || other.questTitle == questTitle)&&(identical(other.questPoints, questPoints) || other.questPoints == questPoints)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other._votes, _votes)&&(identical(other.status, status) || other.status == status)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.votingDeadline, votingDeadline) || other.votingDeadline == votingDeadline)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,submitterId,submitterName,submitterAvatarUrl,questId,questTitle,questPoints,imageUrl,thumbnailUrl,const DeepCollectionEquality().hash(_votes),status,submittedAt,votingDeadline,resolvedAt);

@override
String toString() {
  return 'Proof(id: $id, submitterId: $submitterId, submitterName: $submitterName, submitterAvatarUrl: $submitterAvatarUrl, questId: $questId, questTitle: $questTitle, questPoints: $questPoints, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, votes: $votes, status: $status, submittedAt: $submittedAt, votingDeadline: $votingDeadline, resolvedAt: $resolvedAt)';
}


}

/// @nodoc
abstract mixin class _$ProofCopyWith<$Res> implements $ProofCopyWith<$Res> {
  factory _$ProofCopyWith(_Proof value, $Res Function(_Proof) _then) = __$ProofCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String submitterId, String submitterName, String? submitterAvatarUrl, String questId, String questTitle, int questPoints, String imageUrl, String thumbnailUrl, Map<String, String> votes, ProofStatus status, DateTime submittedAt, DateTime? votingDeadline, DateTime? resolvedAt
});




}
/// @nodoc
class __$ProofCopyWithImpl<$Res>
    implements _$ProofCopyWith<$Res> {
  __$ProofCopyWithImpl(this._self, this._then);

  final _Proof _self;
  final $Res Function(_Proof) _then;

/// Create a copy of Proof
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? submitterId = null,Object? submitterName = null,Object? submitterAvatarUrl = freezed,Object? questId = null,Object? questTitle = null,Object? questPoints = null,Object? imageUrl = null,Object? thumbnailUrl = null,Object? votes = null,Object? status = null,Object? submittedAt = null,Object? votingDeadline = freezed,Object? resolvedAt = freezed,}) {
  return _then(_Proof(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,submitterId: null == submitterId ? _self.submitterId : submitterId // ignore: cast_nullable_to_non_nullable
as String,submitterName: null == submitterName ? _self.submitterName : submitterName // ignore: cast_nullable_to_non_nullable
as String,submitterAvatarUrl: freezed == submitterAvatarUrl ? _self.submitterAvatarUrl : submitterAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,questId: null == questId ? _self.questId : questId // ignore: cast_nullable_to_non_nullable
as String,questTitle: null == questTitle ? _self.questTitle : questTitle // ignore: cast_nullable_to_non_nullable
as String,questPoints: null == questPoints ? _self.questPoints : questPoints // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,votes: null == votes ? _self._votes : votes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProofStatus,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,votingDeadline: freezed == votingDeadline ? _self.votingDeadline : votingDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
