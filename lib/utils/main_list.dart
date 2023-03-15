class MainList {
  final String name;
  var image;
  final String description;
  final String price;
  final String fullName;
  final String street;
  final String city;
  late bool isFav;

  MainList(
      {required this.name,
        required this.description,
        required this.image,
        required this.fullName,
        required this.price,
        required this.street,
        required this.city,
        required this.isFav
      });
}