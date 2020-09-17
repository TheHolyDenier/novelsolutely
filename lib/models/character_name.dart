class CharacterName {
  String name;
  String nickname;
  String surname;

  CharacterName(String fullName,
      {String startChar = '«', String endChar = '»'}) {
    if (fullName.lastIndexOf(',') != -1) {
      final List<String> surnameName = fullName.split(',');
      this.surname = surnameName[0].trim() ?? '';
      if (surnameName[1].lastIndexOf(startChar) != -1) {
        final List<String> nameNick = surnameName[1].split(startChar);
        this.name = nameNick[0].trim() ?? '';
        this.nickname = nameNick[1].replaceFirst(endChar, '').trim() ?? '';
      } else {
        this.name = surnameName[1].trim() ?? '';
      }
    } else {
      this.name = '';
      this.nickname = fullName;
      this.surname = '';
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
