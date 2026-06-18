class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String about = '/about';
  static const String experience = '/experience';
  static const String projects = '/projects';
  static const String resume = '/resume';
  static const String blog = '/blog';
  static const String contact = '/contact';
  static const String skills = '/skills';
  static const String admin = '/admin';
  static const String projectDetail = '/projects/:id';

  static const Map<int, String> indexToRoute = {
    0: home,
    1: about,
    2: experience,
    3: projects,
    4: blog,
    5: contact,
    6: skills,
  };
}
