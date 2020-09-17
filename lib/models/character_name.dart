class CharacterName {
  String name;
  String nickname;
  String surname;

  CharacterName(String name) {
    final List<String> surnameName = name.split(',');
    this.surname = surnameName[0].trim() ?? '';
    if (surnameName[1].lastIndexOf('«') != -1) {
      final List<String> nameNick = surnameName[1].split('«');
      this.name = nameNick[0].trim() ?? '';
      this.nickname = nameNick[1].replaceFirst('»', '').trim() ?? '';
    } else {
      this.name = surnameName[1].trim() ?? '';
    }
  }

  static String readableName(String registerName) {
    return CharacterName(registerName).toString();
  }

  String registerName() {
    return '$surname, $name ${nickname.isNotEmpty ? "«$nickname»" : ""}';
  }

  @override
  String toString() {
    return '$name ${nickname ?? ''} $surname'.trim();
  }
}
