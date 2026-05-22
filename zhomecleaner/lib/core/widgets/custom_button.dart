import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;
  final Widget? prefixIcon;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useGradient;

  const CustomButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.prefixIcon,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.borderRadius = AppDimensions.radiusLg,
    this.backgroundColor,
    this.textColor,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: (!isOutlined && useGradient)
              ? AppColors.primaryGradient
              : null,
          color: isOutlined
              ? Colors.transparent
              : (useGradient ? null : (backgroundColor ?? AppColors.primaryBlue)),
          borderRadius: BorderRadius.circular(borderRadius),
          border: isOutlined
              ? Border.all(color: AppColors.primaryBlue, width: 1.5)
              : null,
          boxShadow: (!isOutlined && onTap != null && !isLoading)
              ? AppColors.buttonShadow
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      const SizedBox(width: AppDimensions.sm),
                    ],
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: AppDimensions.fontMd,
                        fontWeight: FontWeight.w600,
                        color: isOutlined
                            ? (textColor ?? AppColors.primaryBlue)
                            : (textColor ?? AppColors.textWhite),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
