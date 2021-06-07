class EmployeeModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String profileImage;
  // final Address address;
  final String phone;
  final String website;

  // final Company company;

  const EmployeeModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.profileImage,
      // required this.address,
      required this.phone,
      required this.website,
      // required this.company
      });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        profileImage: json['profile_image'] ?? "https://homepages.cae.wisc.edu/~ece533/images/cat.png",
        // address: Address.fromJson(json['address']),
        phone: json['phone'] ?? "00000",
        website: json['website'] ?? "https://images.app.goo.gl/o9Mye3Z2fR93wdzV9",
        // company: (json['company'] != null
        //     ? new Company.fromJson(json['company'])
        //     : null)!,
      );


  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'profile_image': profileImage,
        // 'address': address.toJson(),
        'phone': phone,
        'website': website,
        // 'company': company.toJson()
      };
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  Address(
      {required this.street,
      required this.suite,
      required this.city,
      required this.zipcode,
      });

  factory Address.fromJson(Map<String, dynamic> json)  => Address(
      street : json['street'],
      suite : json['suite'],
      city : json['city'],
      zipcode : json['zipcode'],
  );

  Map<String, dynamic> toJson() => {
    'street': street,
    'suite': suite,
    'city': city,
    'zipcode': zipcode,
  };
}


class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({required this.name, required this.catchPhrase, required this.bs});

  factory Company.fromJson(Map<String, dynamic> json) => Company (
      name : json['name'],
      catchPhrase : json['catchPhrase'],
      bs : json['bs']
  );


  Map<String, dynamic> toJson() => {
    'name': name,
    'catchPhrase': catchPhrase,
    'bs': bs,
  };

}
