class WorkBookParamsModel {
  String userChildId, workShopId;
  String? lastWorkShopId, lastAgeDomain;

  WorkBookParamsModel(
      {this.userChildId = '',
      this.workShopId = '',
      this.lastWorkShopId,
      this.lastAgeDomain});

  Map<String, String> toJson() => {
        'userChildId': userChildId,
        'workShopId': workShopId,
        'lastWorkShopId': lastWorkShopId ?? 'null',
        'lastAgeDomain': lastAgeDomain ?? 'null',
      };
}
