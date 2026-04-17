import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../constants/colors.dart';
import '../controllers/portfolio_controller.dart';

// ─── Social automation backend URL ───────────────────────────────────────────
// ⚡ Replace with your actual backend URL after deploying the Node.js server
const String _backendUrl = 'http://localhost:3000';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _tagsController = TextEditingController();

  final _selectedPlatforms = <String>{
    'linkedin',
    'twitter',
    'medium',
    'instagram',
    'facebook',
  };

  bool _isPublishing = false;
  final _publishResults = <String, bool>{};

  final _platforms = [
    {'id': 'linkedin', 'name': 'LinkedIn', 'icon': FontAwesomeIcons.linkedin, 'color': const Color(0xFF0077B5)},
    {'id': 'twitter', 'name': 'Twitter/X', 'icon': FontAwesomeIcons.xTwitter, 'color': Colors.black},
    {'id': 'medium', 'name': 'Medium', 'icon': FontAwesomeIcons.medium, 'color': Colors.black},
    {'id': 'instagram', 'name': 'Instagram', 'icon': FontAwesomeIcons.instagram, 'color': const Color(0xFFE1306C)},
    {'id': 'facebook', 'name': 'Facebook', 'icon': FontAwesomeIcons.facebook, 'color': const Color(0xFF1877F2)},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      Get.snackbar(
        'Missing Fields',
        'Title and content are required.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isPublishing = true;
      _publishResults.clear();
    });

    final payload = {
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'imageUrl': _imageUrlController.text.trim(),
      'tags': _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
      'platforms': _selectedPlatforms.toList(),
    };

    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/api/publish/all'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        final results = result['results'] as Map<String, dynamic>? ?? {};
        setState(() {
          for (final entry in results.entries) {
            _publishResults[entry.key] =
                (entry.value as Map<String, dynamic>)['success'] == true;
          }
        });
        Get.snackbar(
          'Published!',
          'Your post has been sent to all selected platforms.',
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.black,
        );
      } else {
        _showBackendError();
      }
    } catch (e) {
      _showBackendError();
    }

    setState(() => _isPublishing = false);
  }

  void _showBackendError() {
    Get.dialog(
      AlertDialog(
        title: const Text('Backend Not Running'),
        content: const Text(
          'Could not connect to the social automation backend.\n\n'
          'Make sure your Node.js server is running:\n\n'
          '  cd social_automation\n'
          '  npm install\n'
          '  npm start\n\n'
          'See the README inside social_automation/ for setup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.primaryGreen.withOpacity(0.4)),
              ),
              child: Text(
                'ADMIN',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Publish Post',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Availability toggle
          Obx(() {
            final ctrl = Get.find<PortfolioController>();
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Text(
                    'Available',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: ctrl.isAvailableForWork.value,
                    onChanged: (_) => ctrl.toggleAvailability(),
                    activeColor: AppColors.primaryGreen,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform selector
                _buildSection('Select Platforms', _buildPlatformSelector()),
                const SizedBox(height: 24),

                // Post title
                _buildSection(
                  'Post Title',
                  _buildTextField(
                    controller: _titleController,
                    hint: 'My awesome new post...',
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 24),

                // Content
                _buildSection(
                  'Content',
                  _buildTextField(
                    controller: _contentController,
                    hint:
                        'Write your post content here. This will be formatted appropriately for each platform.',
                    maxLines: 12,
                  ),
                ),
                const SizedBox(height: 24),

                // Image URL
                _buildSection(
                  'Image URL (optional)',
                  _buildTextField(
                    controller: _imageUrlController,
                    hint: 'https://example.com/image.jpg',
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 24),

                // Tags
                _buildSection(
                  'Tags (comma separated)',
                  _buildTextField(
                    controller: _tagsController,
                    hint: 'flutter, dart, mobile, development',
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 32),

                // Publish results
                if (_publishResults.isNotEmpty) ...[
                  _buildPublishResults(),
                  const SizedBox(height: 24),
                ],

                // Publish button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isPublishing ? null : _publish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isPublishing
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Publishing to all platforms...'),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send_rounded, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Publish to ${_selectedPlatforms.length} Platform${_selectedPlatforms.length == 1 ? '' : 's'}',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 40),
                _buildBackendSetupCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.manrope(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(color: Colors.white24, fontSize: 15),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white12),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _platforms.map((p) {
        final id = p['id'] as String;
        final isSelected = _selectedPlatforms.contains(id);
        final color = p['color'] as Color;
        final icon = p['icon'] as IconData;
        final name = p['name'] as String;

        return GestureDetector(
          onTap: () => setState(() {
            if (isSelected) {
              _selectedPlatforms.remove(id);
            } else {
              _selectedPlatforms.add(id);
            }
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? color : Colors.white12,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(icon, size: 16, color: isSelected ? color : Colors.white38),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.white38,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.check_circle, size: 14, color: color),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPublishResults() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Publish Results',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ..._publishResults.entries.map((e) {
            final platform = _platforms.firstWhere(
              (p) => p['id'] == e.key,
              orElse: () => {'name': e.key, 'icon': Icons.circle, 'color': Colors.grey},
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    e.value ? Icons.check_circle : Icons.cancel,
                    color: e.value ? AppColors.primaryGreen : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    platform['name'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    e.value ? 'Posted ✓' : 'Failed ✗',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: e.value ? AppColors.primaryGreen : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBackendSetupCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 18),
              const SizedBox(width: 8),
              Text(
                'Backend Setup Required',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'To enable social media publishing, start the Node.js automation server:',
            style: GoogleFonts.manrope(fontSize: 13, color: Colors.white54),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'cd social_automation\n'
              'cp .env.example .env   # fill in your API keys\n'
              'npm install\n'
              'npm start',
              style: GoogleFonts.sourceCodePro(
                fontSize: 12,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'See social_automation/README.md for full API key setup for each platform.',
            style: GoogleFonts.manrope(fontSize: 12, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
