// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your copy of Transaction directly from the frozen class. '
    'Please avoid doing this. '
    'If you need a new instance with changed fields, use the copyWith method instead.');

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  int get fundId => throw _privateConstructorUsedError;
  String get fundName => throw _privateConstructorUsedError;
  FundCategory get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  NotificationMethod? get notificationMethod =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    TransactionType type,
    int fundId,
    String fundName,
    FundCategory category,
    double amount,
    DateTime createdAt,
    NotificationMethod? notificationMethod,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? fundId = null,
    Object? fundName = null,
    Object? category = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? notificationMethod = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      type: null == type ? _value.type : type as TransactionType,
      fundId: null == fundId ? _value.fundId : fundId as int,
      fundName: null == fundName ? _value.fundName : fundName as String,
      category:
          null == category ? _value.category : category as FundCategory,
      amount: null == amount ? _value.amount : amount as double,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      notificationMethod: freezed == notificationMethod
          ? _value.notificationMethod
          : notificationMethod as NotificationMethod?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    TransactionType type,
    int fundId,
    String fundName,
    FundCategory category,
    double amount,
    DateTime createdAt,
    NotificationMethod? notificationMethod,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? fundId = null,
    Object? fundName = null,
    Object? category = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? notificationMethod = freezed,
  }) {
    return _then(_$TransactionImpl(
      id: null == id ? _value.id : id as String,
      type: null == type ? _value.type : type as TransactionType,
      fundId: null == fundId ? _value.fundId : fundId as int,
      fundName: null == fundName ? _value.fundName : fundName as String,
      category: null == category ? _value.category : category as FundCategory,
      amount: null == amount ? _value.amount : amount as double,
      createdAt:
          null == createdAt ? _value.createdAt : createdAt as DateTime,
      notificationMethod: freezed == notificationMethod
          ? _value.notificationMethod
          : notificationMethod as NotificationMethod?,
    ));
  }
}

/// @nodoc
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    required this.id,
    required this.type,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.amount,
    required this.createdAt,
    this.notificationMethod,
  });

  @override
  final String id;
  @override
  final TransactionType type;
  @override
  final int fundId;
  @override
  final String fundName;
  @override
  final FundCategory category;
  @override
  final double amount;
  @override
  final DateTime createdAt;
  @override
  final NotificationMethod? notificationMethod;

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, fundId: $fundId, fundName: $fundName, category: $category, amount: $amount, createdAt: $createdAt, notificationMethod: $notificationMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.fundId, fundId) || other.fundId == fundId) &&
            (identical(other.fundName, fundName) ||
                other.fundName == fundName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.notificationMethod, notificationMethod) ||
                other.notificationMethod == notificationMethod));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, type, fundId, fundName,
      category, amount, createdAt, notificationMethod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    required final String id,
    required final TransactionType type,
    required final int fundId,
    required final String fundName,
    required final FundCategory category,
    required final double amount,
    required final DateTime createdAt,
    final NotificationMethod? notificationMethod,
  }) = _$TransactionImpl;

  @override
  String get id;
  @override
  TransactionType get type;
  @override
  int get fundId;
  @override
  String get fundName;
  @override
  FundCategory get category;
  @override
  double get amount;
  @override
  DateTime get createdAt;
  @override
  NotificationMethod? get notificationMethod;
  @override
  @JsonKey(ignore: true)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// Sentinel value used by freezed for nullable fields
const Object? freezed = _Freezed._();

class _Freezed {
  const _Freezed._();
}
