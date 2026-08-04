import 'package:flutter/material.dart';
import 'proud_achievements_painters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../models/site_content_models.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementCard {
  final String number;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final Color numberColor;
  final Widget icon;

  const AchievementCard({
    required this.number,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
    required this.numberColor,
    required this.icon,
  });
}

// Fixed icon/background/text/number style set that achievement cards rotate
// through by list position. Per-item iconKey/color fields on `AchievementItem`
// are deliberately not admin-editable (decided Day 1, confirmed Day 5) —
// this keeps the visual rhythm consistent no matter how many cards admin adds.
List<AchievementCard> _achievementCards(List<AchievementItem> achievements) {
  final styles = <({Color background, Color text, Color number, Widget Function() icon})>[
    (
      background: AppColors.primaryGreen,
      text: const Color(0xFF374151),
      number: Colors.black,
      icon: () => _SatisfactionIcon(color: Colors.black),
    ),
    (
      background: const Color(0xFF1F2937),
      text: Colors.white,
      number: Colors.white,
      icon: () => _ExperienceIcon(color: AppColors.primaryGreen),
    ),
    (
      background: Colors.white,
      text: Colors.black,
      number: Colors.black,
      icon: () => _ProjectsIcon(color: Colors.black),
    ),
  ];

  return [
    for (var i = 0; i < achievements.length; i++)
      AchievementCard(
        number: achievements[i].number,
        description: achievements[i].description,
        backgroundColor: styles[i % styles.length].background,
        textColor: styles[i % styles.length].text,
        numberColor: styles[i % styles.length].number,
        icon: styles[i % styles.length].icon(),
      ),
  ];
}

class ProudAchievementsSection extends ConsumerWidget {
  const ProudAchievementsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final achievements = ref.watch(
      portfolioProvider.select((s) => s.visibleAchievements),
    );
    final List<AchievementCard> cards = _achievementCards(achievements);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 0,
      ),
      color: Colors.black,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "{03} - Proud Achievements",
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
                        color: AppColors.skillsGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                if (isMobile)
                  Column(
                    children:
                        cards
                            .map(
                              (card) => Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: _buildCard(card, context),
                              ),
                            )
                            .toList(),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        cards
                            .map(
                              (card) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: _buildCard(card, context),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                const SizedBox(height: 100),
                _buildPrinciples(isMobile),
                const SizedBox(height: 100),
                _buildCta(isMobile, context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrinciples(bool isMobile) {
    final principles = [
      _PrincipleItem(
        title: "User-Centric",
        description:
            "I prioritize the end-user's experience, ensuring intuitive and engaging interfaces.",
        icon: Icons.people_outline,
      ),
      _PrincipleItem(
        title: "Clean Code",
        description:
            "Building scalable and maintainable codebases that grow with your business.",
        icon: Icons.code,
      ),
      _PrincipleItem(
        title: "Fast Delivery",
        description:
            "Efficient workflows and rapid prototyping to get your product to market sooner.",
        icon: Icons.speed,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "My Guiding Principles",
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I believe that great software is built on a foundation of clear communication and technical excellence.",
          style: GoogleFonts.manrope(
            fontSize: 18,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        if (isMobile)
          Column(
            children:
                principles
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: _buildPrincipleCard(item),
                      ),
                    )
                    .toList(),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                principles
                    .map(
                      (item) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _buildPrincipleCard(item),
                        ),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }

  Widget _buildPrincipleCard(_PrincipleItem item) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: AppColors.primaryGreen, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(AchievementCard card, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: card.backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.number,
            style: GoogleFonts.manrope(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: card.numberColor,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 80, width: double.infinity, child: card.icon),
          const SizedBox(height: 24),
          Text(
            card.description,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: card.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCta(bool isMobile, BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          'I blend creativity with technical expertise',
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 36 : 40,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            ref.read(portfolioProvider.notifier).changePage(5);
            context.go(AppRoutes.contact);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 40 : 64,
              vertical: isMobile ? 20 : 28,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            'Become a client',
            style: GoogleFonts.manrope(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Icon for Customer Satisfaction - Stylized Heart/Smile with particles
class _SatisfactionIcon extends StatelessWidget {
  final Color color;

  const _SatisfactionIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SatisfactionPainter(color: color),
      size: const Size(double.infinity, 80),
    );
  }
}

// Icon for Years of Experience - Rising Curve / Growth
class _ExperienceIcon extends StatelessWidget {
  final Color color;

  const _ExperienceIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GrowthPainter(color: color),
      size: const Size(double.infinity, 80),
    );
  }
}

// Icon for Projects Completed - Geometric Construction
class _ProjectsIcon extends StatelessWidget {
  final Color color;

  const _ProjectsIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CheckPainter(color: color),
      size: const Size(double.infinity, 80),
    );
  }
}

class _PrincipleItem {
  final String title;
  final String description;
  final IconData icon;

  const _PrincipleItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
