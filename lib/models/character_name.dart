class CharacterName {
  String name;
  String nickname;
  String surname;

  CharacterName(String fullName,
      {String startChar = '«', String endChar = '»'}) {
    fullName = fullName.replaceAll('?', '');
    if (fullName.lastIndexOf(',') != -1) {
      final List<String> surnameName = fullName.split(',');
      this.surname = surnameName[0].trim() ?? '';
      final List<String> nameNick = surnameName[1].split(startChar);
      switch (nameNick.length) {
        case 1:
          if (nameNick[0].lastIndexOf(startChar) == -1) {
            this.nickname = '';
            this.name = nameNick[0].trim();
          } else {
            this.name = '';
            this.nickname = nameNick[0].trim();
          }
          break;
        default:
          this.name = nameNick[0].trim() ?? '';
          this.nickname = nameNick[1].replaceFirst(endChar, '').trim() ?? '';
          break;
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

  static CharacterName fromInputs(
      {String name, String surname, String nickname}) {
    nickname = nickname.replaceAll('«', '');
    nickname = nickname.replaceAll('»', '');
    print('tmp ---------> $surname, $name ${nickname != null && nickname.isNotEmpty ? "«$nickname»" : ""}');
    return CharacterName(
        '$surname, $name ${nickname != null && nickname.isNotEmpty ? "«$nickname»" : ""}');
  }

  String registerName() {
    return '$surname, $name ${nickname != null && nickname.isNotEmpty ? "«$nickname»" : ""}';
  }

  @override
  String toString() {
    if (nickname.isEmpty) return '$name $surname'.trim();
    return '$name «$nickname» $surname'.trim();
  }
}
