import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:chewie/chewie.dart';
import 'package:shtt_bentre/src/mainData/config/url.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuideContent {
  final int id;
  final String title;
  final String slug;
  String? content;
  final String? publishedAt;
  bool isLoading;

  GuideContent({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.publishedAt,
    this.isLoading = false,
  });

  factory GuideContent.fromJson(Map<String, dynamic> json) {
    return GuideContent(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'],
      publishedAt: json['published_at'],
    );
  }
}

class GuidePage extends StatefulWidget {
  final String title;
  final int parentId;
  final int? videoId;

  const GuidePage({
    super.key,
    required this.title,
    required this.parentId,
    this.videoId,
  });

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  List<GuideContent> _items = [];
  bool _isLoading = true;
  String? _error;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoLoading = true;
  String? _videoError;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchList();
    if (widget.videoId != null) {
      _fetchVideo();
    } else {
      _isVideoLoading = false;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initTabController() {
    _tabController = TabController(
      length: _items.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabSelected(_tabController.index);
      }
    });
  }

  Future<void> _fetchVideo() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final response = await http.get(
        Uri.parse('${MainUrl.apiUrl}/advisory-supports/video/${widget.videoId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final videoPath = data['data']['file_path'];
          final videoUrl = '${MainUrl.storageUrl}/$videoPath';
          
          _videoController = VideoPlayerController.network(videoUrl);
          await _videoController!.initialize();
          
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            aspectRatio: 16 / 9,
            autoPlay: false,
            looping: false,
            showControls: true,
            placeholder: Container(
              color: Colors.grey[100],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.blue,
                ),
              ),
            ),
            materialProgressColors: ChewieProgressColors(
              playedColor: Colors.blue.shade600,
              handleColor: Colors.blue.shade600,
              backgroundColor: Colors.grey.shade300,
              bufferedColor: Colors.blue.shade100,
            ),
          );

          setState(() {
            _isVideoLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _videoError = '${l10n.error}: $e';
        _isVideoLoading = false;
      });
    }
  }

  Future<void> _fetchList() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final response = await http.get(
        Uri.parse('${MainUrl.apiUrl}/advisory-supports/parent/${widget.parentId}'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> documents = List.from(data['data'])
            ..sort((a, b) => a['id'].compareTo(b['id']));
          
          setState(() {
            _items = documents.map((doc) => GuideContent.fromJson(doc)).toList();
            _isLoading = false;
          });

          _initTabController();

          if (_items.isNotEmpty) {
            _fetchContent(_items[0].id);
          }
        }
      }
    } catch (e) {
      setState(() {
        _error = '${l10n.error}: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchContent(int id) async {
    final l10n = AppLocalizations.of(context)!;
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex == -1) return;

    setState(() {
      _items[itemIndex].isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${MainUrl.apiUrl}/advisory-supports/$id'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _items[itemIndex].content = data['data']['content'];
            _items[itemIndex].isLoading = false;
          });
          
          // Scroll to top when content changes
          _scrollController.animateTo(
            widget.videoId != null ? 250 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    } catch (e) {
      setState(() {
        _items[itemIndex].isLoading = false;
        _error = '${l10n.error}: $e';
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    
    final selectedItem = _items[index];
    if (selectedItem.content == null && !selectedItem.isLoading) {
      _fetchContent(selectedItem.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.blue,
            ),
          )
        : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _isLoading = true;
                        });
                        _fetchList();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.tryAgain),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  if (widget.videoId != null) _buildVideo(),
                  _buildTabBar(),
                  _buildSelectedContent(),
                ],
              ),
            ),
    );
  }

  Widget _buildVideo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isVideoLoading)
            const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.blue,
                ),
              ),
            )
          else if (_videoError != null)
            Container(
              height: 200,
              color: Colors.grey[100],
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 36,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _videoError!,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            )
          else if (_chewieController != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Chewie(controller: _chewieController!),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    if (_items.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.blue,
            indicatorWeight: 3,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            tabs: _items.map((item) {
              return Tab(
                text: item.title,
              );
            }).toList(),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildSelectedContent() {
    final l10n = AppLocalizations.of(context)!;
    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(l10n.noContent),
      );
    }

    final selectedItem = _items[_selectedTabIndex];
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: selectedItem.isLoading
          ? SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadingContent,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedItem.content != null)
                  Html(
                    data: selectedItem.content!,
                    style: {
                      "body": Style(
                        fontSize: FontSize(15),
                        lineHeight: const LineHeight(1.6),
                        color: Colors.black87,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        textAlign: TextAlign.justify,
                      ),
                      "p": Style(
                        margin: Margins.only(bottom: 12),
                        textAlign: TextAlign.justify,
                      ),
                      "strong": Style(
                        fontWeight: FontWeight.w600,
                      ),
                      "em": Style(
                        fontStyle: FontStyle.italic,
                      ),
                      "a": Style(
                        color: Colors.blue[700],
                        textDecoration: TextDecoration.none,
                      ),
                      "ul": Style(
                        margin: Margins.only(left: 20, bottom: 16, top: 8),
                      ),
                      "ol": Style(
                        margin: Margins.only(left: 20, bottom: 16, top: 8),
                      ),
                      "li": Style(
                        margin: Margins.only(bottom: 8),
                      ),
                      "table": Style(
                        backgroundColor: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        margin: Margins.only(bottom: 16),
                      ),
                      "th": Style(
                        backgroundColor: Colors.grey.shade50,
                        padding: HtmlPaddings.all(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      "td": Style(
                        padding: HtmlPaddings.all(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      "h1": Style(
                        fontSize: FontSize(24),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        margin: Margins.only(bottom: 16, top: 24),
                      ),
                      "h2": Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        margin: Margins.only(bottom: 16, top: 24),
                      ),
                      "h3": Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        margin: Margins.only(bottom: 12, top: 20),
                      ),
                      "blockquote": Style(
                        backgroundColor: Colors.blue.shade50,
                        padding: HtmlPaddings.all(16),
                        border: Border(
                          left: BorderSide(
                            color: Colors.blue.shade200,
                            width: 4,
                          ),
                        ),
                        margin: Margins.symmetric(vertical: 16),
                      ),
                      "code": Style(
                        backgroundColor: Colors.grey.shade100,
                        padding: HtmlPaddings.symmetric(horizontal: 4),
                        fontFamily: 'monospace',
                      ),
                      "pre": Style(
                        backgroundColor: Colors.grey.shade100,
                        padding: HtmlPaddings.all(16),
                        margin: Margins.symmetric(vertical: 16),
                      ),
                    },
                    onLinkTap: (String? url, _, __) {
                      if (url != null) {
                        debugPrint('Tapped link: $url');
                      }
                    },
                  ),
                if (selectedItem.content == null && !selectedItem.isLoading)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noContent,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
      ),
    );
  }
}