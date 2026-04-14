// import 'package:flutter/material.dart';

// import 'package:healthcareapp_try1/Models/Posts/posts_model.dart';

// class PostCard extends StatelessWidget {
//   final PostModel post;
//   const PostCard({super.key, required this.post});

//   String _timeAgo(DateTime date) {
//     final diff = DateTime.now().difference(date);
//     if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
//     if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
//     return 'منذ ${diff.inDays} يوم';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Doctor info header
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundImage: NetworkImage(post.doctorProfilePicture),
//                   onBackgroundImageError: (_, __) {},
//                   backgroundColor: const Color(0xFFB5D4F4),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             post.doctorName,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           _DoctorBadge(),
//                         ],
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         '${post.specialtyName} · ${_timeAgo(post.date)}',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Title
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Text(
//               post.title,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 height: 1.4,
//               ),
//               textDirection: TextDirection.rtl,
//             ),
//           ),
//           const SizedBox(height: 8),

//           // Content
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Text(
//               post.content,
//               style: const TextStyle(fontSize: 13, height: 1.7),
//               textDirection: TextDirection.rtl,
//             ),
//           ),
//           const SizedBox(height: 10),

//           // Image attachment (if exists)
//           if (post.isContainsMedia && post.attachmentUrl != null)
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 bottom: Radius.circular(14),
//               ),
//               child: Image.network(
//                 post.attachmentUrl!,
//                 width: double.infinity,
//                 height: 200,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) return child;
//                   return Container(
//                     height: 200,
//                     color: const Color(0xFFF0F0F0),
//                     child: const Center(child: CircularProgressIndicator()),
//                   );
//                 },
//                 errorBuilder: (_, __, ___) => const SizedBox(),
//               ),
//             )
//           else
//             const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
// }

// class _DoctorBadge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE6F1FB),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: const Text(
//         'Doctor',
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF185FA5),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Models/Posts/posts_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor info header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    widget.post.doctorProfilePicture,
                  ),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: const Color(0xFFB5D4F4),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.post.doctorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const _DoctorBadge(),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.post.specialtyName} · ${_timeAgo(widget.post.date)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 8),

          // Content مع عرض المزيد
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textSpan = TextSpan(
                  text: widget.post.content,
                  style: const TextStyle(fontSize: 13, height: 1.7),
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
                      style: const TextStyle(fontSize: 13, height: 1.7),
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
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF185FA5),
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

          // Image attachment
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
                    color: const Color(0xFFF0F0F0),
                    child: const Center(child: CircularProgressIndicator()),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Doctor',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF185FA5),
        ),
      ),
    );
  }
}
