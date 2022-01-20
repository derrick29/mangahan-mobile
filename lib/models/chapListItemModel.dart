class ChapListAttr {
  String href;
  
  ChapListAttr(this.href);

  factory ChapListAttr.fromJson(dynamic json) {
    return ChapListAttr(json['href']);
  }
}

class ChapListAttrDl {
  String href;
  ChapListImgs imgUrls;

  ChapListAttrDl(this.href, this.imgUrls);

  factory ChapListAttrDl.fromJson(dynamic json) {
    return ChapListAttrDl(json['href'], ChapListImgs.fromJson(json));
  }
}

class ChapListImgs {
  List<dynamic> imgUrls;

  ChapListImgs(this.imgUrls);

  factory ChapListImgs.fromJson(dynamic json) {
    return ChapListImgs(json['imgUrls']);
  }
}

class ChapListItem {
  String title;
  ChapListAttr attributes;

  ChapListItem(this.title, this.attributes);

  factory ChapListItem.fromJson(dynamic json) {
    return ChapListItem(json['title'] as String, ChapListAttr.fromJson(json['attributes']));
  }
}

class ChapListItemDl {
  String title;
  ChapListAttrDl attributes;

  ChapListItemDl(this.title, this.attributes);

  factory ChapListItemDl.fromJson(dynamic json) {
    return ChapListItemDl(json['title'] as String, ChapListAttrDl.fromJson(json['attributes']));
  }
}