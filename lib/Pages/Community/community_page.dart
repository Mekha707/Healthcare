import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Models/Posts/posts_model.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _expanded = false;
  static const int _maxLines = 3;

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _primaryText => _isDark ? AppColors.textDark : Colors.grey.shade600;
  Color get _secondaryText =>
      _isDark ? AppColors.textDark.withOpacity(0.7) : Colors.grey.shade300;
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE0E0E0);
  Color get _accent => _isDark ? Colors.blue.shade200 : const Color(0xFF185FA5);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: _isDark
                ? Colors.black.withOpacity(0.16)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: widget.post.doctorProfilePicture.isNotEmpty
                      ? NetworkImage(widget.post.doctorProfilePicture)
                      : null,
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: _isDark
                      ? Colors.blue.withOpacity(0.18)
                      : const Color(0xFFB5D4F4),
                  child: widget.post.doctorProfilePicture.isEmpty
                      ? Icon(Icons.person, color: _accent, size: 22)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(
                            widget.post.doctorName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: _primaryText,
                            ),
                          ),
                          const _DoctorBadge(),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.post.specialtyName} · ${_timeAgo(widget.post.date)}',
                        style: TextStyle(fontSize: 12, color: _secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              widget.post.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.4,
                color: _primaryText,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textSpan = TextSpan(
                  text: widget.post.content,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.7,
                    color: _primaryText,
                  ),
                );

                final textPainter = TextPainter(
                  text: textSpan,
                  maxLines: _maxLines,
                  textDirection: TextDirection.rtl,
                )..layout(maxWidth: constraints.maxWidth);

                final isOverflowing = textPainter.didExceedMaxLines;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.post.content,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.7,
                        color: _primaryText,
                      ),
                      textDirection: TextDirection.rtl,
                      maxLines: _expanded ? null : _maxLines,
                      overflow: _expanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    if (isOverflowing)
                      GestureDetector(
                        onTap: () => setState(() => _expanded = !_expanded),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _expanded ? 'عرض أقل' : 'عرض المزيد',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _accent,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          if (widget.post.isContainsMedia && widget.post.attachmentUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
              child: Image.network(
                widget.post.attachmentUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 200,
                    color: _isDark
                        ? AppColors.bgDark.withOpacity(0.75)
                        : const Color(0xFFF0F0F0),
                    child: Center(
                      child: CircularProgressIndicator(color: _accent),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _DoctorBadge extends StatelessWidget {
  const _DoctorBadge();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? Colors.blue.shade200 : const Color(0xFF185FA5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.withOpacity(0.14) : const Color(0xFFE6F1FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Doctor',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: accent,
        ),
      ),
    );
  }
}
