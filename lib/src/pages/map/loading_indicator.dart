import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isBorderLoading;
  final bool isCommuneLoading;
  final bool isPatentLoading;
  final bool isTrademarkLoading;
  final bool isIndustrialDesignLoading;

  const LoadingIndicator({
    super.key,
    required this.isBorderLoading,
    required this.isCommuneLoading,
    required this.isPatentLoading,
    required this.isTrademarkLoading,
    required this.isIndustrialDesignLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isBorderLoading && !isCommuneLoading && !isPatentLoading && 
        !isTrademarkLoading && !isIndustrialDesignLoading) {
      return const SizedBox.shrink();
    }

    return _buildLoadingOverlay(context);
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: _buildLoadingContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        const SizedBox(width: 12),
        _buildLoadingText(context),
      ],
    );
  }

  Widget _buildLoadingText(BuildContext context) {
    return Text(
      _getLoadingMessage(context),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String _getLoadingMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (isBorderLoading && isCommuneLoading) {
      return '${l10n.loadingMapBoundary}, ${l10n.loadingCommuneBoundaries}';
    } else if (isBorderLoading) {
      return l10n.loadingMapBoundary;
    } else if (isCommuneLoading) {
      return l10n.loadingCommuneBoundaries;
    } else if (isPatentLoading) {
      return 'Đang tải dữ liệu bằng sáng chế...';
    } else if (isTrademarkLoading) {
      return 'Đang tải dữ liệu nhãn hiệu...';
    } else if (isIndustrialDesignLoading) {
      return 'Đang tải dữ liệu kiểu dáng công nghiệp...';
    }
    
    return 'Đang tải...';
  }
}