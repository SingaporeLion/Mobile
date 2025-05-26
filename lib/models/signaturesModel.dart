class SignaturesModel {
  String? jsonrpc;
  List<Result>? result;
  int? id;

  SignaturesModel({this.jsonrpc, this.result, this.id});

  SignaturesModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Result {
  String? signature;
  int? slot;
  num? blockTime;

  Result({ this.signature, this.slot, this.blockTime});

  Result.fromJson(Map<String, dynamic> json) {
    signature = json['signature'];
    slot = json['slot'];
    blockTime = json['blockTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['signature'] = this.signature;
    data['slot'] = this.slot;
    data['blockTime'] = this.blockTime;
    return data;
  }
}