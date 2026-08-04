import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/firebase_bootstrap.dart';
import '../../features/admin/models/admin_portal_models.dart';
import '../../features/portfolio/models/firebase_content_models.dart';
import '../../features/portfolio/models/portfolio_models.dart';
import 'firestore_list_repository.dart';

class FirebasePortfolioService {
  bool get isEnabled => FirebaseBootstrap.isReady;

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  FirestoreListRepository<T> _repo<T>({
    required String collectionPath,
    required T Function(DocumentSnapshot<Map<String, dynamic>>) fromFirestore,
    required Map<String, dynamic> Function(T) toFirestore,
  }) {
    return FirestoreListRepository<T>(
      collection: _firestore.collection(collectionPath),
      fromFirestore: fromFirestore,
      toFirestore: toFirestore,
    );
  }

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

  Future<void> saveSocialLink(ManagedSocialLink link) async {
    if (!isEnabled) return;
    final ref = _firestore.collection('social_links');
    final docRef = link.id.isEmpty ? ref.doc() : ref.doc(link.id);
    await docRef.set(
      link.copyWith().toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<void> deleteSocialLink(String linkId) async {
    if (!isEnabled || linkId.isEmpty) return;
    await _firestore.collection('social_links').doc(linkId).delete();
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

  Stream<List<VisitorSubmission>> streamSubmissions() {
    if (!isEnabled) return Stream.value(const []);

    return _firestore
        .collection('submissions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => VisitorSubmission.fromFirestore(d.data(), d.id))
              .toList(growable: false),
        );
  }

  Future<void> updateSubmissionStatus(
    String id,
    SubmissionStatus status,
  ) async {
    if (!isEnabled || id.isEmpty) return;
    await _firestore
        .collection('submissions')
        .doc(id)
        .update({'status': status.name});
  }

  Future<void> addSubmissionNote(String id, String note) async {
    if (!isEnabled || id.isEmpty || note.trim().isEmpty) return;
    await _firestore.collection('submissions').doc(id).update({
      'notes': FieldValue.arrayUnion([note.trim()]),
    });
  }

  Stream<List<SitePageConfig>> streamPageConfigs() {
    if (!isEnabled) {
      return Stream.value(const <SitePageConfig>[]);
    }

    return _firestore
        .collection('page_configs')
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(SitePageConfig.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<void> updatePageVisibility(
    SitePageConfig page,
    bool isVisible,
  ) async {
    if (!isEnabled) return;
    await _firestore
        .collection('page_configs')
        .doc(page.id)
        .set(
          page.copyWith(isVisible: isVisible).toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<void> ensurePageConfigSeedData() async {
    if (!isEnabled) return;
    final ref = _firestore.collection('page_configs');
    final snapshot = await ref.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;
    final batch = _firestore.batch();
    for (final page in SitePageConfig.defaultPages()) {
      batch.set(ref.doc(page.id), page.toFirestore());
    }
    await batch.commit();
  }

  Stream<BasicDetails?> streamBasicDetails() {
    if (!isEnabled) return Stream.value(null);
    return _firestore
        .collection('site_sections')
        .doc('owner_profile')
        .snapshots()
        .map((doc) => doc.exists ? BasicDetails.fromFirestore(doc) : null);
  }

  Future<void> saveBasicDetails(BasicDetails details) async {
    if (!isEnabled) return;
    await _firestore
        .collection('site_sections')
        .doc('owner_profile')
        .set(details.toFirestore(), SetOptions(merge: true));
  }

  Future<void> ensureSeedData({required String ownerEmail}) async {
    if (!isEnabled) {
      return;
    }

    await ensureContentSeedData();

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

  // ─── Resume ─────────────────────────────────────────────────────────────────

  Stream<ResumeConfig?> streamResumeConfig() {
    if (!isEnabled) return Stream.value(null);
    return _firestore
        .collection('settings')
        .doc('resume')
        .snapshots()
        .map((doc) => doc.exists ? ResumeConfig.fromFirestore(doc) : null);
  }

  Future<void> saveResumeConfig(ResumeConfig config) async {
    if (!isEnabled) return;
    await _firestore
        .collection('settings')
        .doc('resume')
        .set(config.toFirestore(), SetOptions(merge: true));
  }

  // ─── Media Assets ────────────────────────────────────────────────────────────

  Stream<List<MediaAssetRecord>> streamMediaAssets() {
    if (!isEnabled) return Stream.value(const []);
    return _firestore
        .collection('media_assets')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(MediaAssetRecord.fromFirestore)
              .toList(growable: false),
        );
  }

  Future<void> saveMediaAsset(MediaAssetRecord asset) async {
    if (!isEnabled) return;
    final ref = _firestore.collection('media_assets');
    final docRef = asset.id.isEmpty ? ref.doc() : ref.doc(asset.id);
    await docRef.set(asset.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteMediaAsset(String id) async {
    if (!isEnabled || id.isEmpty) return;
    await _firestore.collection('media_assets').doc(id).delete();
  }

  // ─── Home Hero (singleton) ──────────────────────────────────────────────

  Stream<HomeHeroContent?> streamHomeHero() {
    if (!isEnabled) return Stream.value(null);
    return _firestore
        .collection('site_sections')
        .doc('home_hero')
        .snapshots()
        .map((doc) => doc.exists ? HomeHeroContent.fromFirestore(doc) : null);
  }

  Future<void> saveHomeHero(HomeHeroContent content) async {
    if (!isEnabled) return;
    await _firestore
        .collection('site_sections')
        .doc('home_hero')
        .set(content.toFirestore(), SetOptions(merge: true));
  }

  // ─── Generic content lists ───────────────────────────────────────────────
  //
  // Every list below (skills, education, experience, ...) is a straight
  // ordered Firestore collection edited via the admin workspace. They all
  // share the same repository shape, so each block is just wiring a model's
  // fromFirestore/toFirestore into FirestoreListRepository<T>.

  FirestoreListRepository<SkillItem> get _skillsRepo => _repo(
    collectionPath: 'skills',
    fromFirestore: SkillItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<SkillItem>> streamSkills() =>
      isEnabled ? _skillsRepo.stream() : Stream.value(const []);
  Future<void> saveSkill(SkillItem item) =>
      isEnabled ? _skillsRepo.save(item.id, item) : Future.value();
  Future<void> deleteSkill(String id) =>
      isEnabled ? _skillsRepo.delete(id) : Future.value();

  FirestoreListRepository<EducationItem> get _educationRepo => _repo(
    collectionPath: 'education',
    fromFirestore: EducationItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<EducationItem>> streamEducation() =>
      isEnabled ? _educationRepo.stream() : Stream.value(const []);
  Future<void> saveEducation(EducationItem item) =>
      isEnabled ? _educationRepo.save(item.id, item) : Future.value();
  Future<void> deleteEducation(String id) =>
      isEnabled ? _educationRepo.delete(id) : Future.value();

  FirestoreListRepository<Experience> get _experienceRepo => _repo(
    collectionPath: 'experience',
    fromFirestore: Experience.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<Experience>> streamExperience() =>
      isEnabled ? _experienceRepo.stream() : Stream.value(const []);
  Future<void> saveExperience(Experience item) =>
      isEnabled ? _experienceRepo.save(item.id, item) : Future.value();
  Future<void> deleteExperience(String id) =>
      isEnabled ? _experienceRepo.delete(id) : Future.value();

  FirestoreListRepository<ExperienceStrengthItem> get _strengthsRepo => _repo(
    collectionPath: 'experience_strengths',
    fromFirestore: ExperienceStrengthItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<ExperienceStrengthItem>> streamExperienceStrengths() =>
      isEnabled ? _strengthsRepo.stream() : Stream.value(const []);
  Future<void> saveExperienceStrength(ExperienceStrengthItem item) =>
      isEnabled ? _strengthsRepo.save(item.id, item) : Future.value();
  Future<void> deleteExperienceStrength(String id) =>
      isEnabled ? _strengthsRepo.delete(id) : Future.value();

  FirestoreListRepository<AchievementItem> get _achievementsRepo => _repo(
    collectionPath: 'achievements',
    fromFirestore: AchievementItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<AchievementItem>> streamAchievements() =>
      isEnabled ? _achievementsRepo.stream() : Stream.value(const []);
  Future<void> saveAchievement(AchievementItem item) =>
      isEnabled ? _achievementsRepo.save(item.id, item) : Future.value();
  Future<void> deleteAchievement(String id) =>
      isEnabled ? _achievementsRepo.delete(id) : Future.value();

  FirestoreListRepository<ProcessStepItem> get _processStepsRepo => _repo(
    collectionPath: 'freelance_process',
    fromFirestore: ProcessStepItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<ProcessStepItem>> streamProcessSteps() =>
      isEnabled ? _processStepsRepo.stream() : Stream.value(const []);
  Future<void> saveProcessStep(ProcessStepItem item) =>
      isEnabled ? _processStepsRepo.save(item.id, item) : Future.value();
  Future<void> deleteProcessStep(String id) =>
      isEnabled ? _processStepsRepo.delete(id) : Future.value();

  FirestoreListRepository<TestimonialItem> get _testimonialsRepo => _repo(
    collectionPath: 'testimonials',
    fromFirestore: TestimonialItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<TestimonialItem>> streamTestimonials() =>
      isEnabled ? _testimonialsRepo.stream() : Stream.value(const []);
  Future<void> saveTestimonial(TestimonialItem item) =>
      isEnabled ? _testimonialsRepo.save(item.id, item) : Future.value();
  Future<void> deleteTestimonial(String id) =>
      isEnabled ? _testimonialsRepo.delete(id) : Future.value();

  FirestoreListRepository<FaqItem> get _faqRepo => _repo(
    collectionPath: 'faq',
    fromFirestore: FaqItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<FaqItem>> streamFaq() =>
      isEnabled ? _faqRepo.stream() : Stream.value(const []);
  Future<void> saveFaqItem(FaqItem item) =>
      isEnabled ? _faqRepo.save(item.id, item) : Future.value();
  Future<void> deleteFaqItem(String id) =>
      isEnabled ? _faqRepo.delete(id) : Future.value();

  FirestoreListRepository<DevAreaItem> get _devAreasRepo => _repo(
    collectionPath: 'dev_areas',
    fromFirestore: DevAreaItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<DevAreaItem>> streamDevAreas() =>
      isEnabled ? _devAreasRepo.stream() : Stream.value(const []);
  Future<void> saveDevArea(DevAreaItem item) =>
      isEnabled ? _devAreasRepo.save(item.id, item) : Future.value();
  Future<void> deleteDevArea(String id) =>
      isEnabled ? _devAreasRepo.delete(id) : Future.value();

  FirestoreListRepository<StatItem> get _statsRepo => _repo(
    collectionPath: 'stats',
    fromFirestore: StatItem.fromFirestore,
    toFirestore: (item) => item.toFirestore(),
  );

  Stream<List<StatItem>> streamStats() =>
      isEnabled ? _statsRepo.stream() : Stream.value(const []);
  Future<void> saveStat(StatItem item) =>
      isEnabled ? _statsRepo.save(item.id, item) : Future.value();
  Future<void> deleteStat(String id) =>
      isEnabled ? _statsRepo.delete(id) : Future.value();

  FirestoreListRepository<ResumeHighlightGroup> get _resumeHighlightsRepo =>
      _repo(
        collectionPath: 'resume_highlights',
        fromFirestore: ResumeHighlightGroup.fromFirestore,
        toFirestore: (item) => item.toFirestore(),
      );

  Stream<List<ResumeHighlightGroup>> streamResumeHighlights() =>
      isEnabled ? _resumeHighlightsRepo.stream() : Stream.value(const []);
  Future<void> saveResumeHighlight(ResumeHighlightGroup item) =>
      isEnabled ? _resumeHighlightsRepo.save(item.id, item) : Future.value();
  Future<void> deleteResumeHighlight(String id) =>
      isEnabled ? _resumeHighlightsRepo.delete(id) : Future.value();

  // ─── Blog settings (singleton) ───────────────────────────────────────────
  // Blog post content itself lives in Supabase (see `SupabaseBlogService`) —
  // this just holds the "show Dev.to feed" site-wide toggle, same pattern as
  // Home Hero above.

  Stream<BlogSettings> streamBlogSettings() {
    if (!isEnabled) return Stream.value(BlogSettings.defaults());
    return _firestore
        .collection('site_sections')
        .doc('blog_settings')
        .snapshots()
        .map((doc) => doc.exists ? BlogSettings.fromFirestore(doc) : BlogSettings.defaults());
  }

  Future<void> saveBlogSettings(BlogSettings settings) async {
    if (!isEnabled) return;
    await _firestore
        .collection('site_sections')
        .doc('blog_settings')
        .set(settings.toFirestore(), SetOptions(merge: true));
  }

  // ─── Content list seeding ────────────────────────────────────────────────
  //
  // Seeds every collection above with the content that is (or was) hardcoded
  // in the public widgets, so admin lists never start empty and the public
  // site never visibly changes the moment Firestore starts driving it.

  Future<void> ensureContentSeedData() async {
    if (!isEnabled) return;

    Map<String, Map<String, dynamic>> seedOf<T>(
      List<T> items,
      String Function(T) idOf,
      Map<String, dynamic> Function(T) toFirestore,
    ) => {for (final item in items) idOf(item): toFirestore(item)};

    await Future.wait([
      _skillsRepo.seedIfEmpty(
        seedOf(SkillItem.defaults(), (i) => i.id, (i) => i.toFirestore()),
      ),
      _educationRepo.seedIfEmpty(
        seedOf(
          EducationItem.defaults(),
          (i) => i.id,
          (i) => i.toFirestore(),
        ),
      ),
      _experienceRepo.seedIfEmpty(
        seedOf(Experience.defaults(), (i) => i.id, (i) => i.toFirestore()),
      ),
      _strengthsRepo.seedIfEmpty(
        seedOf(
          ExperienceStrengthItem.defaults(),
          (i) => i.id,
          (i) => i.toFirestore(),
        ),
      ),
      _achievementsRepo.seedIfEmpty(
        seedOf(
          AchievementItem.defaults(),
          (i) => i.id,
          (i) => i.toFirestore(),
        ),
      ),
      _processStepsRepo.seedIfEmpty(
        seedOf(
          ProcessStepItem.defaults(),
          (i) => i.id,
          (i) => i.toFirestore(),
        ),
      ),
      _testimonialsRepo.seedIfEmpty(
        seedOf(
          TestimonialItem.defaults(),
          (i) => i.id,
          (i) => i.toFirestore(),
        ),
      ),
      _faqRepo.seedIfEmpty(
        seedOf(FaqItem.defaults(), (i) => i.id, (i) => i.toFirestore()),
      ),
      _devAreasRepo.seedIfEmpty(
        seedOf(DevAreaItem.defaults(), (i) => i.id, (i) => i.toFirestore()),
      ),
      _statsRepo.seedIfEmpty(
        seedOf(StatItem.defaults(), (i) => i.id, (i) => i.toFirestore()),
      ),
      _resumeHighlightsRepo.seedIfEmpty(
        seedOf(
          ResumeHighlightGroup.defaults(),
          (i) => i.id,
          (i) => i.toFirestore(),
        ),
      ),
    ]);

    final heroDoc = await _firestore
        .collection('site_sections')
        .doc('home_hero')
        .get();
    if (!heroDoc.exists) {
      await saveHomeHero(HomeHeroContent.defaults());
    }
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
