class Strings {
  static const app_name = 'Applesolutely';
  static const create = 'CREAR';
  static const cancel = 'CANCELAR';

  static const new_dictionary = 'Nuevo diccionario';

  static const new_dictionary_name = 'Nombre del diccionario';

  static const delete = 'Eliminar';
  static const delete_warning =
      'Este proceso no podrá deshacerse, ¿está seguro de que desea eliminar?';

  static const filters = 'Filtros';

  static const characters = 'Personaje';
  static const places = 'Lugar';
  static const objects = 'Objecto';

  static const others = 'Otro';

  static const add_tag = 'Nueva etiqueta';

  static const personality = 'Descripción psicológica';
  static const appearance = 'Descripción física';

  static const add = 'Añadir';

  static const edit = "Editar";

  static const abilities = 'Capacidades';

  static const parent = 'Madre o padre';
  static const parent_in_law = 'Suegra o suegro';
  static const child = 'Hija o hijo';
  static const child_in_law = 'Nuera o nuero';
  static const partner = 'Pareja';
  static const grandparent = 'Abuela o abuelo';
  static const grandchild = 'Nieta o nieto';
  static const sibling = 'Hermana o hermano';
  static const sib_in_law = 'Cuñada o cuñado';
  static const ancestor = 'Antepasado';
  static const offspring = 'Descendiente';
  static const auncle = 'Tía o tío';
  static const nibling = 'Sobrina o sobrino';
  static const ex_partner = 'Expareja';
  static const friendship = 'Amigo';
  static const rival = 'Rival';
  static const enemy = 'Enemigo';

  static const first = 'Original';
  static const in_the_middle = 'Lo tuvo';
  static const previous = 'Anterior';
  static const current = 'Actual';
  static const unknown = 'Se desconoce';

  static const add_image = 'URL de imagen';

  static const home = 'Menú';

  static const save = 'Guardar';

  static const dictionary = 'Diccionario';

  static const newElement = 'Nuevo elemento en';

  static const chose_category = 'Elija una categoría';

  static const name = 'Nombre';
  static const nickname = 'Apodo';
  static const surname = 'Apellido';
  static const error_empty = 'Este campo es obligatorio';
  static const error_empty_name =
      'Debe de indicar un nombre, apodo o apellido para su personaje';

  static const summary = 'Breve descripción';

  static const tags = 'Añada etiquetas';

  static const data = 'Defina el elemento';

  static String formatName(String name) {
    return '${name.split(', ')[1]} ${name.split(', ')[0]}';
  }

  static bool containsCaseInsensitive(String s, List<String> l) {
    for (String string in l) {
      if (string.toLowerCase() == s.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
