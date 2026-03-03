class wii {
  static const String id = 'winwii';
  static const String app = 'Winwii';
  static const int lanzamiento = 2026;
  static const String autor = '@wilder.taype';
  static const String link = 'https://wtaype.github.io/';
  static const String version = 'v10.10.10';
}

/** Actualizar main luego esto, pero si es mucho, solo esto. (1)
git tag v10 -m "Version v10" ; git push origin v10

//  ACTUALIZACIÓN PRINCIPAL ONE DEV [START] (2)
git add . ; git commit -m "Actualizacion Principal v10.10.10" ; git push origin main

// En caso de emergencia, para actualizar el Tag existente. (3)
git tag -d v10 ; git tag v10 -m "Version v10 actualizada" ; git push origin v10 --force
 ACTUALIZACION TAG[END] */
