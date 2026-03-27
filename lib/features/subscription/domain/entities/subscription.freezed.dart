// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your copy of Subscription directly from the frozen class. '
    'Please avoid doing this. '
    'If you need a new instance with changed fields, use the copyWith method instead.');

/// @nodoc
mixin _$Subscription {
  String get id => throw _privateConstructorUsedError;
  int get fundId => throw _privateConstructorUsedError;
  String get fundName => throw _privateConstructorUsedError;
  FundCategory get category => throw _privateConstructorUsedError;
  double get subscribedAmount => throw _privateConstructorUsedError;
  DateTime get subscribedAt => throw _privateConstructorUsedError;
  NotificationMethod get notificationMethod =>
      throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call({
    String id,
    int fundId,
    String fundName,
    FundCategory category,
    double subscribedAmount,
    DateTime subscribedAt,
    NotificationMethod notificationMethod,
    bool isActive,
  });
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fundId = null,
    Object? fundName = null,
    Object? category = null,
    Object? subscribedAmount = null,
    Object? subscribedAt = null,
    Object? notificationMethod = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id ? _value.id : id as String,
      fundId: null == fundId ? _value.fundId : fundId as int,
      fundName: null == fundName ? _value.fundName : fundName as String,
      category:
          null == category ? _value.category : category as FundCategory,
      subscribedAmount: null == subscribedAmount
          ? _value.subscribedAmount
          : subscribedAmount as double,
      subscribedAt: null == subscribedAt
          ? _value.subscribedAt
          : subscribedAt as DateTime,
      notificationMethod: null == notificationMethod
          ? _value.notificationMethod
          : notificationMethod as NotificationMethod,
      isActive: null == isActive ? _value.isActive : isActive as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int fundId,
    String fundName,
    FundCategory category,
    double subscribedAmount,
    DateTime subscribedAt,
    NotificationMethod notificationMethod,
    bool isActive,
  });
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fundId = null,
    Object? fundName = null,
    Object? category = null,
    Object? subscribedAmount = null,
    Object? subscribedAt = null,
    Object? notificationMethod = null,
    Object? isActive = null,
  }) {
    return _then(_$SubscriptionImpl(
      id: null == id ? _value.id : id as String,
      fundId: null == fundId ? _value.fundId : fundId as int,
      fundName: null == fundName ? _value.fundName : fundName as String,
      category: null == category ? _value.category : category as FundCategory,
      subscribedAmount: null == subscribedAmount
          ? _value.subscribedAmount
          : subscribedAmount as double,
      subscribedAt: null == subscribedAt
          ? _value.subscribedAt
          : subscribedAt as DateTime,
      notificationMethod: null == notificationMethod
          ? _value.notificationMethod
          : notificationMethod as NotificationMethod,
      isActive: null == isActive ? _value.isActive : isActive as bool,
    ));
  }
}

/// @nodoc
class _$SubscriptionImpl implements _Subscription {
  const _$SubscriptionImpl({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.category,
    required this.subscribedAmount,
    required this.subscribedAt,
    required this.notificationMethod,
    required this.isActive,
  });

  @override
  final String id;
  @override
  final int fundId;
  @override
  final String fundName;
  @override
  final FundCategory category;
  @override
  final double subscribedAmount;
  @override
  final DateTime subscribedAt;
  @override
  final NotificationMethod notificationMethod;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'Subscription(id: $id, fundId: $fundId, fundName: $fundName, category: $category, subscribedAmount: $subscribedAmount, subscribedAt: $subscribedAt, notificationMethod: $notificationMethod, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fundId, fundId) || other.fundId == fundId) &&
            (identical(other.fundName, fundName) ||
                other.fundName == fundName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subscribedAmount, subscribedAmount) ||
                other.subscribedAmount == subscribedAmount) &&
            (identical(other.subscribedAt, subscribedAt) ||
                other.subscribedAt == subscribedAt) &&
            (identical(other.notificationMethod, notificationMethod) ||
                other.notificationMethod == notificationMethod) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, fundId, fundName, category,
      subscribedAmount, subscribedAt, notificationMethod, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);
}

abstract class _Subscription implements Subscription {
  const factory _Subscription({
    required final String id,
    required final int fundId,
    required final String fundName,
    required final FundCategory category,
    required final double subscribedAmount,
    required final DateTime subscribedAt,
    required final NotificationMethod notificationMethod,
    required final bool isActive,
  }) = _$SubscriptionImpl;

  @override
  String get id;
  @override
  int get fundId;
  @override
  String get fundName;
  @override
  FundCategory get category;
  @override
  double get subscribedAmount;
  @override
  DateTime get subscribedAt;
  @override
  NotificationMethod get notificationMethod;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
