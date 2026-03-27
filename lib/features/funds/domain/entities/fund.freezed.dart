// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your copy of Fund directly from the frozen class. '
    'Please avoid doing this. '
    'If you need a new instance with changed fields, use the copyWith method instead.');

/// @nodoc
mixin _$Fund {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FundCategory get category => throw _privateConstructorUsedError;
  double get minimumAmount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FundCopyWith<Fund> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundCopyWith<$Res> {
  factory $FundCopyWith(Fund value, $Res Function(Fund) then) =
      _$FundCopyWithImpl<$Res, Fund>;
  @useResult
  $Res call({int id, String name, FundCategory category, double minimumAmount});
}

/// @nodoc
class _$FundCopyWithImpl<$Res, $Val extends Fund>
    implements $FundCopyWith<$Res> {
  _$FundCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? minimumAmount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id as int,
      name: null == name
          ? _value.name
          : name as String,
      category: null == category
          ? _value.category
          : category as FundCategory,
      minimumAmount: null == minimumAmount
          ? _value.minimumAmount
          : minimumAmount as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FundImplCopyWith<$Res> implements $FundCopyWith<$Res> {
  factory _$$FundImplCopyWith(
          _$FundImpl value, $Res Function(_$FundImpl) then) =
      __$$FundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, FundCategory category, double minimumAmount});
}

/// @nodoc
class __$$FundImplCopyWithImpl<$Res>
    extends _$FundCopyWithImpl<$Res, _$FundImpl>
    implements _$$FundImplCopyWith<$Res> {
  __$$FundImplCopyWithImpl(_$FundImpl _value, $Res Function(_$FundImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? minimumAmount = null,
  }) {
    return _then(_$FundImpl(
      id: null == id ? _value.id : id as int,
      name: null == name ? _value.name : name as String,
      category: null == category ? _value.category : category as FundCategory,
      minimumAmount: null == minimumAmount
          ? _value.minimumAmount
          : minimumAmount as double,
    ));
  }
}

/// @nodoc
class _$FundImpl implements _Fund {
  const _$FundImpl({
    required this.id,
    required this.name,
    required this.category,
    required this.minimumAmount,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final FundCategory category;
  @override
  final double minimumAmount;

  @override
  String toString() {
    return 'Fund(id: $id, name: $name, category: $category, minimumAmount: $minimumAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.minimumAmount, minimumAmount) ||
                other.minimumAmount == minimumAmount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, minimumAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FundImplCopyWith<_$FundImpl> get copyWith =>
      __$$FundImplCopyWithImpl<_$FundImpl>(this, _$identity);
}

abstract class _Fund implements Fund {
  const factory _Fund({
    required final int id,
    required final String name,
    required final FundCategory category,
    required final double minimumAmount,
  }) = _$FundImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  FundCategory get category;
  @override
  double get minimumAmount;
  @override
  @JsonKey(ignore: true)
  _$$FundImplCopyWith<_$FundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
