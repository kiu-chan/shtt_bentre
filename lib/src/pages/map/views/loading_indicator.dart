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
    bool hasActiveLoading = false;
    String loadingMessage = '';

    if (isBorderLoading) {
      hasActiveLoading = true;
      loadingMessage = AppLocalizations.of(context)!.loadingMapBoundary;
    }
    
    if (isCommuneLoading) {
      hasActiveLoading = true;
      loadingMessage = loadingMessage.isEmpty 
          ? AppLocalizations.of(context)!.loadingCommuneBoundaries
          : '$loadingMessage, ${AppLocalizations.of(context)!.loadingCommuneBoundaries}';
    }
    
    if (isPatentLoading || isTrademarkLoading || isIndustrialDesignLoading) {
      hasActiveLoading = true;
      loadingMessage = 'Đang tải dữ liệu...';
    }

    if (!hasActiveLoading) {
      return const SizedBox.shrink();
    }

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
            child: Row(
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
                Text(
                  loadingMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}