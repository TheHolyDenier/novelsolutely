class CharacterName {
  String name;
  String nickname;
  String surname;

  CharacterName(String fullName,
      {String startChar = '«', String endChar = '»'}) {
    fullName = fullName.replaceAll('?', '');
    print('tmp $fullName');
    if (fullName.lastIndexOf(',') != -1) {
      final List<String> surnameName = fullName.split(',');
      print('tmp $surnameName');
      this.surname = surnameName[0].trim() ?? '';
      final List<String> nameNick = surnameName[1].split(startChar);
      print('tmp $nameNick, ${nameNick.length}');
      this.name = nameNick[0].trim() ?? '';
      if (nameNick.length == 2) {
        this.nickname = nameNick[1].replaceFirst(endChar, '').trim() ?? '';
      } else {
        this.nickname = '';
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
