import 'package:flutter/material.dart';
import 'package:zoidmail/pages/blogs/blog_detila_page.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  // Sample data for blog posts
  final List<Map<String, String>> blogPosts = [
    {
      'title': 'WHY GEN-Z LOVES ZOID MAIL',
      'description':
          'Gen Z loves Zoid Mail for its fast, no-fuss setup, sleek design, and total privacy—plus, it fits their vibe with instant emails, dark mode, and zero spam.',
      'image': 'assets/blog_1.png',
    },
    {
      'title': 'TOP USE CASES FOR ZOID MAIL',
      'description':
          'Top use cases for Zoid Mail include signing up for apps without spam, testing services risk-free, protecting privacy on giveaways, and managing',
      'image': 'assets/blog_2.png',
    },
    {
      'title': 'DIGITAL PRIVACY TREND',
      'description':
          'Digital privacy trends include being tracked, shared, and privacy-focused solutions.',
      'image': 'assets/blog_3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BLOGS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notification functionality here
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog post title
              // Text(
              //   "Get tips, stories and update on:".toUpperCase(),
              //   style: const TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.grey,
              //   ),
              // ),
              const SizedBox(height: 8),
              Text(
                blogPosts[index]['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Blog post card
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      blogPosts[index]['image']!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Blog description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogPosts[index]['description']!,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // View More button
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to BlogDetailPage with the selected blog data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlogDetailPage(
                                  title: blogPosts[index]['title']!,
                                  description: blogPosts[index]['description']!,
                                  imagePath: blogPosts[index]['image']!,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("VIEW MORE"),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
