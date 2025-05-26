class TransactionsModel {
  String? jsonrpc;
  String? txHash;
  Result? result;
  num? id;

  TransactionsModel({this.jsonrpc, this.result, this.id});

  TransactionsModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    txHash = json['txHash'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['txHash'] = this.txHash;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Result {
  num? blockTime;
  Meta? meta;
  num? slot;
  Transaction? transaction;

  Result({this.blockTime,  this.slot, this.transaction});

  Result.fromJson(Map<String, dynamic> json) {
    blockTime = json['blockTime'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    slot = json['slot'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockTime'] = this.blockTime;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['slot'] = this.slot;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class Meta {
  num? computeUnitsConsumed;
  num? fee;
  List<InnerInstructions>? innerInstructions;
  List<String>? logMessages;
  List<int>? postBalances;
  List<PostTokenBalances>? postTokenBalances;
  List<int>? preBalances;
  List<PostTokenBalances>? preTokenBalances;
  List<Null>? rewards;
  Status? status;

  Meta(
      {this.computeUnitsConsumed,
        this.fee,
        this.innerInstructions,
        this.logMessages,
        this.postBalances,
        this.postTokenBalances,
        this.preBalances,
        this.preTokenBalances,
        this.rewards,
        this.status});

  Meta.fromJson(Map<String, dynamic> json) {
    computeUnitsConsumed = json['computeUnitsConsumed'];
    fee = json['fee'];
    if (json['innerInstructions'] != null) {
      innerInstructions = <InnerInstructions>[];
      json['innerInstructions'].forEach((v) {
        innerInstructions!.add(new InnerInstructions.fromJson(v));
      });
    }

    logMessages = json['logMessages'].cast<String>();
    postBalances = json['postBalances'].cast<int>();
    if (json['postTokenBalances'] != null) {
      postTokenBalances = <PostTokenBalances>[];
      json['postTokenBalances'].forEach((v) {
        postTokenBalances!.add(new PostTokenBalances.fromJson(v));
      });
    }
    preBalances = json['preBalances'].cast<int>();
    if (json['preTokenBalances'] != null) {
      preTokenBalances = <PostTokenBalances>[];
      json['preTokenBalances'].forEach((v) {
        preTokenBalances!.add(new PostTokenBalances.fromJson(v));
      });
    }
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['computeUnitsConsumed'] = this.computeUnitsConsumed;
    data['fee'] = this.fee;
    if (this.innerInstructions != null) {
      data['innerInstructions'] =
          this.innerInstructions!.map((v) => v.toJson()).toList();
    }
    data['logMessages'] = this.logMessages;
    data['postBalances'] = this.postBalances;
    if (this.postTokenBalances != null) {
      data['postTokenBalances'] =
          this.postTokenBalances!.map((v) => v.toJson()).toList();
    }
    data['preBalances'] = this.preBalances;
    if (this.preTokenBalances != null) {
      data['preTokenBalances'] =
          this.preTokenBalances!.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}



class Instructions {
  Parsed? parsed;
  String? program;
  String? programId;
  int? stackHeight;

  Instructions({this.parsed, this.program, this.programId, this.stackHeight});

  Instructions.fromJson(Map<String, dynamic> json) {
    parsed =
    json['parsed'] != null ? new Parsed.fromJson(json['parsed']) : null;
    program = json['program'];
    programId = json['programId'];
    stackHeight = json['stackHeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parsed != null) {
      data['parsed'] = this.parsed!.toJson();
    }
    data['program'] = this.program;
    data['programId'] = this.programId;
    data['stackHeight'] = this.stackHeight;
    return data;
  }
}


class PostTokenBalances {
  int? accountIndex;
  String? mint;
  String? owner;
  String? programId;
  UiTokenAmount? uiTokenAmount;

  PostTokenBalances(
      {this.accountIndex,
        this.mint,
        this.owner,
        this.programId,
        this.uiTokenAmount});

  PostTokenBalances.fromJson(Map<String, dynamic> json) {
    accountIndex = json['accountIndex'];
    mint = json['mint'];
    owner = json['owner'];
    programId = json['programId'];
    uiTokenAmount = json['uiTokenAmount'] != null
        ? new UiTokenAmount.fromJson(json['uiTokenAmount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountIndex'] = this.accountIndex;
    data['mint'] = this.mint;
    data['owner'] = this.owner;
    data['programId'] = this.programId;
    if (this.uiTokenAmount != null) {
      data['uiTokenAmount'] = this.uiTokenAmount!.toJson();
    }
    return data;
  }
}

class UiTokenAmount {
  String? amount;
  num? decimals;
  num? uiAmount;
  String? uiAmountString;

  UiTokenAmount(
      {this.amount, this.decimals, this.uiAmount, this.uiAmountString});

  UiTokenAmount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    decimals = json['decimals'];
    uiAmount = json['uiAmount'];
    uiAmountString = json['uiAmountString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['decimals'] = this.decimals;
    data['uiAmount'] = this.uiAmount;
    data['uiAmountString'] = this.uiAmountString;
    return data;
  }
}

class Status {
  Null? ok;

  Status({this.ok});

  Status.fromJson(Map<String, dynamic> json) {
    ok = json['Ok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Ok'] = this.ok;
    return data;
  }
}

class Transaction {
  Message? message;
  List<String>? signatures;

  Transaction({this.message, this.signatures});

  Transaction.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    signatures = json['signatures'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['signatures'] = this.signatures;
    return data;
  }
}


class Header {
  num? numReadonlySignedAccounts;
  num? numReadonlyUnsignedAccounts;
  num? numRequiredSignatures;

  Header(
      {this.numReadonlySignedAccounts,
        this.numReadonlyUnsignedAccounts,
        this.numRequiredSignatures});

  Header.fromJson(Map<String, dynamic> json) {
    numReadonlySignedAccounts = json['numReadonlySignedAccounts'];
    numReadonlyUnsignedAccounts = json['numReadonlyUnsignedAccounts'];
    numRequiredSignatures = json['numRequiredSignatures'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numReadonlySignedAccounts'] = this.numReadonlySignedAccounts;
    data['numReadonlyUnsignedAccounts'] = this.numReadonlyUnsignedAccounts;
    data['numRequiredSignatures'] = this.numRequiredSignatures;
    return data;
  }
}


class SolanaNotificationModel {
  int? blockTime;
  Meta? meta;
  int? slot;
  Transaction? transaction;

  SolanaNotificationModel(
      {this.blockTime,  this.slot, this.transaction,});

  SolanaNotificationModel.fromJson(Map<String, dynamic> json) {
    blockTime = json['blockTime'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    slot = json['slot'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockTime'] = this.blockTime;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['slot'] = this.slot;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}



class InnerInstructions {
  int? index;
  List<Instructions>? instructions;

  InnerInstructions({this.index, this.instructions});

  InnerInstructions.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    if (json['instructions'] != null) {
      instructions = <Instructions>[];
      json['instructions'].forEach((v) {
        instructions!.add(new Instructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class Parsed {
  Info? info;
  String? type;

  Parsed({this.info, this.type});

  Parsed.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}











class Message {
  List<AccountKeys>? accountKeys;
  List<Instructions>? instructions;
  String? recentBlockhash;

  Message({this.accountKeys, this.instructions, this.recentBlockhash});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['accountKeys'] != null) {
      accountKeys = <AccountKeys>[];
      json['accountKeys'].forEach((v) {
        accountKeys!.add(new AccountKeys.fromJson(v));
      });
    }
    if (json['instructions'] != null) {
      instructions = <Instructions>[];
      json['instructions'].forEach((v) {
        instructions!.add(new Instructions.fromJson(v));
      });
    }
    recentBlockhash = json['recentBlockhash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accountKeys != null) {
      data['accountKeys'] = this.accountKeys!.map((v) => v.toJson()).toList();
    }
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.map((v) => v.toJson()).toList();
    }
    data['recentBlockhash'] = this.recentBlockhash;
    return data;
  }
}

class AccountKeys {
  String? pubkey;
  bool? signer;
  String? source;
  bool? writable;

  AccountKeys({this.pubkey, this.signer, this.source, this.writable});

  AccountKeys.fromJson(Map<String, dynamic> json) {
    pubkey = json['pubkey'];
    signer = json['signer'];
    source = json['source'];
    writable = json['writable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pubkey'] = this.pubkey;
    data['signer'] = this.signer;
    data['source'] = this.source;
    data['writable'] = this.writable;
    return data;
  }
}


class Info {
  String? destination;
  String? mint;
  String? multisigAuthority;
  int? lamports;
  String? source;
  TokenAmount? tokenAmount;

  Info(
      {this.destination,
        this.mint,
        this.multisigAuthority,
        this.lamports,
        this.source,
        this.tokenAmount});

  Info.fromJson(Map<String, dynamic> json) {
    destination = json['destination'];
    mint = json['mint'];
    multisigAuthority = json['multisigAuthority'];
    lamports = json['lamports'];
    source = json['source'];
    tokenAmount = json['tokenAmount'] != null
        ? new TokenAmount.fromJson(json['tokenAmount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['destination'] = this.destination;
    data['mint'] = this.mint;
    data['multisigAuthority'] = this.multisigAuthority;
    data['lamports'] = this.lamports;
    data['source'] = this.source;
    if (this.tokenAmount != null) {
      data['tokenAmount'] = this.tokenAmount!.toJson();
    }
    return data;
  }
}
class TokenAmount {
  String? amount;
  int? decimals;
  num? uiAmount;
  String? uiAmountString;

  TokenAmount({this.amount, this.decimals, this.uiAmount, this.uiAmountString});

  TokenAmount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    decimals = json['decimals'];
    uiAmount = json['uiAmount'];
    uiAmountString = json['uiAmountString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['decimals'] = this.decimals;
    data['uiAmount'] = this.uiAmount;
    data['uiAmountString'] = this.uiAmountString;
    return data;
  }
}