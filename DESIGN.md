---
name: BHYT XML Adjustment Tool - Enterprise Medical UI
version: 1.0.0
colors:
  primary: '#0D9488'
  primary-container: '#008378'
  on-primary: '#FFFFFF'
  on-primary-container: '#F4FFFC'
  secondary: '#0058BE'
  secondary-container: '#2170E4'
  on-secondary: '#FFFFFF'
  tertiary: '#924628'
  surface: '#FFFFFF'
  surface-dark: '#1E293B'
  background: '#F8FAFC'
  background-dark: '#0F172A'
  surface-container-high: '#DCE9FF'
  surface-container-highest: '#D3E4FE'
  on-surface: '#0B1C30'
  on-surface-dark: '#F1F5F9'
  on-surface-variant: '#3D4947'
  outline: '#6D7A77'
  outline-variant: '#BCC9C6'
  error: '#EF4444'
  warning: '#F59E0B'
  success: '#10B981'
  diff-old-bg: '#FEE2E2'
  diff-old-bg-dark: '#451A1A'
  diff-old-text: '#DC2626'
  diff-new-bg: '#DCFCE7'
  diff-new-bg-dark: '#143823'
  diff-new-text: '#16A34A'
typography:
  display:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: 700
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: 600
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: 600
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: 400
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 400
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: 400
    lineHeight: 18px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: 600
    lineHeight: 16px
    letterSpacing: 0.05em
  mono:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: 400
    lineHeight: 20px
rounded:
  sm: 4px
  md: 8px
  lg: 12px
  xl: 16px
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
---

# BHYT XML Adjustment Tool — Design Specification

## Overview
Giao diện phần mềm đối soát XML KCB BHYT và sinh Mẫu 09/BH chuyên nghiệp chuẩn **QĐ 3176/QĐ-BYT**, **QĐ 4750/QĐ-BYT** và **Thông tư 12/2026/TT-BTC**.
Định hướng thiết kế: **Clinical Precision, High Information Density, Modern Glassmorphism Card**.
Hỗ trợ đầy đủ **Light Mode** & **Dark Mode** với chuyển đổi mượt mà.

## Colors
- **Primary (#0D9488):** Medical Teal - Màu chủ đạo gắn liền với ngành y tế và kiểm chuẩn dữ liệu, dễ chịu cho mắt khi làm việc cường độ cao.
- **Surface & Background:**
  - **Light Mode:** Nền `#F8FAFC`, Surface `#FFFFFF`, Border `#E2E8F0`.
  - **Dark Mode:** Nền `#0F172A` (Slate 900), Surface `#1E293B` (Slate 800), Border `#334155`.
- **Diff Highlighting:**
  - Cũ (Bị sửa / Xóa): Đỏ nhạt `#FEE2E2` (Dark `#451A1A`), chữ `#DC2626`.
  - Mới (Đã sửa / Bổ sung): Xanh lục nhạt `#DCFCE7` (Dark `#143823`), chữ `#16A34A`.

## Typography
- **Chính:** `Inter` (Google Fonts) sắc nét, hiện đại, tối ưu cho giao diện dữ liệu phức tạp.
- **Mã kỹ thuật / XML:** `JetBrains Mono` hoặc monospace chuẩn cho mã thẻ BHYT, mã liên kết, XML tags và mã băm SHA-256.

## Elevation & Depth
- Phẳng hiện đại kết hợp đổ bóng nhiều lớp (Multi-layer Drop Shadow):
  - Card: Viền 1px tinh tế + bóng mờ 0 4px 6px -1px rgba(0,0,0,0.08).
  - Hover / Focus: Glow nhẹ màu Medical Teal `#0D9488`.

## Components
- **Top Navigation Bar:** Hiển thị Logo, Tiêu đề, Badge Chuẩn QĐ 3176 & TT 12/2026, Switch Dark/Light Mode và nút Talker Monitor.
- **Metric Cards:** 6 thẻ thống kê chỉ số với icon bo góc tròn, màu sắc tương ứng và viền nổi bật.
- **Side-by-Side Diff Viewer:** 2 khung so sánh Cũ (Đỏ) vs Mới (Xanh) với badge Mẫu 09 trực quan.
- **Export Table:** Bảng dữ liệu 10 cột sắc nét, thanh công cụ áp dụng lý do hàng loạt với dropdown động.
