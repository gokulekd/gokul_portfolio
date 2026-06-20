import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/responsive_helper.dart';
import '../../../providers/portfolio_provider.dart';
import '../widgets/contact/contact_channels_section.dart';
import '../widgets/contact/contact_closing_section.dart';
import '../widgets/contact/contact_form_section.dart';
import '../widgets/contact/contact_hero_section.dart';
import '../widgets/contact/contact_social_links_section.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/shared/footer_section.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ContactHeroSection(),
            ContactChannelsSection(info: state.personalInfo),
            SocialLinksSection(
              links: state.personalInfo.socialLinks,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveHelper.isMobile(context)
                    ? 20.0
                    : ResponsiveHelper.isTablet(context)
                        ? 48.0
                        : 88.0,
                ResponsiveHelper.isMobile(context) ? 48 : 80,
                ResponsiveHelper.isMobile(context)
                    ? 20.0
                    : ResponsiveHelper.isTablet(context)
                        ? 48.0
                        : 88.0,
                0,
              ),
              child: const ContactFormSection(),
            ),
            const ContactClosingSection(),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
