class NftModel {
  String? jsonrpc;
  int? id;
  Result? result;

  NftModel({this.jsonrpc, this.id, this.result});

  NftModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? owner;
  List<Assets>? assets;
  int? totalPages;
  int? pageNumber;
  int? totalItems;

  Result({this.owner, this.assets, this.totalPages, this.pageNumber, this.totalItems});

  Result.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    if (json['assets'] != null) {
      assets = <Assets>[];
      json['assets'].forEach((v) {
        assets!.add(new Assets.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    pageNumber = json['pageNumber'];
    totalItems = json['totalItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    if (this.assets != null) {
      data['assets'] = this.assets!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['pageNumber'] = this.pageNumber;
    data['totalItems'] = this.totalItems;
    return data;
  }
}

class Assets {
  String? name;
  String? collectionName;
  String? tokenAddress;
  String? collectionAddress;
  String? imageUrl;
  List<Traits>? traits;
  String? chain;
  List<Creators>? creators;
  String? network;
  String? description;
  String? symbol;
  String? externalUrl;
  List<Provenance>? provenance;

  Assets(
      {this.name,
      this.collectionName,
      this.tokenAddress,
      this.collectionAddress,
      this.imageUrl,
      this.traits,
      this.chain,
      this.creators,
      this.network,
      this.description,
      this.symbol,
      this.externalUrl,
      this.provenance});

  Assets.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    collectionName = json['collectionName'];
    tokenAddress = json['tokenAddress'];
    collectionAddress = json['collectionAddress'];
    imageUrl = json['imageUrl'];
    if (json['traits'] != null) {
      traits = <Traits>[];
      json['traits'].forEach((v) {
        traits!.add(new Traits.fromJson(v));
      });
    }
    chain = json['chain'];
    if (json['creators'] != null) {
      creators = <Creators>[];
      json['creators'].forEach((v) {
        creators!.add(new Creators.fromJson(v));
      });
    }
    network = json['network'];
    description = json['description'];
    symbol = json['symbol'];
    externalUrl = json['external_url'];
    if (json['provenance'] != null) {
      provenance = <Provenance>[];
      json['provenance'].forEach((v) {
        provenance!.add(new Provenance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['collectionName'] = this.collectionName;
    data['tokenAddress'] = this.tokenAddress;
    data['collectionAddress'] = this.collectionAddress;
    data['imageUrl'] = this.imageUrl;
    if (this.traits != null) {
      data['traits'] = this.traits!.map((v) => v.toJson()).toList();
    }
    data['chain'] = this.chain;
    if (this.creators != null) {
      data['creators'] = this.creators!.map((v) => v.toJson()).toList();
    }
    data['network'] = this.network;
    data['description'] = this.description;
    data['symbol'] = this.symbol;
    data['external_url'] = this.externalUrl;
    if (this.provenance != null) {
      data['provenance'] = this.provenance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Traits {
  String? traitType;
  String? value;
  int? traitCount;

  Traits({this.traitType, this.value, this.traitCount});

  Traits.fromJson(Map<String, dynamic> json) {
    traitType = json['trait_type'];
    value = json['value'];
    traitCount = json['trait_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trait_type'] = this.traitType;
    data['value'] = this.value;
    data['trait_count'] = this.traitCount;
    return data;
  }
}

class Creators {
  String? address;
  int? verified;
  int? share;

  Creators({this.address, this.verified, this.share});

  Creators.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    verified = json['verified'];
    share = json['share'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['verified'] = this.verified;
    data['share'] = this.share;
    return data;
  }
}

class Provenance {
  String? txHash;
  int? blockNumber;
  String? date;

  Provenance({this.txHash, this.blockNumber, this.date});

  Provenance.fromJson(Map<String, dynamic> json) {
    txHash = json['txHash'];
    blockNumber = json['blockNumber'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txHash'] = this.txHash;
    data['blockNumber'] = this.blockNumber;
    data['date'] = this.date;
    return data;
  }
}
