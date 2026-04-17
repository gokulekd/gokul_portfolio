import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/firebase/firebase_bootstrap.dart';
import '../models/firebase_content_models.dart';
import '../models/portfolio_models.dart';

class FirebasePortfolioService {
  bool get isEnabled => FirebaseBootstrap.isReady;

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Stream<List<SiteSectionConfig>> streamSiteSections() {
    if (!isEnabled) {
      return Stream.value(const <SiteSectionConfig>[]);
    }

    return _firestore
        .collection('site_sections')
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(SiteSectionConfig.fromFirestore)
              .toList(growable: false),
        );
  }

  Stream<List<ManagedSocialLink>> streamSocialLinks() {
    if (!isEnabled) {
      return Stream.value(const <ManagedSocialLink>[]);
    }

    return _firestore
        .collection('social_links')
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(ManagedSocialLink.fromFirestore)
              .toList(growable: false),
        );
  }

  Stream<List<Project>> streamProjects() {
    if (!isEnabled) {
      return Stream.value(const <Project>[]);
    }

    return _firestore
        .collection('projects')
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(_projectFromFirestore).toList(growable: false),
        );
  }

  Future<void> updateSectionVisibility(
    SiteSectionConfig section,
    bool isVisible,
  ) async {
    if (!isEnabled) {
      return;
    }

    await _firestore
        .collection('site_sections')
        .doc(section.id)
        .set(
          section.copyWith(isVisible: isVisible).toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<void> saveProject(Project project) async {
    if (!isEnabled) {
      return;
    }

    final projectsRef = _firestore.collection('projects');
    final docRef =
        project.id.isEmpty ? projectsRef.doc() : projectsRef.doc(project.id);

    await docRef.set(
      _projectToFirestore(project.copyWith(id: docRef.id)),
      SetOptions(merge: true),
    );
  }

  Future<void> deleteProject(String projectId) async {
    if (!isEnabled || projectId.isEmpty) {
      return;
    }

    await _firestore.collection('projects').doc(projectId).delete();
  }

  Future<void> ensureSeedData({required String ownerEmail}) async {
    if (!isEnabled) {
      return;
    }

    final sectionsRef = _firestore.collection('site_sections');
    final socialRef = _firestore.collection('social_links');
    final projectsRef = _firestore.collection('projects');

    final sectionsSnapshot = await sectionsRef.limit(1).get();
    final socialSnapshot = await socialRef.limit(1).get();
    final projectsSnapshot = await projectsRef.limit(1).get();

    if (sectionsSnapshot.docs.isNotEmpty &&
        socialSnapshot.docs.isNotEmpty &&
        projectsSnapshot.docs.isNotEmpty) {
      return;
    }

    final batch = _firestore.batch();

    if (sectionsSnapshot.docs.isEmpty) {
      for (final section in SiteSectionConfig.defaultSections()) {
        batch.set(
          sectionsRef.doc(section.id),
          section.toFirestore(updatedByValue: ownerEmail),
        );
      }
    }

    if (socialSnapshot.docs.isEmpty) {
      for (final link in ManagedSocialLink.defaultLinks()) {
        batch.set(socialRef.doc(link.id), link.toFirestore());
      }
    }

    if (projectsSnapshot.docs.isEmpty) {
      for (final project in Project.defaultPortfolioProjects()) {
        batch.set(projectsRef.doc(project.id), _projectToFirestore(project));
      }
    }

    await batch.commit();
  }

  Project _projectFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Project(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Project',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      technologies: (data['technologies'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      githubUrl: data['githubUrl'] as String?,
      liveUrl: data['liveUrl'] as String?,
      category: data['category'] as String? ?? 'Mobile App',
      stars: (data['stars'] as num?)?.toInt() ?? 0,
      forks: (data['forks'] as num?)?.toInt() ?? 0,
      isFeatured: data['isFeatured'] as bool? ?? false,
      isPublished: data['isPublished'] as bool? ?? true,
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> _projectToFirestore(Project project) {
    return {
      'title': project.title,
      'description': project.description,
      'imageUrl': project.imageUrl,
      'technologies': project.technologies,
      'githubUrl': project.githubUrl,
      'liveUrl': project.liveUrl,
      'category': project.category,
      'stars': project.stars,
      'forks': project.forks,
      'isFeatured': project.isFeatured,
      'isPublished': project.isPublished,
      'displayOrder': project.displayOrder,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
