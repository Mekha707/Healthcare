class PostModel {
  final String id;
  final String title;
  final String content;
  final String? attachmentUrl;
  final bool isPublished;
  final bool isContainsMedia;
  final String doctorId;
  final String doctorName;
  final String doctorProfilePicture;
  final String specialtyId;
  final String specialtyName;
  final DateTime date;

  const PostModel({
    required this.id,
    required this.title,
    required this.content,
    this.attachmentUrl,
    required this.isPublished,
    required this.isContainsMedia,
    required this.doctorId,
    required this.doctorName,
    required this.doctorProfilePicture,
    required this.specialtyId,
    required this.specialtyName,
    required this.date,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      attachmentUrl: json['attachmentUrl'],
      isPublished: json['isPublished'],
      isContainsMedia: json['isContainsMedia'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorProfilePicture: json['doctorProfilePicture'],
      specialtyId: json['specialtyId'],
      specialtyName: json['specialtyName'],
      date: DateTime.parse(json['date']),
    );
  }
}
