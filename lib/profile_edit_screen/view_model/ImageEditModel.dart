class ImageEditModel {
  String? message;
  List<AllImages>? allImages;

  ImageEditModel({this.message, this.allImages});

  ImageEditModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['all_images'] != null) {
      allImages = <AllImages>[];
      json['all_images'].forEach((v) {
        allImages!.add(new AllImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.allImages != null) {
      data['all_images'] = this.allImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllImages {
  int? id;
  int? profileId;
  String? imageName;
  int? isDefault;
  String? createdAt;
  String? updatedAt;

  AllImages(
      {this.id,
        this.profileId,
        this.imageName,
        this.isDefault,
        this.createdAt,
        this.updatedAt});

  AllImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profile_id'];
    imageName = json['image_name'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_id'] = this.profileId;
    data['image_name'] = this.imageName;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
