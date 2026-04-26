import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../controllers/admin_portal_controller.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/preview_tile.dart';

class SubmissionsWorkspace extends StatelessWidget {
  const SubmissionsWorkspace({
    super.key,
    required this.controller,
    required this.isCompact,
  });

  final AdminPortalController controller;
  final bool isCompact;

  static const _fallbackLeads = <AdminLeadItem>[
    AdminLeadItem(
      name: 'Aarav Studios',
      company: 'aarav.design',
      summary: 'Need a Flutter product site and admin dashboard in 3 weeks.',
      status: 'Unread',
      receivedAt: '6 min ago',
      unread: true,
    ),
    AdminLeadItem(
      name: 'Mira Health',
      company: 'mirahealth.io',
      summary: 'Asked for mobile app redesign, Firebase workflow, and support.',
      status: 'Reviewing',
      receivedAt: '48 min ago',
    ),
    AdminLeadItem(
      name: 'Northbound Labs',
      company: 'northboundlabs.com',
      summary: 'Requested portfolio-style case study site with blog migration.',
      status: 'Replied',
      receivedAt: '2 hrs ago',
    ),
  ];

  void _showAddNoteDialog(BuildContext context) {
    final noteController = TextEditingController();
    showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1A1C1F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Add Note',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: TextField(
              controller: noteController,
              autofocus: true,
              maxLines: 4,
              style: GoogleFonts.manrope(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Write your note here…',
                hintStyle: GoogleFonts.manrope(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primaryGreen),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.manrope(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () {
                  final note = noteController.text.trim();
                  if (note.isNotEmpty) controller.addSubmissionNote(note);
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.manrope(color: AppColors.primaryGreen),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inbox = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'SUBMISSION INBOX',
            title: 'Incoming visitor requirements',
            description:
                'Tap a lead to view details, update status, or add internal notes.',
          ),
          const SizedBox(height: 18),
          Obx(() {
            final subs = controller.liveSubmissions;
            if (subs.isEmpty) {
              return Column(
                children:
                    _fallbackLeads
                        .map(
                          (lead) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: LeadCard(lead: lead),
                          ),
                        )
                        .toList(),
              );
            }
            return Column(
              children:
                  subs
                      .map(
                        (sub) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Obx(() {
                            final isSelected =
                                controller.selectedSubmission.value?.id ==
                                sub.id;
                            return SubmissionCard(
                              submission: sub,
                              isSelected: isSelected,
                              onTap: () => controller.selectSubmission(sub),
                            );
                          }),
                        ),
                      )
                      .toList(),
            );
          }),
        ],
      ),
    );

    final detail = AdminSurfaceCard(
      child: Obx(() {
        final sub = controller.selectedSubmission.value;

        if (sub == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AdminSectionHeader(
                eyebrow: 'DETAIL VIEW',
                title: 'Select a submission',
                description:
                    'Tap any lead on the left to view details, update its status, or add internal notes.',
              ),
              const SizedBox(height: 24),
              Center(
                child: Icon(
                  Icons.inbox_rounded,
                  size: 48,
                  color: Colors.white12,
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionHeader(
              eyebrow: 'DETAIL VIEW',
              title: sub.name,
              description: sub.company,
            ),
            const SizedBox(height: 18),
            PreviewTile(
              title: 'Contact',
              value: sub.email,
              icon: Icons.mail_rounded,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Message',
              value: sub.message,
              icon: Icons.message_rounded,
              color: const Color(0xFF5CD6FF),
            ),
            const SizedBox(height: 12),
            PreviewTile(
              title: 'Status',
              value: sub.statusLabel,
              icon: Icons.flag_rounded,
              color: const Color(0xFFFFB44C),
            ),
            if (sub.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _NotesSection(notes: sub.notes),
            ],
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AdminPrimaryButton(
                  label: 'Mark in progress',
                  icon: Icons.done_all_rounded,
                  onPressed:
                      sub.status == SubmissionStatus.inProgress
                          ? null
                          : controller.markSubmissionInProgress,
                ),
                AdminGhostButton(
                  label: 'Add note',
                  icon: Icons.sticky_note_2_rounded,
                  onPressed: () => _showAddNoteDialog(context),
                ),
              ],
            ),
          ],
        );
      }),
    );

    if (isCompact) {
      return Column(children: [inbox, const SizedBox(height: 18), detail]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: inbox),
        const SizedBox(width: 18),
        Expanded(flex: 5, child: detail),
      ],
    );
  }
}

class SubmissionCard extends StatelessWidget {
  const SubmissionCard({
    super.key,
    required this.submission,
    required this.isSelected,
    required this.onTap,
  });

  final VisitorSubmission submission;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryGreen.withValues(alpha: 0.12)
                  : submission.isUnread
                  ? AppColors.primaryGreen.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryGreen.withValues(alpha: 0.4)
                    : submission.isUnread
                    ? AppColors.primaryGreen.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    submission.name,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (submission.isUnread)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              submission.company,
              style: GoogleFonts.manrope(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              submission.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: Colors.white70,
                fontSize: 12.5,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    submission.statusLabel,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  submission.receivedAtFormatted,
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  const LeadCard({super.key, required this.lead});

  final AdminLeadItem lead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            lead.unread
                ? AppColors.primaryGreen.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              lead.unread
                  ? AppColors.primaryGreen.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lead.name,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (lead.unread)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            lead.company,
            style: GoogleFonts.manrope(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            lead.summary,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  lead.status,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                lead.receivedAt,
                style: GoogleFonts.manrope(
                  color: Colors.white54,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notes});

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INTERNAL NOTES',
            style: GoogleFonts.manrope(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          ...notes.map(
            (note) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5, right: 8),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      note,
                      style: GoogleFonts.manrope(
                        color: Colors.white70,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
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
}
