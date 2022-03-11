// high price, low price, openning rate, closing rate, volume
class BTC {
  final int id;
  final String currencySort;
  final double currentRate;
  final int currentDate;
  final String currencyName;
  final String highPrice;
  final String lowPrice;
  final String openingRate;
  final String closingRate;
  final String volume;

  BTC({
    required this.id,
    required this.currencyName,
    required this.currencySort,
    required this.currentRate,
    required this.currentDate,
    required this.highPrice,
    required this.lowPrice,
    required this.openingRate,
    required this.closingRate,
    required this.volume,
  });

  //from Json
  factory BTC.fromJson(Map<String, dynamic> data) => BTC(
        id: data["id"],
        currencyName: data["currency_name"] ?? "",
        currencySort: data["currency_sort"] ?? "",
        currentRate: double.parse(data["cur_rate"].toString()),
        currentDate: data["curr_json"]["LASTUPDATE"],
        highPrice: data["curr_json"]["HIGH24HOUR"].toString(),
        lowPrice: data["curr_json"]["LOW24HOUR"].toString(),
        openingRate: data["curr_json"]["OPENDAY"].toString(),
        closingRate: data["curr_json"]["HIGHDAY"].toString(),
        volume: data["curr_json"]["VOLUMEDAYTO"].toString(),
      );
}

    // "curr_json": {
    //             "TYPE": "5",
    //             "MARKET": "CCCAGG",
    //             "FROMSYMBOL": "BTC",
    //             "TOSYMBOL": "INR",
    //             "FLAGS": "1026",
    //             "PRICE": 3183998.23,
    //             "LASTUPDATE": 1646731670,
    //             "MEDIAN": 3183998.23,
    //             "LASTVOLUME": 0.00298367,
    //             "LASTVOLUMETO": 9499.999998904099,
    //             "LASTTRADEID": "55350375",
    //             "VOLUMEDAY": 0.8772209400000004,
    //             "VOLUMEDAYTO": 2729388.6595593006,
    //             "VOLUME24HOUR": 2.47931557,
    //             "VOLUME24HOURTO": 7803821.05989129,
    //             "OPENDAY": 2969620.69,
    //             "HIGHDAY": 3376420.21,
    //             "LOWDAY": 2430015.55,
    //             "OPEN24HOUR": 3030699.39,
    //             "HIGH24HOUR": 7500000,
    //             "LOW24HOUR": 2430015.55,
    //             "LASTMARKET": "LocalBitcoins",
    //             "VOLUMEHOUR": 0.20008707999999994,
    //             "VOLUMEHOURTO": 629901.5699056473,
    //             "OPENHOUR": 3040999.98,
    //             "HIGHHOUR": 3296861.8,
    //             "LOWHOUR": 3040999.98,
    //             "TOPTIERVOLUME24HOUR": 0,
    //             "TOPTIERVOLUME24HOURTO": 0,
    //             "CHANGE24HOUR": 153298.83999999985,
    //             "CHANGEPCT24HOUR": 5.058200114000744,
    //             "CHANGEDAY": 214377.54000000004,
    //             "CHANGEPCTDAY": 7.219020958531915,
    //             "CHANGEHOUR": 142998.25,
    //             "CHANGEPCTHOUR": 4.702343010209424,
    //             "CONVERSIONTYPE": "direct",
    //             "CONVERSIONSYMBOL": "",
    //             "SUPPLY": 18977412,
    //             "MKTCAP": 60424046217980.76,
    //             "MKTCAPPENALTY": 0,
    //             "CIRCULATINGSUPPLY": 18977412,
    //             "CIRCULATINGSUPPLYMKTCAP": 60424046217980.76,
    //             "TOTALVOLUME24H": 240864.5706719392,
    //             "TOTALVOLUME24HTO": 766912276373.8378,
    //             "TOTALTOPTIERVOLUME24H": 240562.751361065,
    //             "TOTALTOPTIERVOLUME24HTO": 765951374537.561,
    //             "IMAGEURL": "/media/37746251/btc.png"
    //         }
