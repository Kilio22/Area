class User {
  final String id;
  String displayName = "";
  String email = "";
  final List<String> servicesConnectInformation;
  final bool isMicrosoftAuth;

  User(this.id, this.displayName, this.email, this.servicesConnectInformation, this.isMicrosoftAuth);

  User.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.displayName = json['displayName'],
        this.email = json['email'],
        this.servicesConnectInformation = (json['services'] as List)?.map((i) => i.toString())?.toList() ?? [],
        this.isMicrosoftAuth = json['isMicrosoftAuthed'];
}
