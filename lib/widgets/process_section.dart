import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessStep {
  final String label;
  final String number;
  final String title;
  final List<ProcessItem> items;
  final String timeEstimate;

  const ProcessStep({
    required this.label,
    required this.number,
    required this.title,
    required this.items,
    required this.timeEstimate,
  });
}

class ProcessItem {
  final String key;
  final String description;

  const ProcessItem({required this.key, required this.description});
}

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  static const List<ProcessStep> _steps = [
    ProcessStep(
      label: "Discovery",
      number: "01",
      title: "We'll dive deep into your personal goals and long-term vision",
      items: [
        ProcessItem(
          key: "Initial Consultation:",
          description:
              "Understand the client's vision, goals, and target audience.",
        ),
        ProcessItem(
          key: "Research:",
          description:
              "Analyze competitors and industry trends to gather insights.",
        ),
        ProcessItem(
          key: "Define Scope:",
          description:
              "Set the project's objectives, deliverables, and timelines.",
        ),
      ],
      timeEstimate: "3-5 days",
    ),
    ProcessStep(
      label: "Design",
      number: "02",
      title: "I'll create mockups that bring your brand to life",
      items: [
        ProcessItem(
          key: "Wireframing:",
          description:
              "Create low-fidelity wireframes to map out the site's structure.",
        ),
        ProcessItem(
          key: "Style Guide Creation:",
          description:
              "Develop a design language including colors, fonts, and UI elements.",
        ),
        ProcessItem(
          key: "Prototype Development:",
          description: "Build clickable prototypes for client feedback.",
        ),
        ProcessItem(
          key: "Finalize Design:",
          description:
              "Approve the final design with detailed mockups for all pages.",
        ),
      ],
      timeEstimate: "1-2 weeks",
    ),
    ProcessStep(
      label: "Build",
      number: "03",
      title: "Using coding tools, I'll construct your site",
      items: [
        ProcessItem(
          key: "Page Construction:",
          description: "Build out the website structure using selected tools.",
        ),
        ProcessItem(
          key: "Content Integration:",
          description: "Import and format content (text, images, videos).",
        ),
      ],
      timeEstimate: "1 week",
    ),
    ProcessStep(
      label: "Launch",
      number: "04",
      title: "Your site goes live, ready to make an impact",
      items: [
        ProcessItem(
          key: "Client Review:",
          description: "Present the site to the client for feedback.",
        ),
        ProcessItem(
          key: "Revisions:",
          description: "Make necessary changes based on client feedback.",
        ),
      ],
      timeEstimate: "2-3 days",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "{03} - Process",
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
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "How it works",
            style: GoogleFonts.manrope(
              fontSize: 60,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  ...List.generate(
                    _steps.length,
                    (index) => Column(
                      children: [
                        _buildProcessStep(_steps[index]),
                        if (index < _steps.length - 1)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 32),
                            height: 1,
                            color: Colors.grey[800],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(ProcessStep step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Text(
            step.label,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Forward slash
        Text(
          "/",
          style: GoogleFonts.manrope(fontSize: 20, color: Colors.grey[400]),
        ),
        const SizedBox(width: 8),
        // Number in lime green
        Text(
          step.number,
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        // Main content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with time estimate
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      step.title,
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "/${step.timeEstimate}/",
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Bullet points
              ...step.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "* ",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: item.key,
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: " ${item.description}",
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
