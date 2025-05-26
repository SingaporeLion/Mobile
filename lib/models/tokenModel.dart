class Token {
  num? decimals;
  num? balance;
  num? price;
  num? balanceInUSD;
  num? priceChange;
  num? totalSupply;
  num? circulatingSupply;
  num? marketCapRank;
  num? marketCap;
  num? totalVolume;
  String? name;
  String? uri;
  String? symbol;
  String? tokenAddress;
  String? coinGeckoID;
  String? twitterName;
  String? officialLink;
  String? facebookName;
  String? telegramChannelIdentifier;
  String? whitePaperUrl;
  String? sourceCode;
  String? explorer;
  var description;

  Token(
      {this.decimals,
        this.balance,
        this.price,
        this.balanceInUSD,
        this.priceChange,
        this.circulatingSupply,
        this.totalSupply,
        this.marketCapRank,
        this.marketCap,
        this.totalVolume,
        this.name,
        this.uri,
        this.symbol,
        this.coinGeckoID,
        this.description,
        this.twitterName,
        this.officialLink,
        this.facebookName,
        this.telegramChannelIdentifier,
        this.whitePaperUrl,
        this.sourceCode,
        this.explorer,
        this.tokenAddress
      });

  Token.fromJson(Map<String, dynamic> json) {
    decimals = json['decimals'];
    balance = json['balance'];
    balanceInUSD = json['balanceInUSD'];
    price = json['price'];
    priceChange = json['priceChange'];
    totalSupply = json['totalSupply'];
    circulatingSupply = json['circulatingSupply'];
    marketCapRank = json['marketCapRank'];
    marketCap = json['marketCap'];
    totalVolume = json['totalVolume'];
    name = json['name'];
    uri = json['uri'];
    symbol = json['symbol'];
    tokenAddress = json['tokenAddress'];
    coinGeckoID = json['coinGeckoID'];
    description = json['description'];
    twitterName = json['twitterName'];
    officialLink = json['officialLink'];
    facebookName = json['facebookName'];
    whitePaperUrl = json['whitePaperUrl'];
    sourceCode = json['sourceCode'];
    explorer = json['explorer'];
    telegramChannelIdentifier = json['telegramChannelIdentifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['decimals'] = this.decimals;
    data['balance'] = this.balance;
    data['balanceInUSD'] = this.balanceInUSD;
    data['name'] = this.name;
    data['coinGeckoID'] = this.coinGeckoID;
    data['description'] = this.description;
    data['price'] = this.price;
    data['priceChange'] = this.priceChange;
    data['circulatingSupply'] = this.circulatingSupply;
    data['totalSupply'] = this.totalSupply;
    data['marketCapRank'] = this.marketCapRank;
    data['marketCap'] = this.marketCap;
    data['totalVolume'] = this.totalVolume;
    data['uri'] = this.uri;
    data['symbol'] = this.symbol;
    data['tokenAddress'] = this.tokenAddress;
    data['twitterName'] = this.twitterName;
    data['officialLink'] = this.officialLink;
    data['facebookName'] = this.facebookName;
    data['whitePaperUrl'] = this.whitePaperUrl;
    data['sourceCode'] = this.sourceCode;
    data['telegramChannelIdentifier'] = this.telegramChannelIdentifier;
    data['explorer'] = this.explorer;
    return data;
  }
}