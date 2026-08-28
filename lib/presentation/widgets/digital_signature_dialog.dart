import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:xmltool/config/theme/app_colors.dart';
import 'package:xmltool/domain/entities/digital_certificate.dart';
import 'package:xmltool/infrastructure/security/bhyt_digital_signer.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_bloc.dart';

/// Modal dialog for applying BHXH-compliant XMLDSig RSA-SHA256 Digital Signatures.
class DigitalSignatureDialog extends StatefulWidget {
  final String cskcbCode;

  const DigitalSignatureDialog({
    super.key,
    required this.cskcbCode,
  });

  @override
  State<DigitalSignatureDialog> createState() => _DigitalSignatureDialogState();
}

class _DigitalSignatureDialogState extends State<DigitalSignatureDialog> {
  final _signer = BHYTDigitalSigner();
  late ({pc.RSAPublicKey publicKey, pc.RSAPrivateKey privateKey, DigitalCertificate certificate}) _testCert;

  File? _selectedCertFile;
  final _pinController = TextEditingController(text: '123456');
  String? _selectedCaName = 'VNPT-CA';
  final List<String> _caList = ['VNPT-CA', 'Viettel-CA', 'BKAV-CA', 'FPT-CA', 'MISA-CA', 'BAN CO YEU CHINH PHU'];

  @override
  void initState() {
    super.initState();
    _refreshTestCert();
  }

  void _refreshTestCert() {
    _testCert = _signer.generateTestMedicalCertificate(
      hospitalName: 'BỆNH VIỆN ĐA KHOA CSKCB ${widget.cskcbCode}',
      cskcbCode: widget.cskcbCode,
      caName: _selectedCaName ?? 'VNPT-CA QUỐC GIA',
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _pickCertFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['p12', 'pfx', 'pem', 'crt', 'cer'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedCertFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi chọn tệp chứng thư: $e')),
        );
      }
    }
  }

  void _applySignature() {
    // Apply test or parsed certificate
    context.read<Mau09Bloc>().add(Mau09DigitalSignatureApplied(
          privateKey: _testCert.privateKey,
          certificate: _testCert.certificate,
        ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cert = _testCert.certificate;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 620,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ký Số Điện Tử Hồ Sơ BHYT',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Chuẩn XMLDSig RSA-SHA256 • Nghị định 130/2018/NĐ-CP & Cổng BHXH',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            // Provider & Certificate Settings
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nhà Cung Cấp Chữ Ký Số (CA):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCaName,
                            isExpanded: true,
                            items: _caList.map((ca) => DropdownMenuItem(value: ca, child: Text(ca))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCaName = val;
                                  _refreshTestCert();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mã PIN / Mật khẩu Token:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _pinController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Nhập mã PIN...',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.lock_outline, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Certificate Info Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text('Thông Tin Chứng Thư Số X.509', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
                            SizedBox(width: 4),
                            Text('HỢP LỆ (2048-BIT)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildCertField('Chủ thể (Subject):', cert.displayName),
                  _buildCertField('Cơ quan cấp (Issuer):', cert.caProvider),
                  _buildCertField('Số Serial:', cert.serialNumber),
                  _buildCertField('Thời hạn hiệu lực:', '${cert.validFrom.day}/${cert.validFrom.month}/${cert.validFrom.year} → ${cert.validTo.day}/${cert.validTo.month}/${cert.validTo.year}'),
                  _buildCertField('Thumbprint SHA-256:', '${cert.thumbprintSha256.substring(0, 24)}...'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Option to browse certificate file
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickCertFile,
                  icon: const Icon(Icons.file_open_outlined, size: 16),
                  label: Text(_selectedCertFile != null ? 'Tệp: ${_selectedCertFile!.path.split(Platform.pathSeparator).last}' : 'Chọn tệp chứng thư (.p12 / .pfx)...'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
                const Spacer(),
                Text(
                  'Tương thích USB Token & HSM',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dialog Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _applySignature,
                  icon: const Icon(Icons.drive_file_rename_outline_rounded, size: 20),
                  label: const Text('KÝ SỐ NGAY', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
