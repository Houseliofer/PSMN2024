// Generated by https://quicktype.io

class Result {

  String? name;
  String? key;
  String? site;

  Result({

    this.name,
    this.key,
    this.site

  });
  factory Result.fromMap(Map<String,dynamic> video){
    return Result(
      name: video['name'],
      key: video['key'],
      site: video['site']

      
    );
  }
}
