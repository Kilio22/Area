class AreaAction {
  final String service;
  final String name;
  final Map<String, dynamic> data;

  AreaAction(this.service, this.name, this.data);

  AreaAction.fromJson(Map<String, dynamic> json)
      : service = json['service'],
        name = json['name'],
        data = json['data'];

  Map<String, dynamic> toJson() => {'service': service, 'name': name, 'data': data};
}

class AreaReaction {
  final String service;
  final String name;
  final Map<String, dynamic> data;

  AreaReaction(this.service, this.name, this.data);

  AreaReaction.fromJson(Map<String, dynamic> json)
      : service = json['service'],
        name = json['name'],
        data = json['data'];

  Map<String, dynamic> toJson() => {'service': service, 'name': name, 'data': data};
}

class Area {
  final String id;
  final AreaAction action;
  final AreaReaction reaction;

  Area(this.id, this.action, this.reaction);

  Area.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        action = AreaAction.fromJson(json['action']),
        reaction = AreaReaction.fromJson(json['reaction']);

  Map<String, dynamic> toJson() => {
        'action': action.toJson(),
        'reaction': reaction.toJson(),
      };
}
