// Firestore-backed content models for every section that is currently
// hardcoded in the portfolio widgets. Each list-type model follows the same
// shape as the rest of the codebase (see site_config_models.dart /
// content_models.dart): `id` (Firestore doc id), `displayOrder` (admin-set
// sort key), `isVisible` (admin hide/show), plus the section's own fields.
//
// Icon fields are stored as a `iconKey` string rather than a Flutter Widget/
// IconData so they can be saved to Firestore and picked from a fixed set in
// the admin UI. The widget layer maps `iconKey` -> IconData when rendering.
import 'package:cloud_firestore/cloud_firestore.dart';

// ─── Home Hero (singleton doc) ──────────────────────────────────────────────
//
// Bio/name/title/email live on BasicDetails (site_sections/owner_profile).
// This doc only holds the hero-specific copy the "Home Content" admin panel
// edits: tagline, CTA labels, and the availability toggle.

class HomeHeroContent {
  const HomeHeroContent({
    this.tagline = '',
    this.ctaPrimaryLabel = 'See what I can do',
    this.isAvailableForWork = true,
    this.updatedAt,
  });

  final String tagline;
  final String ctaPrimaryLabel;
  final bool isAvailableForWork;
  final DateTime? updatedAt;

  factory HomeHeroContent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return HomeHeroContent(
      tagline: data['tagline'] as String? ?? '',
      ctaPrimaryLabel:
          data['ctaPrimaryLabel'] as String? ?? 'See what I can do',
      isAvailableForWork: data['isAvailableForWork'] as bool? ?? true,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tagline': tagline,
      'ctaPrimaryLabel': ctaPrimaryLabel,
      'isAvailableForWork': isAvailableForWork,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  HomeHeroContent copyWith({
    String? tagline,
    String? ctaPrimaryLabel,
    bool? isAvailableForWork,
  }) {
    return HomeHeroContent(
      tagline: tagline ?? this.tagline,
      ctaPrimaryLabel: ctaPrimaryLabel ?? this.ctaPrimaryLabel,
      isAvailableForWork: isAvailableForWork ?? this.isAvailableForWork,
      updatedAt: updatedAt,
    );
  }

  static HomeHeroContent defaults() => const HomeHeroContent(
    tagline: 'turning your ideas into pixel-perfect realities',
  );
}

// ─── Skills ─────────────────────────────────────────────────────────────────
//
// Allowed iconKey values (mapped to IconData in the widget layer):
// fire, code, phone_android, language, palette, javascript, database,
// cloud, terminal, layers, bolt, star.

class SkillItem {
  const SkillItem({
    required this.id,
    required this.name,
    required this.percent,
    required this.iconKey,
    this.description = '',
    this.category = '',
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String name;
  final int percent;
  final String iconKey;
  final String description;
  final String category;
  final int displayOrder;
  final bool isVisible;

  factory SkillItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return SkillItem(
      id: doc.id,
      name: data['name'] as String? ?? '',
      percent: (data['percent'] as num?)?.toInt() ?? 0,
      iconKey: data['iconKey'] as String? ?? 'code',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'percent': percent,
      'iconKey': iconKey,
      'description': description,
      'category': category,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  SkillItem copyWith({
    String? name,
    int? percent,
    String? iconKey,
    String? description,
    String? category,
    int? displayOrder,
    bool? isVisible,
  }) {
    return SkillItem(
      id: id,
      name: name ?? this.name,
      percent: percent ?? this.percent,
      iconKey: iconKey ?? this.iconKey,
      description: description ?? this.description,
      category: category ?? this.category,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<SkillItem> defaults() {
    return const [
      SkillItem(
        id: 'firebase',
        name: 'Firebase',
        percent: 80,
        iconKey: 'fire',
        description: 'Leading collaborative design tool',
        displayOrder: 1,
      ),
      SkillItem(
        id: 'javascript',
        name: 'JavaScript',
        percent: 50,
        iconKey: 'javascript',
        description: 'Leading collaborative design tool',
        displayOrder: 2,
      ),
      SkillItem(
        id: 'html',
        name: 'HTML',
        percent: 70,
        iconKey: 'language',
        description: 'Leading collaborative design tool',
        displayOrder: 3,
      ),
      SkillItem(
        id: 'css',
        name: 'CSS',
        percent: 70,
        iconKey: 'palette',
        description: 'Leading collaborative design tool',
        displayOrder: 4,
      ),
      SkillItem(
        id: 'flutter',
        name: 'Flutter',
        percent: 85,
        iconKey: 'phone_android',
        description: 'Leading collaborative design tool',
        displayOrder: 5,
      ),
      SkillItem(
        id: 'dart',
        name: 'Dart',
        percent: 90,
        iconKey: 'code',
        description: 'Leading collaborative design tool',
        displayOrder: 6,
      ),
    ];
  }
}

// ─── Education (About page) ─────────────────────────────────────────────────

class EducationItem {
  const EducationItem({
    required this.id,
    required this.title,
    required this.period,
    required this.description,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String title;
  final String period;
  final String description;
  final int displayOrder;
  final bool isVisible;

  factory EducationItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return EducationItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      period: data['period'] as String? ?? '',
      description: data['description'] as String? ?? '',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'period': period,
      'description': description,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  EducationItem copyWith({
    String? title,
    String? period,
    String? description,
    int? displayOrder,
    bool? isVisible,
  }) {
    return EducationItem(
      id: id,
      title: title ?? this.title,
      period: period ?? this.period,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<EducationItem> defaults() {
    return const [
      EducationItem(
        id: 'bsc-mathematics',
        title: 'BSc Mathematics',
        period: 'Jun 2013 – Jun 2016',
        description:
            'Devaswom Board Pampa College, Parumala. Built a strong analytical and problem-solving foundation.',
        displayOrder: 1,
      ),
      EducationItem(
        id: 'higher-secondary-cs',
        title: 'Higher Secondary — Computer Science',
        period: 'Jun 2011 – Jun 2013',
        description:
            'Govt. Higher Secondary School, Budhanoor. First exposure to programming and computer fundamentals.',
        displayOrder: 2,
      ),
      EducationItem(
        id: 'flutter-self-learning',
        title: 'Flutter & Mobile Development',
        period: '2021 – Present',
        description:
            'Continuous self-learning — Flutter, Dart, Firebase, Bloc, GetX, Figma, REST APIs, and payment integrations.',
        displayOrder: 3,
      ),
      EducationItem(
        id: 'brototype-internship',
        title: 'Internship — Brototype, Kochi',
        period: 'Oct 2021 – Oct 2022',
        description:
            'Intensive full-stack Flutter training. Built real-world projects with Google Maps, Firebase, and GetX state management.',
        displayOrder: 4,
      ),
    ];
  }
}

// ─── Experience Strengths (Experience page) ─────────────────────────────────

class ExperienceStrengthItem {
  const ExperienceStrengthItem({
    required this.id,
    required this.title,
    required this.description,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String title;
  final String description;
  final int displayOrder;
  final bool isVisible;

  factory ExperienceStrengthItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ExperienceStrengthItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ExperienceStrengthItem copyWith({
    String? title,
    String? description,
    int? displayOrder,
    bool? isVisible,
  }) {
    return ExperienceStrengthItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<ExperienceStrengthItem> defaults() {
    return const [
      ExperienceStrengthItem(
        id: 'cross-platform-thinking',
        title: 'Cross-Platform Thinking',
        description:
            'Build experiences that feel polished and consistent across mobile and web without losing product clarity.',
        displayOrder: 1,
      ),
      ExperienceStrengthItem(
        id: 'clean-execution',
        title: 'Clean Execution',
        description:
            'Turn requirements into maintainable Flutter implementations with scalable structure and readable code.',
        displayOrder: 2,
      ),
      ExperienceStrengthItem(
        id: 'design-awareness',
        title: 'Design Awareness',
        description:
            'Care about rhythm, spacing, motion, and UX details so delivery feels intentional rather than assembled.',
        displayOrder: 3,
      ),
      ExperienceStrengthItem(
        id: 'reliable-collaboration',
        title: 'Reliable Collaboration',
        description:
            'Keep projects moving with communication, feedback loops, and a practical balance between quality and speed.',
        displayOrder: 4,
      ),
    ];
  }
}

// ─── Achievements (Home page) ───────────────────────────────────────────────
//
// Allowed iconKey values: satisfaction, experience, projects, trophy, star,
// chart.  Colors are stored as hex strings ("#RRGGBB") so the admin form can
// use plain text/color-picker inputs; the widget layer parses them.

class AchievementItem {
  const AchievementItem({
    required this.id,
    required this.number,
    required this.description,
    required this.iconKey,
    this.backgroundColorHex = '#1F2937',
    this.textColorHex = '#FFFFFF',
    this.numberColorHex = '#FFFFFF',
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String number;
  final String description;
  final String iconKey;
  final String backgroundColorHex;
  final String textColorHex;
  final String numberColorHex;
  final int displayOrder;
  final bool isVisible;

  factory AchievementItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return AchievementItem(
      id: doc.id,
      number: data['number'] as String? ?? '',
      description: data['description'] as String? ?? '',
      iconKey: data['iconKey'] as String? ?? 'trophy',
      backgroundColorHex: data['backgroundColorHex'] as String? ?? '#1F2937',
      textColorHex: data['textColorHex'] as String? ?? '#FFFFFF',
      numberColorHex: data['numberColorHex'] as String? ?? '#FFFFFF',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'number': number,
      'description': description,
      'iconKey': iconKey,
      'backgroundColorHex': backgroundColorHex,
      'textColorHex': textColorHex,
      'numberColorHex': numberColorHex,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  AchievementItem copyWith({
    String? number,
    String? description,
    String? iconKey,
    String? backgroundColorHex,
    String? textColorHex,
    String? numberColorHex,
    int? displayOrder,
    bool? isVisible,
  }) {
    return AchievementItem(
      id: id,
      number: number ?? this.number,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
      textColorHex: textColorHex ?? this.textColorHex,
      numberColorHex: numberColorHex ?? this.numberColorHex,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<AchievementItem> defaults() {
    return const [
      AchievementItem(
        id: 'customer-satisfaction',
        number: '95+',
        description: 'Percent customer satisfaction',
        iconKey: 'satisfaction',
        backgroundColorHex: '#7ED957',
        textColorHex: '#374151',
        numberColorHex: '#000000',
        displayOrder: 1,
      ),
      AchievementItem(
        id: 'years-experience',
        number: '2+',
        description: 'Years of experience',
        iconKey: 'experience',
        backgroundColorHex: '#1F2937',
        textColorHex: '#FFFFFF',
        numberColorHex: '#FFFFFF',
        displayOrder: 2,
      ),
      AchievementItem(
        id: 'projects-completed',
        number: '3+',
        description: 'Projects completed',
        iconKey: 'projects',
        backgroundColorHex: '#FFFFFF',
        textColorHex: '#000000',
        numberColorHex: '#000000',
        displayOrder: 3,
      ),
    ];
  }
}

// ─── Freelance Process (Home page) ──────────────────────────────────────────

class ProcessStepDetail {
  const ProcessStepDetail({required this.key, required this.description});

  final String key;
  final String description;

  factory ProcessStepDetail.fromMap(Map<String, dynamic> data) {
    return ProcessStepDetail(
      key: data['key'] as String? ?? '',
      description: data['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'key': key, 'description': description};
}

class ProcessStepItem {
  const ProcessStepItem({
    required this.id,
    required this.label,
    required this.number,
    required this.title,
    required this.items,
    required this.timeEstimate,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String label;
  final String number;
  final String title;
  final List<ProcessStepDetail> items;
  final String timeEstimate;
  final int displayOrder;
  final bool isVisible;

  factory ProcessStepItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final items =
        (data['items'] as List<dynamic>? ?? [])
            .map((v) => ProcessStepDetail.fromMap(v as Map<String, dynamic>))
            .toList();
    return ProcessStepItem(
      id: doc.id,
      label: data['label'] as String? ?? '',
      number: data['number'] as String? ?? '',
      title: data['title'] as String? ?? '',
      items: items,
      timeEstimate: data['timeEstimate'] as String? ?? '',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'label': label,
      'number': number,
      'title': title,
      'items': items.map((i) => i.toMap()).toList(),
      'timeEstimate': timeEstimate,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ProcessStepItem copyWith({
    String? label,
    String? number,
    String? title,
    List<ProcessStepDetail>? items,
    String? timeEstimate,
    int? displayOrder,
    bool? isVisible,
  }) {
    return ProcessStepItem(
      id: id,
      label: label ?? this.label,
      number: number ?? this.number,
      title: title ?? this.title,
      items: items ?? this.items,
      timeEstimate: timeEstimate ?? this.timeEstimate,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<ProcessStepItem> defaults() {
    return const [
      ProcessStepItem(
        id: 'discovery',
        label: 'Discovery',
        number: '01',
        title:
            "We'll dive deep into your personal goals and long-term vision",
        timeEstimate: '3-5 days',
        displayOrder: 1,
        items: [
          ProcessStepDetail(
            key: 'Initial Consultation:',
            description:
                "Understand the client's vision, goals, and target audience.",
          ),
          ProcessStepDetail(
            key: 'Research:',
            description:
                'Analyze competitors and industry trends to gather insights.',
          ),
          ProcessStepDetail(
            key: 'Define Scope:',
            description:
                "Set the project's objectives, deliverables, and timelines.",
          ),
        ],
      ),
      ProcessStepItem(
        id: 'design',
        label: 'Design',
        number: '02',
        title: "I'll create mockups that bring your brand to life",
        timeEstimate: '1-2 weeks',
        displayOrder: 2,
        items: [
          ProcessStepDetail(
            key: 'Wireframing:',
            description:
                "Create low-fidelity wireframes to map out the site's structure.",
          ),
          ProcessStepDetail(
            key: 'Style Guide Creation:',
            description:
                'Develop a design language including colors, fonts, and UI elements.',
          ),
          ProcessStepDetail(
            key: 'Prototype Development:',
            description: 'Build clickable prototypes for client feedback.',
          ),
          ProcessStepDetail(
            key: 'Finalize Design:',
            description:
                'Approve the final design with detailed mockups for all pages.',
          ),
        ],
      ),
      ProcessStepItem(
        id: 'build',
        label: 'Build',
        number: '03',
        title: "Using coding tools, I'll construct your site",
        timeEstimate: '1 week',
        displayOrder: 3,
        items: [
          ProcessStepDetail(
            key: 'Page Construction:',
            description:
                'Build out the website structure using selected tools.',
          ),
          ProcessStepDetail(
            key: 'Content Integration:',
            description: 'Import and format content (text, images, videos).',
          ),
        ],
      ),
      ProcessStepItem(
        id: 'launch',
        label: 'Launch',
        number: '04',
        title: 'Your site goes live, ready to make an impact',
        timeEstimate: '2-3 days',
        displayOrder: 4,
        items: [
          ProcessStepDetail(
            key: 'Client Review:',
            description: 'Present the site to the client for feedback.',
          ),
          ProcessStepDetail(
            key: 'Revisions:',
            description: 'Make necessary changes based on client feedback.',
          ),
        ],
      ),
    ];
  }
}

// ─── Testimonials (Home page) ───────────────────────────────────────────────
//
// Moved to Supabase — see `TestimonialEntry` in `testimonial_entry.dart` and
// `SupabaseTestimonialsService`. Testimonials now come from a public
// submission page with a pending/published/hidden moderation workflow and an
// uploaded photo, which Firestore/Spark (no Storage) can't support.

// ─── FAQ (Home page) ─────────────────────────────────────────────────────────

class FaqItem {
  const FaqItem({
    required this.id,
    required this.number,
    required this.question,
    required this.answer,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String number;
  final String question;
  final String answer;
  final int displayOrder;
  final bool isVisible;

  factory FaqItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return FaqItem(
      id: doc.id,
      number: data['number'] as String? ?? '',
      question: data['question'] as String? ?? '',
      answer: data['answer'] as String? ?? '',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'number': number,
      'question': question,
      'answer': answer,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  FaqItem copyWith({
    String? number,
    String? question,
    String? answer,
    int? displayOrder,
    bool? isVisible,
  }) {
    return FaqItem(
      id: id,
      number: number ?? this.number,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<FaqItem> defaults() {
    return const [
      FaqItem(
        id: 'project-timeline',
        number: '01',
        question: 'What is your typical project timeline?',
        answer:
            "Project timelines vary depending on the scope and complexity. A typical website project takes 2-4 weeks from discovery to launch. This includes design, development, content integration, and testing phases. I'll provide a detailed timeline during our initial consultation based on your specific requirements.",
        displayOrder: 1,
      ),
      FaqItem(
        id: 'maintenance-support',
        number: '02',
        question: 'Do you offer ongoing maintenance and support?',
        answer:
            'Yes, I offer ongoing maintenance and support packages to keep your website running smoothly. This includes regular updates, security patches, content updates, and technical support. We can discuss a maintenance plan that fits your needs and budget.',
        displayOrder: 2,
      ),
      FaqItem(
        id: 'brand-guidelines',
        number: '03',
        question: 'Can you work with existing brand guidelines?',
        answer:
            "Absolutely! I can work with your existing brand guidelines, including colors, fonts, logos, and design elements. I'll ensure your new website aligns perfectly with your brand identity while bringing fresh, modern design solutions to enhance your online presence.",
        displayOrder: 3,
      ),
      FaqItem(
        id: 'revisions-feedback',
        number: '04',
        question: 'How do you handle revisions and feedback?',
        answer:
            "I believe in collaborative design and development. During the project, I'll share work-in-progress updates and incorporate your feedback. Each project includes a set number of revision rounds to ensure we get everything just right. Additional revisions can be arranged if needed.",
        displayOrder: 4,
      ),
    ];
  }
}

// ─── Development Areas marquee (Home page) ──────────────────────────────────

class DevAreaItem {
  const DevAreaItem({
    required this.id,
    required this.label,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String label;
  final int displayOrder;
  final bool isVisible;

  factory DevAreaItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return DevAreaItem(
      id: doc.id,
      label: data['label'] as String? ?? '',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'label': label,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  DevAreaItem copyWith({String? label, int? displayOrder, bool? isVisible}) {
    return DevAreaItem(
      id: id,
      label: label ?? this.label,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<DevAreaItem> defaults() {
    return const [
      DevAreaItem(id: 'ecommerce', label: 'E-commerce', displayOrder: 1),
      DevAreaItem(
        id: 'social-media-app',
        label: 'Social Media App',
        displayOrder: 2,
      ),
      DevAreaItem(id: 'blog', label: 'Blog', displayOrder: 3),
      DevAreaItem(id: 'block-chain', label: 'Block Chain', displayOrder: 4),
      DevAreaItem(
        id: 'ride-booking-app',
        label: 'Ride booking app',
        displayOrder: 5,
      ),
    ];
  }
}

// ─── Stats marquee (Home page, top + bottom strips) ─────────────────────────

class StatItemPlacement {
  const StatItemPlacement._();

  static const top = 'top';
  static const bottom = 'bottom';
  static const both = 'both';
}

class StatItem {
  const StatItem({
    required this.id,
    required this.value,
    required this.label,
    this.placement = StatItemPlacement.both,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String value;
  final String label;
  final String placement;
  final int displayOrder;
  final bool isVisible;

  factory StatItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return StatItem(
      id: doc.id,
      value: data['value'] as String? ?? '',
      label: data['label'] as String? ?? '',
      placement: data['placement'] as String? ?? StatItemPlacement.both,
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'value': value,
      'label': label,
      'placement': placement,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  StatItem copyWith({
    String? value,
    String? label,
    String? placement,
    int? displayOrder,
    bool? isVisible,
  }) {
    return StatItem(
      id: id,
      value: value ?? this.value,
      label: label ?? this.label,
      placement: placement ?? this.placement,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<StatItem> defaults() {
    return const [
      StatItem(
        id: 'years-experience',
        value: '2+',
        label: 'Years Experience',
        displayOrder: 1,
      ),
      StatItem(
        id: 'projects-completed',
        value: '20+',
        label: 'Projects Completed',
        displayOrder: 2,
      ),
      StatItem(
        id: 'client-satisfaction',
        value: '95%',
        label: 'Client Satisfaction',
        displayOrder: 3,
      ),
      StatItem(
        id: 'on-time-delivery',
        value: '100%',
        label: 'On-Time Delivery',
        displayOrder: 4,
      ),
    ];
  }
}

// ─── Resume Highlights (Resume page) ────────────────────────────────────────

class ResumeHighlightGroup {
  const ResumeHighlightGroup({
    required this.id,
    required this.title,
    required this.items,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  final String id;
  final String title;
  final List<String> items;
  final int displayOrder;
  final bool isVisible;

  factory ResumeHighlightGroup.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ResumeHighlightGroup(
      id: doc.id,
      title: data['title'] as String? ?? '',
      items:
          (data['items'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'items': items,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  ResumeHighlightGroup copyWith({
    String? title,
    List<String>? items,
    int? displayOrder,
    bool? isVisible,
  }) {
    return ResumeHighlightGroup(
      id: id,
      title: title ?? this.title,
      items: items ?? this.items,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<ResumeHighlightGroup> defaults() {
    return const [
      ResumeHighlightGroup(
        id: 'core-skills',
        title: 'Core Skills',
        displayOrder: 1,
        items: [
          'Flutter and Dart development',
          'Responsive web and mobile UI',
          'Firebase integrations',
          'REST API implementation',
          'Clean architecture patterns',
          'Performance-focused delivery',
        ],
      ),
      ResumeHighlightGroup(
        id: 'working-style',
        title: 'Working Style',
        displayOrder: 2,
        items: [
          'Design-aware implementation',
          'Strong product ownership',
          'Fast iteration with feedback',
          'Readable, maintainable code',
          'Collaborative communication',
          'Reliable delivery mindset',
        ],
      ),
      ResumeHighlightGroup(
        id: 'value-i-bring',
        title: 'Value I Bring',
        displayOrder: 3,
        items: [
          'Translate ideas into polished apps',
          'Balance speed with quality',
          'Build for scale and reuse',
          'Create consistent experiences',
          'Spot UX and technical gaps early',
          'Keep momentum across project phases',
        ],
      ),
    ];
  }
}

// ─── Blog settings (singleton) ──────────────────────────────────────────────
//
// Day 9 decision: blog posts themselves moved to Supabase (see
// `AdminBlogPost` in `lib/features/admin/modules/blog/models/`) so cover
// images can be uploaded through the same Supabase Storage flow as project
// banners — Firebase has no Storage on the Spark plan. This tiny singleton
// stays in Firestore alongside the other lightweight site config/toggles
// (`home_hero`, section visibility) since it's not per-post content, just a
// site-wide switch. A `BlogPostRecord` Firestore model used to live here
// (Days 1–2 scaffolding, never wired to a real UI) — removed rather than
// left as a second, unused blog-storage path once Supabase took over.

class BlogSettings {
  const BlogSettings({this.showDevToFeed = true});

  final bool showDevToFeed;

  factory BlogSettings.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return BlogSettings(
      showDevToFeed: data['showDevToFeed'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'showDevToFeed': showDevToFeed,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  BlogSettings copyWith({bool? showDevToFeed}) =>
      BlogSettings(showDevToFeed: showDevToFeed ?? this.showDevToFeed);

  static BlogSettings defaults() => const BlogSettings();
}
