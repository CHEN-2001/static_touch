class VipStatusModel {
  final bool isVip;
  final String expireDate;

  VipStatusModel({required this.isVip, required this.expireDate});
}

class VipPlanModel {
  final String id;
  final String title;
  final String price;
  final String originalPrice;
  final String description;

  VipPlanModel({
    required this.id,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.description,
  });
}
