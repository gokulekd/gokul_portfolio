import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class FAQItem {
  final String number;
  final String question;
  final String answer;

  const FAQItem({
    required this.number,
    required this.question,
    required this.answer,
  });
}

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int? _expandedIndex;

  static const List<FAQItem> _faqItems = [
    FAQItem(
      number: "01",
      question: "What is your typical project timeline?",
      answer:
          "Project timelines vary depending on the scope and complexity. A typical website project takes 2-4 weeks from discovery to launch. This includes design, development, content integration, and testing phases. I'll provide a detailed timeline during our initial consultation based on your specific requirements.",
    ),
    FAQItem(
      number: "02",
      question: "Do you offer ongoing maintenance and support?",
      answer:
          "Yes, I offer ongoing maintenance and support packages to keep your website running smoothly. This includes regular updates, security patches, content updates, and technical support. We can discuss a maintenance plan that fits your needs and budget.",
    ),
    FAQItem(
      number: "03",
      question: "Can you work with existing brand guidelines?",
      answer:
          "Absolutely! I can work with your existing brand guidelines, including colors, fonts, logos, and design elements. I'll ensure your new website aligns perfectly with your brand identity while bringing fresh, modern design solutions to enhance your online presence.",
    ),
    FAQItem(
      number: "04",
      question: "How do you handle revisions and feedback?",
      answer:
          "I believe in collaborative design and development. During the project, I'll share work-in-progress updates and incorporate your feedback. Each project includes a set number of revision rounds to ensure we get everything just right. Additional revisions can be arranged if needed.",
    ),
  ];

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 0,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Section identifier
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "{05} – FAQ",
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Main title
                Text(
                  "Got Questions?",
                  style: GoogleFonts.manrope(
                    fontSize: isMobile ? 40 : 60,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                // FAQ Items
                ...List.generate(
                  _faqItems.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildFAQItem(_faqItems[index], index, isMobile),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item, int index, bool isMobile) {
    final isExpanded = _expandedIndex == index;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Question row
          InkWell(
            onTap: () => _toggleExpansion(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Number and question
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "${item.number}/",
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.question,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Expand/collapse button
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.125 : 0, // 45 degrees when expanded
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Answer (expandable)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                item.answer,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
