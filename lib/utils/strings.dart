class Strings {
  static const app_name = 'novelsolutely';
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
  static const items = 'Objecto';

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

  static const no_filter = 'Sin filtro';

  static const add_category = 'Nueva categoría';

  static const add_images = 'Editar imágenes';

  static const error_url = 'Introduzca una URL válida';

  static const import_from_text = 'Importar desde archivo de texto';
  static const import_from_file = 'Importar archivos de $app_name';
  static const export_file = 'Exportar archivo de $app_name';

  static const copy_text = 'Texto a importar';

  static const chose_settings = 'Configuración de la importación';

  static const paragraph_breakpoint = 'Párrafos diferentes';
  static const character_breakpoint = 'Por carácter';

  static const check_format =
      'Asegúrase de que el formato corresponde al siguiente.';

  static const select_file = 'Buscar archivo';

  static const import_done = 'Importación realizada, incluidos correctamente: ';

  static const X = 'X';

  static const date = 'Fecha';

  static const instructions_new_category = 'Tenga en cuenta que las categorías se ordenan de forma alfabética. Si desea mantener un orden, incluya un índice.';

  static const new_category = 'Nueva categoría';

  static const new_category_name = 'Nombre de la categoría';
static const new_category_helper =  'Recuerde que puede añadir un índice numérico o alfabético, como: 01 Infacia';
  static bool containsCaseInsensitive(String s, List<String> l) {
    for (String string in l) {
      if (string.toLowerCase() == s.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
