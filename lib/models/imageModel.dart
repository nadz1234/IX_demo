class ImageModel {
  String image_url;
  String likes;
  String id;
  String views;

  ImageModel(this.image_url, this.likes, this.views);

  ImageModel.fromMap(Map<String, dynamic> data, String id)
      : id = id,
        image_url = data['image_url'],
        likes = data['likes'],
        views = data['views'];

  Map<String, dynamic> toMap() {
    return {"image_url": image_url, "likes": likes, "views": views};
  }
}
