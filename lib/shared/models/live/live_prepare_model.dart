class LivePrepareModel {
  final int? liveId;
  final String title;
  final String description;
  final String? pushUrl;

  LivePrepareModel({this.liveId, this.title = '', this.description = '', this.pushUrl});

  factory LivePrepareModel.fromJson(Map<String, dynamic> json) {
    return LivePrepareModel(
      liveId: json['liveId'] != null ? (json['liveId'] as num).toInt() : null,
      title: json['title'] as String? ?? '静心修行直播',
      description: json['description'] as String? ?? '',
      pushUrl: json['pushUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (liveId != null) 'liveId': liveId,
      'title': title,
      'description': description,
      if (pushUrl != null) 'pushUrl': pushUrl,
    };
  }
}
