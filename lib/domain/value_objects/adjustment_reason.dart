import 'package:equatable/equatable.dart';

/// Predefined or custom adjustment reasons for Mẫu 09/BH.
class AdjustmentReason extends Equatable {
  final String code;
  final String description;

  const AdjustmentReason({
    required this.code,
    required this.description,
  });

  static const List<AdjustmentReason> defaults = [
    AdjustmentReason(
      code: 'LD01',
      description: 'Điều chỉnh số lượng/đơn giá thuốc đúng theo hồ sơ bệnh án và hóa đơn thầu',
    ),
    AdjustmentReason(
      code: 'LD02',
      description: 'Điều chỉnh mã dịch vụ kỹ thuật đúng danh mục phê duyệt tương đương',
    ),
    AdjustmentReason(
      code: 'LD03',
      description: 'Bổ sung chi phí thuốc/vật tư y tế đã sử dụng thực tế chưa kịp tổng hợp',
    ),
    AdjustmentReason(
      code: 'LD04',
      description: 'Điều chỉnh thông tin bác sĩ chỉ định/thực hiện đúng chứng chỉ hành nghề',
    ),
    AdjustmentReason(
      code: 'LD05',
      description: 'Điều chỉnh khoa phòng điều trị đúng diễn biến thực tế',
    ),
    AdjustmentReason(
      code: 'LD06',
      description: 'Thu hồi chi phí do nhập trùng y lệnh',
    ),
    AdjustmentReason(
      code: 'LD99',
      description: 'Khác (nhập chi tiết lý do)',
    ),
  ];

  @override
  List<Object?> get props => [code, description];

  @override
  String toString() => description;
}
