class Todo {
  int? _id;
  String _title = '';
  String? _description;
  String _date = '';
  int _priority = 3;

  Todo (this._title, this._date, this._priority, [this._description]);
  Todo.withId (this._id, this._title, this._date, this._priority, [this._description]);

  Todo.fromObject(dynamic o){
    this._id = o["id"];
    this._description = o["description"];
    this._title = o["title"];
    this._date = o["date"];
    this._priority = o["priority"];
  }

  int? get id => _id;

  String get title => _title;
  set title(String newTitle) {
    if(newTitle.length <= 255){
      _title = newTitle;
    }
  }

  int get priority => _priority;
  set priority(int newPriority) {
    if(newPriority >0 && newPriority <=3){
      _priority = newPriority;
    }
  }

  String get date => _date;
  set date(String newDate) {
    _date = newDate;
  }

  String? get description => _description;

  set description(String? newDescription) {
    if(newDescription!.length <=255) {
      _description = newDescription;
    }
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["description"] = _description;
    map["date"] = _date;
    map["priority"] = _priority;

    if (id != null){
      map["id"] = _id;
    }

    return map;
  }

}