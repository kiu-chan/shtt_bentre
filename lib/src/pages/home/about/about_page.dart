import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shtt_bentre/src/mainData/data/home/about.dart';
import 'package:shtt_bentre/src/mainData/database/home/about.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late Future<AboutModel> futureAbout;

  @override
  void initState() {
    super.initState();
    futureAbout = fetchAboutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu'),
        centerTitle: true,
      ),
      body: FutureBuilder<AboutModel>(
        future: futureAbout,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final aboutData = snapshot.data!;
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aboutData.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Using flutter_html to render HTML content
                  Html(
                    data: aboutData.content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(15),
                        lineHeight: LineHeight(1.5),
                        textAlign: TextAlign.justify,
                        color: Colors.black87,
                      ),
                      "p": Style(
                        margin: Margins(top: Margin(8), bottom: Margin(8)),
                      ),
                    },
                  ),
                  const SizedBox(height: 12),
                  // Last updated info
                  Text(
                    'Cập nhật lần cuối: ${_formatDateTime(aboutData.updatedAt)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateTimeStr;
    }
  }
}

