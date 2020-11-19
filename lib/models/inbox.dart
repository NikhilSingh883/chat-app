class Inbox {
  String name;
  String username;
  String url;
  String email;
  String roomId;

  String get get_name {
    return name;
  }

  String get get_username {
    return username;
  }

  String get get_url {
    return url;
  }

  String get get_email {
    return email;
  }

  set set_name(String currentYear) {
    name = name;
  }

  set set_username(String username) {
    username = username;
  }

  set set_url(String url) {
    url = url;
  }

  set set_email(String email) {
    email = email;
  }

  Inbox({
    this.name,
    this.email,
    this.url,
    this.username,
    this.roomId,
  });
}
