import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_strings.dart';

part 'fund.freezed.dart';

enum FundCategory {
  fpv,
  fic;

  String get displayName {
    switch (this) {
      case FundCategory.fpv:
        return AppStrings.fundCategoryFpv;
      case FundCategory.fic:
        return AppStrings.fundCategoryFic;
    }
  }
}

@freezed
class Fund with _$Fund {
  const factory Fund({
    required int id,
    required String name,
    required FundCategory category,
    required double minimumAmount,
  }) = _Fund;
}
