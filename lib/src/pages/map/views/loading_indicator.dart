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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    loadingMessage,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}