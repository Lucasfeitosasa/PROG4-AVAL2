class ApodData {
  final String title;
  final String url;
  final String mediaType;
  final String desc;
  final String date;
  final String note;
  bool isFavorite;
  final String? copyright;

  ApodData(this.title, this.url, this.mediaType, this.desc, this.date,
      this.note, this.isFavorite, this.copyright);

  ApodData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        mediaType = json['media_type'],
        url = json['media_type'] == 'image'
            ? json['hdurl']
            : json['thumbnail_url'],
        desc = json['explanation'],
        date = json['date'],
        note = '',
        isFavorite = false,
        copyright = json['copyright'];

  get length => null;

  get explanation => null;

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
        'media_type': mediaType,
        'explanation': desc,
        'date': date,
        'copyright': copyright,
      };

  where(bool Function(dynamic apod) param0) {}
}
