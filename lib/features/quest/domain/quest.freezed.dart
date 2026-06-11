// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Quest {

 String get id; String get title; String get description; QuestDifficulty get difficulty; QuestCategory get category; List<String> get tags;
/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestCopyWith<Quest> get copyWith => _$QuestCopyWithImpl<Quest>(this as Quest, _$identity);

  /// Serializes this Quest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,difficulty,category,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'Quest(id: $id, title: $title, description: $description, difficulty: $difficulty, category: $category, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $QuestCopyWith<$Res>  {
  factory $QuestCopyWith(Quest value, $Res Function(Quest) _then) = _$QuestCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, QuestDifficulty difficulty, QuestCategory category, List<String> tags
});




}
/// @nodoc
class _$QuestCopyWithImpl<$Res>
    implements $QuestCopyWith<$Res> {
  _$QuestCopyWithImpl(this._self, this._then);

  final Quest _self;
  final $Res Function(Quest) _then;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? difficulty = null,Object? category = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as QuestDifficulty,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as QuestCategory,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Quest].
extension QuestPatterns on Quest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quest value)  $default,){
final _that = this;
switch (_that) {
case _Quest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quest value)?  $default,){
final _that = this;
switch (_that) {
case _Quest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  QuestDifficulty difficulty,  QuestCategory category,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quest() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.difficulty,_that.category,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  QuestDifficulty difficulty,  QuestCategory category,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Quest():
return $default(_that.id,_that.title,_that.description,_that.difficulty,_that.category,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  QuestDifficulty difficulty,  QuestCategory category,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Quest() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.difficulty,_that.category,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quest extends Quest {
  const _Quest({required this.id, required this.title, required this.description, required this.difficulty, required this.category, final  List<String> tags = const <String>[]}): _tags = tags,super._();
  factory _Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  QuestDifficulty difficulty;
@override final  QuestCategory category;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestCopyWith<_Quest> get copyWith => __$QuestCopyWithImpl<_Quest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,difficulty,category,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'Quest(id: $id, title: $title, description: $description, difficulty: $difficulty, category: $category, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$QuestCopyWith<$Res> implements $QuestCopyWith<$Res> {
  factory _$QuestCopyWith(_Quest value, $Res Function(_Quest) _then) = __$QuestCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, QuestDifficulty difficulty, QuestCategory category, List<String> tags
});




}
/// @nodoc
class __$QuestCopyWithImpl<$Res>
    implements _$QuestCopyWith<$Res> {
  __$QuestCopyWithImpl(this._self, this._then);

  final _Quest _self;
  final $Res Function(_Quest) _then;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? difficulty = null,Object? category = null,Object? tags = null,}) {
  return _then(_Quest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as QuestDifficulty,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as QuestCategory,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$QuestAssignment {

 String get questId; String get title; String get description; QuestDifficulty get difficulty; int get points; int get durationSeconds; QuestCategory get category; DateTime get assignedAt; QuestAssignmentStatus get status; DateTime? get completedAt;
/// Create a copy of QuestAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestAssignmentCopyWith<QuestAssignment> get copyWith => _$QuestAssignmentCopyWithImpl<QuestAssignment>(this as QuestAssignment, _$identity);

  /// Serializes this QuestAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestAssignment&&(identical(other.questId, questId) || other.questId == questId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.points, points) || other.points == points)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.category, category) || other.category == category)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questId,title,description,difficulty,points,durationSeconds,category,assignedAt,status,completedAt);

@override
String toString() {
  return 'QuestAssignment(questId: $questId, title: $title, description: $description, difficulty: $difficulty, points: $points, durationSeconds: $durationSeconds, category: $category, assignedAt: $assignedAt, status: $status, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $QuestAssignmentCopyWith<$Res>  {
  factory $QuestAssignmentCopyWith(QuestAssignment value, $Res Function(QuestAssignment) _then) = _$QuestAssignmentCopyWithImpl;
@useResult
$Res call({
 String questId, String title, String description, QuestDifficulty difficulty, int points, int durationSeconds, QuestCategory category, DateTime assignedAt, QuestAssignmentStatus status, DateTime? completedAt
});




}
/// @nodoc
class _$QuestAssignmentCopyWithImpl<$Res>
    implements $QuestAssignmentCopyWith<$Res> {
  _$QuestAssignmentCopyWithImpl(this._self, this._then);

  final QuestAssignment _self;
  final $Res Function(QuestAssignment) _then;

/// Create a copy of QuestAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questId = null,Object? title = null,Object? description = null,Object? difficulty = null,Object? points = null,Object? durationSeconds = null,Object? category = null,Object? assignedAt = null,Object? status = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
questId: null == questId ? _self.questId : questId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as QuestDifficulty,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as QuestCategory,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuestAssignmentStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestAssignment].
extension QuestAssignmentPatterns on QuestAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestAssignment value)  $default,){
final _that = this;
switch (_that) {
case _QuestAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _QuestAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questId,  String title,  String description,  QuestDifficulty difficulty,  int points,  int durationSeconds,  QuestCategory category,  DateTime assignedAt,  QuestAssignmentStatus status,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestAssignment() when $default != null:
return $default(_that.questId,_that.title,_that.description,_that.difficulty,_that.points,_that.durationSeconds,_that.category,_that.assignedAt,_that.status,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questId,  String title,  String description,  QuestDifficulty difficulty,  int points,  int durationSeconds,  QuestCategory category,  DateTime assignedAt,  QuestAssignmentStatus status,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _QuestAssignment():
return $default(_that.questId,_that.title,_that.description,_that.difficulty,_that.points,_that.durationSeconds,_that.category,_that.assignedAt,_that.status,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questId,  String title,  String description,  QuestDifficulty difficulty,  int points,  int durationSeconds,  QuestCategory category,  DateTime assignedAt,  QuestAssignmentStatus status,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _QuestAssignment() when $default != null:
return $default(_that.questId,_that.title,_that.description,_that.difficulty,_that.points,_that.durationSeconds,_that.category,_that.assignedAt,_that.status,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestAssignment implements QuestAssignment {
  const _QuestAssignment({required this.questId, required this.title, required this.description, required this.difficulty, required this.points, required this.durationSeconds, required this.category, required this.assignedAt, this.status = QuestAssignmentStatus.active, this.completedAt});
  factory _QuestAssignment.fromJson(Map<String, dynamic> json) => _$QuestAssignmentFromJson(json);

@override final  String questId;
@override final  String title;
@override final  String description;
@override final  QuestDifficulty difficulty;
@override final  int points;
@override final  int durationSeconds;
@override final  QuestCategory category;
@override final  DateTime assignedAt;
@override@JsonKey() final  QuestAssignmentStatus status;
@override final  DateTime? completedAt;

/// Create a copy of QuestAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestAssignmentCopyWith<_QuestAssignment> get copyWith => __$QuestAssignmentCopyWithImpl<_QuestAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestAssignment&&(identical(other.questId, questId) || other.questId == questId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.points, points) || other.points == points)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.category, category) || other.category == category)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questId,title,description,difficulty,points,durationSeconds,category,assignedAt,status,completedAt);

@override
String toString() {
  return 'QuestAssignment(questId: $questId, title: $title, description: $description, difficulty: $difficulty, points: $points, durationSeconds: $durationSeconds, category: $category, assignedAt: $assignedAt, status: $status, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$QuestAssignmentCopyWith<$Res> implements $QuestAssignmentCopyWith<$Res> {
  factory _$QuestAssignmentCopyWith(_QuestAssignment value, $Res Function(_QuestAssignment) _then) = __$QuestAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String questId, String title, String description, QuestDifficulty difficulty, int points, int durationSeconds, QuestCategory category, DateTime assignedAt, QuestAssignmentStatus status, DateTime? completedAt
});




}
/// @nodoc
class __$QuestAssignmentCopyWithImpl<$Res>
    implements _$QuestAssignmentCopyWith<$Res> {
  __$QuestAssignmentCopyWithImpl(this._self, this._then);

  final _QuestAssignment _self;
  final $Res Function(_QuestAssignment) _then;

/// Create a copy of QuestAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questId = null,Object? title = null,Object? description = null,Object? difficulty = null,Object? points = null,Object? durationSeconds = null,Object? category = null,Object? assignedAt = null,Object? status = null,Object? completedAt = freezed,}) {
  return _then(_QuestAssignment(
questId: null == questId ? _self.questId : questId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as QuestDifficulty,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as QuestCategory,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QuestAssignmentStatus,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
