import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  late PageController _testimonialsPageController;
  int _currentTestimonialIndex = 0;

  @override
  void initState() {
    super.initState();
    _testimonialsPageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _testimonialsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.white],
        ),
      ),
      child: Column(
        children: [
          // Section identifier
          Text(
            "{04} — Testimonials",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),

          // Main heading
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Don't take my\nword for it",
                  style: GoogleFonts.manrope(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                ),
                TextSpan(
                  text: "*",
                  style: GoogleFonts.manrope(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF00D4AA), // Light green
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sub-heading
          Text(
            "* Take theirs",
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 60),

          // Testimonial carousel
          _buildTestimonialCarousel(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _testimonials => [
    {
      'rating': 5,
      'text':
          "Gokul delivered an exceptional mobile app that exceeded our expectations. His attention to detail and Flutter expertise made our project a huge success.",
      'author': 'Sarah Johnson',
      'avatar': 'SJ',
    },
    {
      'rating': 5,
      'text':
          "Working with Gokul was a pleasure. He understood our vision perfectly and created a beautiful, functional app that our users love.",
      'author': 'Michael Chen',
      'avatar': 'MC',
    },
    {
      'rating': 5,
      'text':
          "Gokul's Flutter development skills are outstanding. He delivered our project on time and with excellent quality. Highly recommended!",
      'author': 'Emily Rodriguez',
      'avatar': 'ER',
    },
  ];

  Widget _buildTestimonialCarousel() {
    return Column(
      children: [
        // Carousel
        SizedBox(
          height: 500,
          child: PageView.builder(
            controller: _testimonialsPageController,
            onPageChanged: (index) {
              setState(() {
                _currentTestimonialIndex = index;
              });
            },
            itemCount: _testimonials.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTestimonialCard(_testimonials[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 30),

        // Navigation dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_testimonials.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentTestimonialIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _currentTestimonialIndex == index
                        ? const Color(0xFF00D4AA)
                        : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // Navigation arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous button
            GestureDetector(
              onTap: () {
                if (_currentTestimonialIndex > 0) {
                  _testimonialsPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color:
                      _currentTestimonialIndex > 0
                          ? Colors.black87
                          : Colors.grey[400],
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Next button
            GestureDetector(
              onTap: () {
                if (_currentTestimonialIndex < _testimonials.length - 1) {
                  _testimonialsPageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      _currentTestimonialIndex < _testimonials.length - 1
                          ? Colors.black87
                          : Colors.grey[400],
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTestimonialCard(Map<String, dynamic> testimonial) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF00D4AA).withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating and quote icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Rating
              Row(
                children: [
                  Text(
                    '${testimonial['rating']}/5',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(testimonial['rating'] as int, (index) {
                    return const Icon(
                      Icons.star,
                      color: Color(0xFF00D4AA),
                      size: 20,
                    );
                  }),
                ],
              ),
              // Quote icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.format_quote,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Testimonial text
          Text(
            testimonial['text'] as String,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 30),

          // Author info
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00D4AA).withOpacity(0.2),
                      const Color(0xFF00D4AA).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    testimonial['avatar'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00D4AA),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Author name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial['author'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Client',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
