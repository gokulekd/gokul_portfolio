import 'package:go_router/go_router.dart';

import '../../features/admin/admin.dart';
import '../../features/portfolio/portfolio.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: AppRoutes.experience,
      builder: (context, state) => const ExperiencePage(),
    ),
    GoRoute(
      path: AppRoutes.projects,
      builder: (context, state) => const ProjectsPage(),
    ),
    GoRoute(
      path: AppRoutes.projectDetail,
      builder: (context, state) => ProjectDetailPage(
        projectId: state.pathParameters['id'] ?? '',
      ),
    ),
    // The Resume page was folded into About (CV download lives in its hero);
    // keep old /resume links working.
    GoRoute(path: AppRoutes.resume, redirect: (context, state) => AppRoutes.about),
    GoRoute(
      path: AppRoutes.blog,
      builder: (context, state) => const BlogPage(),
    ),
    GoRoute(
      path: AppRoutes.blogDetail,
      builder: (context, state) => BlogDetailPage(
        postId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.contact,
      builder: (context, state) => const ContactPage(),
    ),
    GoRoute(
      path: AppRoutes.skills,
      builder: (context, state) => const SkillsPage(),
    ),
    GoRoute(
      path: AppRoutes.admin,
      builder: (context, state) => AdminAuthGatePage(),
    ),
    GoRoute(
      path: AppRoutes.leaveReview,
      builder: (context, state) => const TestimonialSubmissionPage(),
    ),
  ],
);
