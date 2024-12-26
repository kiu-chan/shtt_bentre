import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

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

class _GuidePageState extends State<GuidePage> {
  int _selectedTabIndex = 0;
  List<GuideContent> _items = [];
  bool _isLoading = true;
  String? _error;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoLoading = true;
  String? _videoError;

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
    super.dispose();
  }

  Future<void> _fetchVideo() async {
    try {
      final response = await http.get(
        Uri.parse('https://shttbentre.girc.edu.vn/api/advisory-supports/video/${widget.videoId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final videoPath = data['data']['file_path'];
          final videoUrl = 'https://shttbentre.girc.edu.vn/storage/$videoPath';
          
          _videoController = VideoPlayerController.network(videoUrl);
          await _videoController!.initialize();
          
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            aspectRatio: 16 / 9,
            autoPlay: false,
            looping: false,
            showControls: true,
            placeholder: Container(
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            materialProgressColors: ChewieProgressColors(
              playedColor: Colors.blue,
              handleColor: Colors.blue,
              backgroundColor: Colors.grey,
              bufferedColor: Colors.grey[300]!,
            ),
          );

          setState(() {
            _isVideoLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _videoError = 'Có lỗi khi tải video: $e';
        _isVideoLoading = false;
      });
    }
  }

  Future<void> _fetchList() async {
    try {
      final response = await http.get(
        Uri.parse('https://shttbentre.girc.edu.vn/api/advisory-supports/parent/${widget.parentId}'),
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

          if (_items.isNotEmpty) {
            _fetchContent(_items[0].id);
          }
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Có lỗi xảy ra khi tải danh sách: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchContent(int id) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex == -1) return;

    setState(() {
      _items[itemIndex].isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://shttbentre.girc.edu.vn/api/advisory-supports/$id'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _items[itemIndex].content = data['data']['content'];
            _items[itemIndex].isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _items[itemIndex].isLoading = false;
        _error = 'Có lỗi xảy ra khi tải nội dung: $e';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Text(_error!))
          : SingleChildScrollView(
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
    if (_isVideoLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_videoError != null) {
      return Container(
        height: 200,
        color: Colors.grey[200],
        child: Center(child: Text(_videoError!)),
      );
    }

    if (_chewieController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Chewie(controller: _chewieController!),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildTab(item.title, index);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedTabIndex == index ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedTabIndex == index ? Colors.blue : Colors.grey[600],
            fontWeight: _selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    if (_items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Không có nội dung'),
      );
    }

    final selectedItem = _items[_selectedTabIndex];
    
    if (selectedItem.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedItem.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          if (selectedItem.content != null)
            Html(
              data: selectedItem.content!,
              style: {
                "body": Style(
                  fontSize: FontSize(15),
                  lineHeight: LineHeight(1.5),
                  color: Colors.black87,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.justify,
                ),
                "p": Style(
                  margin: Margins.only(bottom: 8),
                  textAlign: TextAlign.justify,
                ),
                "strong": Style(
                  fontWeight: FontWeight.bold,
                ),
                "em": Style(
                  fontStyle: FontStyle.italic,
                ),
                "a": Style(
                  color: Colors.blue,
                  textDecoration: TextDecoration.underline,
                ),
                "ul": Style(
                  margin: Margins.only(left: 20, bottom: 8),
                ),
                "ol": Style(
                  margin: Margins.only(left: 20, bottom: 8),
                ),
                "li": Style(
                  margin: Margins.only(bottom: 4),
                ),
              },
              onLinkTap: (String? url, _, __) {
                if (url != null) {
                  debugPrint('Tapped link: $url');
                }
              },
            ),
          if (selectedItem.content == null && !selectedItem.isLoading)
            const Text('Không có nội dung hiển thị'),
        ],
      ),
    );
  }
}