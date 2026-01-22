import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  final List<bool> _faqExpandedStates = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey[50]!],
        ),
      ),
      child: Column(
        children: [
          // Section identifier
          Text(
            "{05} — FAQ",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),

          // Main heading
          Text(
            "Got Questions?",
            style: GoogleFonts.manrope(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),

          // FAQ items
          _buildFAQSection(),
        ],
      ),
    );
  }

  List<Map<String, String>> get _faqItems => [
    {
      'question': 'What services do you offer?',
      'answer':
          'I offer mobile app development using Flutter, UI/UX design, and consultation services. I specialize in creating cross-platform mobile applications that work seamlessly on both iOS and Android.',
    },
    {
      'question': 'How long does a typical project take?',
      'answer':
          'Project timelines vary depending on complexity. A simple app might take 2-4 weeks, while a complex application could take 2-6 months. I provide detailed timelines during our initial consultation.',
    },
    {
      'question': 'Do you work with clients remotely?',
      'answer':
          'Yes, I work with clients worldwide remotely. I use modern communication tools and project management platforms to ensure smooth collaboration regardless of location.',
    },
    {
      'question': 'What is your pricing structure?',
      'answer':
          'My pricing is project-based and depends on the scope, complexity, and timeline. I offer competitive rates and provide detailed quotes after understanding your requirements. Contact me for a personalized quote.',
    },
  ];

  Widget _buildFAQSection() {
    return Column(
      children: List.generate(_faqItems.length, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildFAQItem(index),
        );
      }),
    );
  }

  Widget _buildFAQItem(int index) {
    final faq = _faqItems[index];
    final isExpanded = _faqExpandedStates[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Question header
          InkWell(
            onTap: () {
              setState(() {
                _faqExpandedStates[index] = !_faqExpandedStates[index];
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Question number
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Question text
                  Expanded(
                    child: Text(
                      faq['question']!,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Expand/collapse icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Answer content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isExpanded ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  faq['answer']!,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
