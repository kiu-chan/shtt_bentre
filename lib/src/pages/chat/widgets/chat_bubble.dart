import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool showAvatar;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.showAvatar = true,
  });

  List<InlineSpan> _buildMessageContent() {
    final List<InlineSpan> spans = [];
    
    // Regex cho URL và số điện thoại
    final RegExp urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );
    
    final RegExp phoneRegex = RegExp(
      r'(?:\+84|0)(?:\d{9,10})',
      caseSensitive: false,
    );

    int lastMatchEnd = 0;

    // Tìm tất cả các matches (URL và số điện thoại)
    List<Match> allMatches = [];
    allMatches.addAll(urlRegex.allMatches(message));
    allMatches.addAll(phoneRegex.allMatches(message));
    
    // Sắp xếp các matches theo vị trí
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    for (final Match match in allMatches) {
      final String matchedText = match.group(0)!;
      final int startIndex = match.start;
      
      // Thêm text thường trước match
      if (startIndex > lastMatchEnd) {
        spans.add(TextSpan(
          text: message.substring(lastMatchEnd, startIndex),
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ));
      }

      // Xác định loại match (URL hay số điện thoại)
      final bool isPhone = phoneRegex.hasMatch(matchedText);
      
      spans.add(WidgetSpan(
        child: GestureDetector(
          onTap: () => isPhone ? _launchPhone(matchedText) : _launchURL(matchedText),
          child: Text(
            matchedText,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ));

      lastMatchEnd = match.end;
    }

    // Thêm phần text còn lại
    if (lastMatchEnd < message.length) {
      spans.add(TextSpan(
        text: message.substring(lastMatchEnd),
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontSize: 15,
          height: 1.4,
        ),
      ));
    }

    return spans;
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 12,
        left: isUser ? 60 : 0,
        right: isUser ? 0 : 60,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && showAvatar) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          if (!isUser && !showAvatar)
            const SizedBox(width: 40),
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                gradient: isUser 
                  ? LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
                color: isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 5),
                  bottomRight: Radius.circular(isUser ? 5 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUser ? Colors.blue : Colors.grey)
                      .withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: isUser 
                  ? null 
                  : Border.all(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: _buildMessageContent(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildTimestamp(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.assistant,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTimestamp() {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        _formatTimestamp(timestamp),
        style: TextStyle(
          fontSize: 12,
          color: isUser 
            ? Colors.white.withOpacity(0.7)
            : Colors.grey.shade500,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}