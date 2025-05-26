class NewNftModel {
  String? name;
  String? symbol;
  num? royalty;
  String? imageUri;
  String? cachedImageUri;
  String? animationUrl;
  String? cachedAnimationUrl;
  String? metadataUri;
  String? description;
  String? mint;
  String? owner;
  String? updateAuthority;
  List<Creators>? creators;
  Attributes? attributes;
  List<AttributesArray>? attributesArray;
  List<Files>? files;
  String? externalUrl;
  bool? primarySaleHappened;
  bool? isMutable;
  String? tokenStandard;
  bool? isLoadedMetadata;
  bool? isCompressed;
  String? merkleTree;
  bool? isBurnt;

  NewNftModel(
      {this.name,
        this.symbol,
        this.royalty,
        this.imageUri,
        this.cachedImageUri,
        this.animationUrl,
        this.cachedAnimationUrl,
        this.metadataUri,
        this.description,
        this.mint,
        this.owner,
        this.updateAuthority,
        this.creators,
        this.attributes,
        this.attributesArray,
        this.files,
        this.externalUrl,
        this.primarySaleHappened,
        this.isMutable,
        this.tokenStandard,
        this.isLoadedMetadata,
        this.isCompressed,
        this.merkleTree,
        this.isBurnt});

  NewNftModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
    royalty = json['royalty'];
    imageUri = json['image_uri'];
    cachedImageUri = json['cached_image_uri'];
    animationUrl = json['animation_url'];
    cachedAnimationUrl = json['cached_animation_url'];
    metadataUri = json['metadata_uri'];
    description = json['description'];
    mint = json['mint'];
    owner = json['owner'];
    updateAuthority = json['update_authority'];
    if (json['creators'] != null) {
      creators = <Creators>[];
      json['creators'].forEach((v) {
        creators!.add(new Creators.fromJson(v));
      });
    }
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    if (json['attributes_array'] != null) {
      attributesArray = <AttributesArray>[];
      json['attributes_array'].forEach((v) {
        attributesArray!.add(new AttributesArray.fromJson(v));
      });
    }
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    externalUrl = json['external_url'];
    primarySaleHappened = json['primary_sale_happened'];
    isMutable = json['is_mutable'];
    tokenStandard = json['token_standard'];
    isLoadedMetadata = json['is_loaded_metadata'];
    isCompressed = json['is_compressed'];
    merkleTree = json['merkle_tree'];
    isBurnt = json['is_burnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['royalty'] = this.royalty;
    data['image_uri'] = this.imageUri;
    data['cached_image_uri'] = this.cachedImageUri;
    data['animation_url'] = this.animationUrl;
    data['cached_animation_url'] = this.cachedAnimationUrl;
    data['metadata_uri'] = this.metadataUri;
    data['description'] = this.description;
    data['mint'] = this.mint;
    data['owner'] = this.owner;
    data['update_authority'] = this.updateAuthority;
    if (this.creators != null) {
      data['creators'] = this.creators!.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    if (this.attributesArray != null) {
      data['attributes_array'] =
          this.attributesArray!.map((v) => v.toJson()).toList();
    }
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    data['external_url'] = this.externalUrl;
    data['primary_sale_happened'] = this.primarySaleHappened;
    data['is_mutable'] = this.isMutable;
    data['token_standard'] = this.tokenStandard;
    data['is_loaded_metadata'] = this.isLoadedMetadata;
    data['is_compressed'] = this.isCompressed;
    data['merkle_tree'] = this.merkleTree;
    data['is_burnt'] = this.isBurnt;
    return data;
  }
}

class Creators {
  String? address;
  num? share;
  bool? verified;

  Creators({this.address, this.share, this.verified});

  Creators.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    share = json['share'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['share'] = this.share;
    data['verified'] = this.verified;
    return data;
  }
}

class Attributes {
  String? colorVariants;

  Attributes({this.colorVariants});

  Attributes.fromJson(Map<String, dynamic> json) {
    colorVariants = json['Color Variants'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Color Variants'] = this.colorVariants;
    return data;
  }
}

class AttributesArray {
  String? traitType;
  String? value;

  AttributesArray({this.traitType, this.value});

  AttributesArray.fromJson(Map<String, dynamic> json) {
    traitType = json['trait_type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trait_type'] = this.traitType;
    data['value'] = this.value;
    return data;
  }
}

class Files {
  String? uri;
  String? type;

  Files({this.uri, this.type});

  Files.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    data['type'] = this.type;
    return data;
  }
}