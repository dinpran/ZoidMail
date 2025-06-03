import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoidmail/auth/login_page.dart';
import 'package:zoidmail/helper/helper_functions.dart';
import 'package:zoidmail/pages/inbox_page.dart';
import 'package:zoidmail/service/auth_service.dart';
import 'package:zoidmail/service/database_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthServices _authService = AuthServices();
  final DatabaseService _dbService = DatabaseService();
  List<Map<String, dynamic>> _inboxes = [];
  String _tempEmailAddress = "temp@zoid.com";

  @override
  void initState() {
    super.initState();
    _loadInboxes();
  }

  Future<void> _loadInboxes() async {
    List<Map<String, dynamic>> inboxes = await _dbService.getUserInboxes();
    setState(() {
      _inboxes = inboxes;
    });
  }

  Future<void> _createInbox() async {
    String emailAddress = await _dbService.createInbox();
    setState(() {
      _tempEmailAddress = emailAddress;
    });
    await _loadInboxes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Inbox created: $emailAddress")),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard")),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.mail,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Zoid Mail",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _authService.signout();
              await HelperFunctions.setuserloggedinstatus(false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text(
              "Log in",
              style: TextStyle(
                color: Color(0xFF4A90E2),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Inbox in Seconds Gone in Minutes",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Temporary, encrypted, and always in your control\nZoid Mail is your first line of defense in a world\nfilled with digital clutter.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _tempEmailAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _copyToClipboard(_tempEmailAddress),
                            child: const Icon(
                              Icons.edit,
                              color: Color(0xFF4A90E2),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.qr_code, size: 18),
                            label: const Text("QR Code"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF4A90E2),
                              elevation: 0,
                              side: const BorderSide(color: Color(0xFF4A90E2)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _copyToClipboard(_tempEmailAddress),
                            icon: const Icon(Icons.copy, size: 18),
                            label: const Text("Copy"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90E2),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Inbox Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Inbox",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: _createInbox,
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    _inboxes.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              "No emails yet",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _inboxes.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              var inbox = _inboxes[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _getAvatarColor(index).withOpacity(0.1),
                                  child: Text(
                                    inbox["emailAddress"][0].toUpperCase(),
                                    style: TextStyle(
                                      color: _getAvatarColor(index),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                title: const Text(
                                  "Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: const Text(
                                  "Title of the Message",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InboxPage(
                                        emailAddress: inbox["emailAddress"],
                                      ),
                                    ),
                                  ).then((_) => _loadInboxes());
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // How to use section
              const Text(
                "How to use temporary Email",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              _buildHowToStep(1, "Copy temporary email address"),
              const SizedBox(height: 12),
              _buildHowToStep(2, "Use it to sign up on websites, socials"),
              const SizedBox(height: 12),
              _buildHowToStep(3, "Read incoming emails on this page"),

              const SizedBox(height: 24),

              // What is temporary email section
              const Text(
                "What is temporary email?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Temporary email protects your real email address from spam, ads, and malware. It's free, anonymous, and automatically expires after a short time. Often called \"10-minute mail\" or \"throwaway email,\" it's perfect for one-time use. You can use it to sign up on websites, download files, or access public Wi-Fi. No registration is required - just copy and start using it instantly. Temporary email helps you stay private and keep your main inbox clean.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowToStep(int number, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF4A90E2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
