/// Types of adjustment for Mẫu 09/BH.
enum AdjustmentType {
  /// 1: Bổ sung chi phí bỏ sót.
  supplemental('1', 'Bổ sung chi phí bỏ sót'),

  /// 2: Điều chỉnh tăng/giảm số lượng, đơn giá, tỷ lệ.
  modify('2', 'Điều chỉnh thông tin/chi phí'),

  /// 3: Thu hồi / Hủy toàn bộ khoản mục (xuất toán tự nguyện).
  revoke('3', 'Thu hồi/Hủy khoản mục'),

  /// 4: Giải trình / Giữ nguyên đề nghị thanh toán kèm tài liệu chứng minh.
  explain('4', 'Giải trình giữ nguyên');

  final String code;
  final String label;

  const AdjustmentType(this.code, this.label);
}
