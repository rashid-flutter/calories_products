class ProductModel {
  List<Categories>? categories;

  ProductModel({this.categories});

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  List<Dishes>? dishes;

  Categories({this.id, this.name, this.dishes});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['dishes'] != null) {
      dishes = <Dishes>[];
      json['dishes'].forEach((v) {
        dishes!.add(Dishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    if (dishes != null) {
      data['dishes'] = dishes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dishes {
  int? id;
  String? name;
  String? price;
  String? currency;
  int? calories;
  String? description;
  List<Addons>? addons;
  String? imageUrl;
  bool? customizationsAvailable;

  Dishes(
      {this.id,
      this.name,
      this.price,
      this.currency,
      this.calories,
      this.description,
      this.addons,
      this.imageUrl,
      this.customizationsAvailable});

  Dishes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    currency = json['currency'];
    calories = json['calories'];
    description = json['description'];
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
    imageUrl = json['image_url'];
    customizationsAvailable = json['customizations_available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['currency'] = currency;
    data['calories'] = calories;
    data['description'] = description;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    data['image_url'] = imageUrl;
    data['customizations_available'] = customizationsAvailable;
    return data;
  }
}

class Addons {
  int? id;
  String? name;
  String? price;

  Addons({this.id, this.name, this.price});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
