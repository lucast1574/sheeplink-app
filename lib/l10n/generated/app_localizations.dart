import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// Reporte de contenido o usuario
  ///
  /// In es, this message translates to:
  /// **'Reporte de contenido o usuario'**
  String get mca8c1fc0b533;

  /// Invalid photo
  ///
  /// In es, this message translates to:
  /// **'Invalid photo'**
  String get m67cc537808d8;

  /// Tu sesión terminó. Vuelve a ingresar.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión terminó. Vuelve a ingresar.'**
  String get m5a334e683a12;

  /// No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.'**
  String get m91ff101421b9;

  /// No pudimos completar la acción. Inténtalo de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No pudimos completar la acción. Inténtalo de nuevo.'**
  String get m6cb0a45e7613;

  /// Google did not return an identity.
  ///
  /// In es, this message translates to:
  /// **'Google did not return an identity.'**
  String get m6af7cd04d86b;

  /// Firebase did not return an identity.
  ///
  /// In es, this message translates to:
  /// **'Firebase did not return an identity.'**
  String get m8d20e67b172b;

  /// Mi comunidad
  ///
  /// In es, this message translates to:
  /// **'Mi comunidad'**
  String get m6b7a28c8fb5e;

  /// Cumpleaños y avisos de tu comunidad
  ///
  /// In es, this message translates to:
  /// **'Cumpleaños y avisos de tu comunidad'**
  String get mbee723641566;

  /// Los avisos push no están disponibles en este dispositivo.
  ///
  /// In es, this message translates to:
  /// **'Los avisos push no están disponibles en este dispositivo.'**
  String get me3896368e9af;

  /// Permiso denegado. Puedes habilitarlo en los ajustes del teléfono.
  ///
  /// In es, this message translates to:
  /// **'Permiso denegado. Puedes habilitarlo en los ajustes del teléfono.'**
  String get mab3aad5bf242;

  /// Permite las notificaciones en los ajustes del teléfono.
  ///
  /// In es, this message translates to:
  /// **'Permite las notificaciones en los ajustes del teléfono.'**
  String get m1ef7ac720968;

  /// No pudimos activar todos los avisos. Inténtalo de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No pudimos activar todos los avisos. Inténtalo de nuevo.'**
  String get m3f582376c705;

  /// Abre Perfil para sincronizar los avisos.
  ///
  /// In es, this message translates to:
  /// **'Abre Perfil para sincronizar los avisos.'**
  String get m2de84396bcfe;

  /// Notificaciones activadas y dispositivo sincronizado. Recordatorios actualizados.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas y dispositivo sincronizado. Recordatorios actualizados.'**
  String get m08243457b515;

  /// Recordatorios locales actualizados. Los avisos del servidor no están disponibles en este dispositivo.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios locales actualizados. Los avisos del servidor no están disponibles en este dispositivo.'**
  String get mc478340b5642;

  /// No pudimos completar la sincronización de los avisos. Reintenta desde Perfil.
  ///
  /// In es, this message translates to:
  /// **'No pudimos completar la sincronización de los avisos. Reintenta desde Perfil.'**
  String get m8aed973edda7;

  /// Notifications were disabled.
  ///
  /// In es, this message translates to:
  /// **'Notifications were disabled.'**
  String get m67481232f9ed;

  /// Avisos desactivados.
  ///
  /// In es, this message translates to:
  /// **'Avisos desactivados.'**
  String get m556e0acc5a60;

  /// Usa una foto de menos de 20 MB.
  ///
  /// In es, this message translates to:
  /// **'Usa una foto de menos de 20 MB.'**
  String get m8e0d50a2d008;

  /// No pudimos leer esta foto. Usa JPG o PNG.
  ///
  /// In es, this message translates to:
  /// **'No pudimos leer esta foto. Usa JPG o PNG.'**
  String get mcc752d04b8d6;

  /// La foto sigue siendo muy grande. Prueba con una más pequeña.
  ///
  /// In es, this message translates to:
  /// **'La foto sigue siendo muy grande. Prueba con una más pequeña.'**
  String get mf14f2f81070b;

  /// Mi ministerio
  ///
  /// In es, this message translates to:
  /// **'Mi ministerio'**
  String get m00b34af8b7d2;

  /// Iglesia
  ///
  /// In es, this message translates to:
  /// **'Iglesia'**
  String get mb73a7e98ecad;

  /// Un día para acompañar
  ///
  /// In es, this message translates to:
  /// **'Un día para acompañar'**
  String get m2c41346596a1;

  /// Hoy cumple años {{p0}}. Un saludo puede alegrarle el día.
  ///
  /// In es, this message translates to:
  /// **'Hoy cumple años {p0}. Un saludo puede alegrarle el día.'**
  String mb6fd43c91528(String p0);

  /// {{p0}}{{p1}} a las {{p2}}.
  ///
  /// In es, this message translates to:
  /// **'{p0}{p1} a las {p2}.'**
  String m27626f607323(String p0, String p1, String p2);

  /// Mañana te toca servir
  ///
  /// In es, this message translates to:
  /// **'Mañana te toca servir'**
  String get m69b62091165d;

  /// Hoy te toca servir
  ///
  /// In es, this message translates to:
  /// **'Hoy te toca servir'**
  String get mfa87c2503652;

  /// No pudimos preparar los avisos. Puedes reintentarlo desde Perfil.
  ///
  /// In es, this message translates to:
  /// **'No pudimos preparar los avisos. Puedes reintentarlo desde Perfil.'**
  String get mdb366b898d06;

  /// Figtree
  ///
  /// In es, this message translates to:
  /// **'Figtree'**
  String get mcd859ce5c9d9;

  /// Tienes cambios sin guardar
  ///
  /// In es, this message translates to:
  /// **'Tienes cambios sin guardar'**
  String get ma9b13bcc2ec0;

  /// Si continúas perderás los cambios de esta reunión.
  ///
  /// In es, this message translates to:
  /// **'Si continúas perderás los cambios de esta reunión.'**
  String get m025bd87afc3f;

  /// Seguir editando
  ///
  /// In es, this message translates to:
  /// **'Seguir editando'**
  String get m975698d64cd9;

  /// Descartar cambios
  ///
  /// In es, this message translates to:
  /// **'Descartar cambios'**
  String get m80ca383e9c8d;

  /// Sin asignar
  ///
  /// In es, this message translates to:
  /// **'Sin asignar'**
  String get m84ca335e8bfc;

  /// Fotos que cuidan de todos
  ///
  /// In es, this message translates to:
  /// **'Fotos que cuidan de todos'**
  String get m9c75a923152f;

  /// Sube solo fotos que tengas permiso de compartir. No se permite contenido sexual, violencia, odio, acoso ni explotación de menores. Puedes reportar contenido o usuarios desde Perfil o junto a la foto de la reunión.
  ///
  /// In es, this message translates to:
  /// **'Sube solo fotos que tengas permiso de compartir. No se permite contenido sexual, violencia, odio, acoso ni explotación de menores. Puedes reportar contenido o usuarios desde Perfil o junto a la foto de la reunión.'**
  String get m80a8f7b2f14d;

  /// Leer términos y condiciones
  ///
  /// In es, this message translates to:
  /// **'Leer términos y condiciones'**
  String get m29e142f8d590;

  /// Cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get mbb9dbb406dcb;

  /// Aceptar y continuar
  ///
  /// In es, this message translates to:
  /// **'Aceptar y continuar'**
  String get m62b95e136367;

  /// Cerrar selector
  ///
  /// In es, this message translates to:
  /// **'Cerrar selector'**
  String get m5a5f6d7c5977;

  /// Describe lo ocurrido con al menos 10 caracteres.
  ///
  /// In es, this message translates to:
  /// **'Describe lo ocurrido con al menos 10 caracteres.'**
  String get m9f0ef620d435;

  /// Reportar contenido o usuario
  ///
  /// In es, this message translates to:
  /// **'Reportar contenido o usuario'**
  String get m8764a1f5e833;

  /// Indica qué contenido o usuario debemos revisar. El reporte lo recibe el equipo de soporte de SheepLink.
  ///
  /// In es, this message translates to:
  /// **'Indica qué contenido o usuario debemos revisar. El reporte lo recibe el equipo de soporte de SheepLink.'**
  String get m45d167b2015d;

  /// ¿Qué ocurrió?
  ///
  /// In es, this message translates to:
  /// **'¿Qué ocurrió?'**
  String get m95832c2f9c37;

  /// Incluye la célula, semana o nombre del usuario. No envíes contraseñas.
  ///
  /// In es, this message translates to:
  /// **'Incluye la célula, semana o nombre del usuario. No envíes contraseñas.'**
  String get mfd84fcaa783a;

  /// Enviando…
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get m9415ac2416c5;

  /// Enviar reporte
  ///
  /// In es, this message translates to:
  /// **'Enviar reporte'**
  String get m9739d880d5b0;

  /// Reporte enviado. El equipo de SheepLink lo revisará.
  ///
  /// In es, this message translates to:
  /// **'Reporte enviado. El equipo de SheepLink lo revisará.'**
  String get m801cb7f02a48;

  /// Tu comunidad,
  /// más cerca.
  ///
  /// In es, this message translates to:
  /// **'Tu comunidad,\nmás cerca.'**
  String get mf823a0d28dce;

  /// Un espacio sencillo para acompañar a tu célula.
  ///
  /// In es, this message translates to:
  /// **'Un espacio sencillo para acompañar a tu célula.'**
  String get m2218ed82eb74;

  /// Continuar con Google
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get mab51f6ea5985;

  /// o entra con tu correo
  ///
  /// In es, this message translates to:
  /// **'o entra con tu correo'**
  String get mdd0f139b3178;

  /// Correo electrónico
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get mec64dc30a483;

  /// Escribe tu correo electrónico.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu correo electrónico.'**
  String get mf92e850af7bf;

  /// Contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get ma389a638dec3;

  /// Escribe tu contraseña.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu contraseña.'**
  String get ma50194551d9b;

  /// Ingresando…
  ///
  /// In es, this message translates to:
  /// **'Ingresando…'**
  String get me4269fcd2489;

  /// Entrar a mi comunidad
  ///
  /// In es, this message translates to:
  /// **'Entrar a mi comunidad'**
  String get m4faead569d28;

  /// Ingresa con la misma cuenta que usas en SheepLink.
  ///
  /// In es, this message translates to:
  /// **'Ingresa con la misma cuenta que usas en SheepLink.'**
  String get mdd8683778577;

  /// d 'de' MMM
  ///
  /// In es, this message translates to:
  /// **'d \'de\' MMM'**
  String get m8c148b9fcf35;

  /// Mensajes y avisos
  ///
  /// In es, this message translates to:
  /// **'Mensajes y avisos'**
  String get m82307e502cc6;

  /// Cerrar
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get maeccae342e4b;

  /// No tienes avisos pendientes por ahora.
  ///
  /// In es, this message translates to:
  /// **'No tienes avisos pendientes por ahora.'**
  String get m058bd29bd53b;

  /// Fijado
  ///
  /// In es, this message translates to:
  /// **'Fijado'**
  String get m3a7900b566d1;

  /// Presente
  ///
  /// In es, this message translates to:
  /// **'Presente'**
  String get ma4a06c1819b7;

  /// Ausente
  ///
  /// In es, this message translates to:
  /// **'Ausente'**
  String get mfd7f0836e8ad;

  /// La reunión está por realizarse. Prepara el plan ahora y registra la asistencia cuando llegue el día.
  ///
  /// In es, this message translates to:
  /// **'La reunión está por realizarse. Prepara el plan ahora y registra la asistencia cuando llegue el día.'**
  String get ma901543e48c3;

  /// Tu cuenta puede consultar esta célula. El registro requiere permiso de asistencia.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta puede consultar esta célula. El registro requiere permiso de asistencia.'**
  String get m3cca5d976609;

  /// Aún no hay integrantes activos en esta célula.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay integrantes activos en esta célula.'**
  String get me4e77ddd6019;

  /// {{p0}} de {{p1}} marcados · {{p2}} presentes
  ///
  /// In es, this message translates to:
  /// **'{p0} de {p1} marcados · {p2} presentes'**
  String m35fc3f717c5f(String p0, String p1, String p2);

  /// Marca presente o ausente para cada persona.
  ///
  /// In es, this message translates to:
  /// **'Marca presente o ausente para cada persona.'**
  String get m20a29be89612;

  /// Marcar pendientes como ausentes
  ///
  /// In es, this message translates to:
  /// **'Marcar pendientes como ausentes'**
  String get m5dcf6c2f41dd;

  /// Guardando…
  ///
  /// In es, this message translates to:
  /// **'Guardando…'**
  String get m3c8dc4dc7a83;

  /// Guardar reunión
  ///
  /// In es, this message translates to:
  /// **'Guardar reunión'**
  String get ma9b09fdc946a;

  /// Reunión guardada
  ///
  /// In es, this message translates to:
  /// **'Reunión guardada'**
  String get m7158ed1d325d;

  /// Completa todas las marcas para guardar.
  ///
  /// In es, this message translates to:
  /// **'Completa todas las marcas para guardar.'**
  String get m6a62e02614b8;

  /// Puedes corregir las marcas antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'Puedes corregir las marcas antes de guardar.'**
  String get md21df98f0966;

  /// Un día para celebrar
  ///
  /// In es, this message translates to:
  /// **'Un día para celebrar'**
  String get mdf66b455043d;

  /// Cumpleaños de tu célula · próximos 30 días
  ///
  /// In es, this message translates to:
  /// **'Cumpleaños de tu célula · próximos 30 días'**
  String get md6e184172342;

  /// No hay cumpleaños registrados para estos días.
  ///
  /// In es, this message translates to:
  /// **'No hay cumpleaños registrados para estos días.'**
  String get maff7b8055aab;

  /// Hoy · un saludo hace la diferencia
  ///
  /// In es, this message translates to:
  /// **'Hoy · un saludo hace la diferencia'**
  String get me5c70930ceca;

  /// Un buen día para hacerle sentir parte.
  ///
  /// In es, this message translates to:
  /// **'Un buen día para hacerle sentir parte.'**
  String get m0ea3f422ac9d;

  /// Elige tu célula
  ///
  /// In es, this message translates to:
  /// **'Elige tu célula'**
  String get m1411146d4073;

  /// Mi célula
  ///
  /// In es, this message translates to:
  /// **'Mi célula'**
  String get mf8fb3dc84c6e;

  /// Sin célula asignada
  ///
  /// In es, this message translates to:
  /// **'Sin célula asignada'**
  String get m2f8a872a2eca;

  /// Cambiar célula
  ///
  /// In es, this message translates to:
  /// **'Cambiar célula'**
  String get meae6c487bac5;

  /// Semana del {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Semana del {p0}'**
  String m15eba185d110(String p0);

  /// Anterior
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get me4ce7c09d51e;

  /// Siguiente
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get m49683b71c6ac;

  /// Elegir fecha · {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Elegir fecha · {p0}'**
  String m11e68ec7d8f6(String p0);

  /// EEEE d 'de' MMMM
  ///
  /// In es, this message translates to:
  /// **'EEEE d \'de\' MMMM'**
  String get m05fd84dd61af;

  /// Esta semana tiene una reunión registrada. Para una nueva reunión, elige otra semana.
  ///
  /// In es, this message translates to:
  /// **'Esta semana tiene una reunión registrada. Para una nueva reunión, elige otra semana.'**
  String get mc1a96dd2ec6a;

  /// Preparar próxima célula
  ///
  /// In es, this message translates to:
  /// **'Preparar próxima célula'**
  String get mc14517580692;

  /// Asistencia
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get m35d03bb8cc97;

  /// Planificador
  ///
  /// In es, this message translates to:
  /// **'Planificador'**
  String get m6dc295258d08;

  /// Actividades habituales
  ///
  /// In es, this message translates to:
  /// **'Actividades habituales'**
  String get m9ce88185986d;

  /// Actividades de esta reunión
  ///
  /// In es, this message translates to:
  /// **'Actividades de esta reunión'**
  String get m945d4c83ccfd;

  /// Se usarán en las nuevas reuniones. Las reuniones guardadas no cambian.
  ///
  /// In es, this message translates to:
  /// **'Se usarán en las nuevas reuniones. Las reuniones guardadas no cambian.'**
  String get m57a5f96fd673;

  /// Elige lo que harán en esta fecha. Conservaremos las asignaciones de lo que no hagan.
  ///
  /// In es, this message translates to:
  /// **'Elige lo que harán en esta fecha. Conservaremos las asignaciones de lo que no hagan.'**
  String get m0941f6617737;

  /// Bienvenida
  ///
  /// In es, this message translates to:
  /// **'Bienvenida'**
  String get mf5f273d88e2e;

  /// Alabanza
  ///
  /// In es, this message translates to:
  /// **'Alabanza'**
  String get m3a42dad1f958;

  /// Palabra
  ///
  /// In es, this message translates to:
  /// **'Palabra'**
  String get mb57f8d7339c9;

  /// Oración
  ///
  /// In es, this message translates to:
  /// **'Oración'**
  String get m71babbfd2917;

  /// Despedida
  ///
  /// In es, this message translates to:
  /// **'Despedida'**
  String get mc4ddf5105f52;

  /// Selecciona una célula para consultar su plan semanal.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una célula para consultar su plan semanal.'**
  String get m951ad19c9bc7;

  /// Reintentar plan
  ///
  /// In es, this message translates to:
  /// **'Reintentar plan'**
  String get mc21ffa48764c;

  /// Plan de {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Plan de {p0}'**
  String mbfff4dd31017(String p0);

  /// Puedes consultar el plan. Solo los responsables de la célula pueden editarlo.
  ///
  /// In es, this message translates to:
  /// **'Puedes consultar el plan. Solo los responsables de la célula pueden editarlo.'**
  String get mcf8ad632141a;

  /// Título del encuentro
  ///
  /// In es, this message translates to:
  /// **'Título del encuentro'**
  String get m7b00f485031b;

  /// ¿Qué compartirán esta semana?
  ///
  /// In es, this message translates to:
  /// **'¿Qué compartirán esta semana?'**
  String get m3a251873f94e;

  /// No hay actividades seleccionadas para esta reunión.
  ///
  /// In es, this message translates to:
  /// **'No hay actividades seleccionadas para esta reunión.'**
  String get m80353e24546c;

  /// Responsable
  ///
  /// In es, this message translates to:
  /// **'Responsable'**
  String get m62c1aec4ffc8;

  /// Descripción
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get mee00b96fff26;

  /// Indicaciones para {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Indicaciones para {p0}'**
  String m9f837af34453(String p0);

  /// Escribe un título para el encuentro.
  ///
  /// In es, this message translates to:
  /// **'Escribe un título para el encuentro.'**
  String get m3a9634090942;

  /// Plan guardado.
  ///
  /// In es, this message translates to:
  /// **'Plan guardado.'**
  String get m5b7608db8957;

  /// Guardar plan
  ///
  /// In es, this message translates to:
  /// **'Guardar plan'**
  String get m34011ca1d486;

  /// Elegir actividades de esta reunión
  ///
  /// In es, this message translates to:
  /// **'Elegir actividades de esta reunión'**
  String get m3d44f0be19af;

  /// Configurar actividades habituales
  ///
  /// In es, this message translates to:
  /// **'Configurar actividades habituales'**
  String get m09ec41492cae;

  /// Mantente cerca de tu comunidad
  ///
  /// In es, this message translates to:
  /// **'Mantente cerca de tu comunidad'**
  String get mf0c689c710b4;

  /// Te avisamos de los cumpleaños y de tus turnos de servicio: el día anterior y el mismo día. Puedes elegir los avisos en tu perfil.
  ///
  /// In es, this message translates to:
  /// **'Te avisamos de los cumpleaños y de tus turnos de servicio: el día anterior y el mismo día. Puedes elegir los avisos en tu perfil.'**
  String get mc458a6cd56d3;

  /// Ahora no
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get m6c64e278488d;

  /// Activar
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get m8e38c2571d87;

  /// Reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get ma9254c5f8128;

  /// Hoy
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get m55133d4e6eb6;

  /// Perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get m00d551e63dd5;

  /// No tienes cursos activos asignados como maestro.
  ///
  /// In es, this message translates to:
  /// **'No tienes cursos activos asignados como maestro.'**
  String get mb07b919ee966;

  /// Asistencia de cursos
  ///
  /// In es, this message translates to:
  /// **'Asistencia de cursos'**
  String get m65f64698cf0d;

  /// Volver a cursos
  ///
  /// In es, this message translates to:
  /// **'Volver a cursos'**
  String get md9414a7431b1;

  /// {{p0}} {{p1}} · Marcar asistencia
  ///
  /// In es, this message translates to:
  /// **'{p0} {p1} · Marcar asistencia'**
  String m85532e16f36c(String p0, String p1);

  /// Asistencia · {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Asistencia · {p0}'**
  String m36ff829074e6(String p0);

  /// Alumno
  ///
  /// In es, this message translates to:
  /// **'Alumno'**
  String get m957da9fb6923;

  /// Asistencia guardada.
  ///
  /// In es, this message translates to:
  /// **'Asistencia guardada.'**
  String get m233839e8fe3f;

  /// Guardar asistencia
  ///
  /// In es, this message translates to:
  /// **'Guardar asistencia'**
  String get md84d1126102b;

  /// Portada ilustrada del curso
  ///
  /// In es, this message translates to:
  /// **'Portada ilustrada del curso'**
  String get m319292aee78f;

  /// Portada de {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Portada de {p0}'**
  String meeef5e3f6156(String p0);

  /// Mi devocional de hoy
  ///
  /// In es, this message translates to:
  /// **'Mi devocional de hoy'**
  String get m807c269930cc;

  /// Lectura bíblica
  ///
  /// In es, this message translates to:
  /// **'Lectura bíblica'**
  String get ma4bf84d85b20;

  /// Mi reflexión
  ///
  /// In es, this message translates to:
  /// **'Mi reflexión'**
  String get m2bfbf01f3576;

  /// ¿Qué te dejó la lectura de hoy?
  ///
  /// In es, this message translates to:
  /// **'¿Qué te dejó la lectura de hoy?'**
  String get m1270f237be68;

  /// Devocional guardado.
  ///
  /// In es, this message translates to:
  /// **'Devocional guardado.'**
  String get m4e142b0fcf09;

  /// Guardar devocional
  ///
  /// In es, this message translates to:
  /// **'Guardar devocional'**
  String get md634470d9348;

  /// No pudimos cargar el tema.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el tema.'**
  String get mb30192f8cdf1;

  /// Tema o título de la reunión
  ///
  /// In es, this message translates to:
  /// **'Tema o título de la reunión'**
  String get mc2d114ea71ba;

  /// Ej. La fe en tiempos difíciles
  ///
  /// In es, this message translates to:
  /// **'Ej. La fe en tiempos difíciles'**
  String get m5b52903c9423;

  /// Tema guardado.
  ///
  /// In es, this message translates to:
  /// **'Tema guardado.'**
  String get mde078aa6f551;

  /// No se pudo guardar el tema. Reintenta.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar el tema. Reintenta.'**
  String get mffd697f0812b;

  /// Guardar tema
  ///
  /// In es, this message translates to:
  /// **'Guardar tema'**
  String get m6d5a1ffed64f;

  /// dinámica 1
  ///
  /// In es, this message translates to:
  /// **'dinámica 1'**
  String get me0cc74a6b7d8;

  /// dinámica 2
  ///
  /// In es, this message translates to:
  /// **'dinámica 2'**
  String get m2eb0ce6104c2;

  /// Aplicar selección
  ///
  /// In es, this message translates to:
  /// **'Aplicar selección'**
  String get mdcb74c01e9e3;

  /// Reportar ausencia
  ///
  /// In es, this message translates to:
  /// **'Reportar ausencia'**
  String get mc95eed82d976;

  /// Motivo (opcional)
  ///
  /// In es, this message translates to:
  /// **'Motivo (opcional)'**
  String get mdecd42d278ee;

  /// Confirmar ausencia
  ///
  /// In es, this message translates to:
  /// **'Confirmar ausencia'**
  String get m9a2bbbd7afbd;

  /// Tu servicio
  ///
  /// In es, this message translates to:
  /// **'Tu servicio'**
  String get m27365075772d;

  /// No tienes turnos próximos asignados. Cuando tu líder programe uno, aparecerá aquí.
  ///
  /// In es, this message translates to:
  /// **'No tienes turnos próximos asignados. Cuando tu líder programe uno, aparecerá aquí.'**
  String get m9faebf1d2790;

  /// Asignación de hoy
  ///
  /// In es, this message translates to:
  /// **'Asignación de hoy'**
  String get m821e20bdc71c;

  /// Servicio
  ///
  /// In es, this message translates to:
  /// **'Servicio'**
  String get m1efa3b455a06;

  /// Asignación pendiente de confirmar. Aún no genera recordatorios.
  ///
  /// In es, this message translates to:
  /// **'Asignación pendiente de confirmar. Aún no genera recordatorios.'**
  String get m70a39f863f0d;

  /// Aceptar
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get m640d6761c178;

  /// No puedo asistir
  ///
  /// In es, this message translates to:
  /// **'No puedo asistir'**
  String get mf53f7de6464b;

  /// Hola, {{p0}}.
  ///
  /// In es, this message translates to:
  /// **'Hola, {p0}.'**
  String mbd93f4de4dcf(String p0);

  /// Lo importante es estar cerca.
  ///
  /// In es, this message translates to:
  /// **'Lo importante es estar cerca.'**
  String get m900ab22a2a79;

  /// Tu célula
  ///
  /// In es, this message translates to:
  /// **'Tu célula'**
  String get m25fc5f3074b5;

  /// Cada persona
  /// cuenta.
  ///
  /// In es, this message translates to:
  /// **'Cada persona\ncuenta.'**
  String get m67fb2ba71687;

  /// Todavía no tienes una célula asignada.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes una célula asignada.'**
  String get m3ed1416b4e71;

  /// {{p0}} integrantes para acompañar.
  ///
  /// In es, this message translates to:
  /// **'{p0} integrantes para acompañar.'**
  String m22cb54973300(String p0);

  /// Marcar asistencia
  ///
  /// In es, this message translates to:
  /// **'Marcar asistencia'**
  String get m340998e0abc0;

  /// No pudimos preparar la foto. Prueba con una imagen JPG o PNG más pequeña.
  ///
  /// In es, this message translates to:
  /// **'No pudimos preparar la foto. Prueba con una imagen JPG o PNG más pequeña.'**
  String get mb76bba1125b2;

  /// La foto de esta semana
  ///
  /// In es, this message translates to:
  /// **'La foto de esta semana'**
  String get mff416f36cb45;

  /// Un recuerdo de la reunión, junto a su asistencia. El pastor podrá revisarlo en el historial.
  ///
  /// In es, this message translates to:
  /// **'Un recuerdo de la reunión, junto a su asistencia. El pastor podrá revisarlo en el historial.'**
  String get m954918fe479e;

  /// Foto de la reunión semanal
  ///
  /// In es, this message translates to:
  /// **'Foto de la reunión semanal'**
  String get md6beb8d9b5ab;

  /// No pudimos mostrar esta foto.
  ///
  /// In es, this message translates to:
  /// **'No pudimos mostrar esta foto.'**
  String get ma84a7d52c6c1;

  /// Todavía no hay una foto de esta reunión.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay una foto de esta reunión.'**
  String get m540b61eed958;

  /// Tomar foto
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get m16724a5eab2a;

  /// Elegir de galería
  ///
  /// In es, this message translates to:
  /// **'Elegir de galería'**
  String get mc134d6478a98;

  /// Deshacer cambio
  ///
  /// In es, this message translates to:
  /// **'Deshacer cambio'**
  String get m3d44a92b8bbe;

  /// Célula {{p0}}; semana {{p1}}; foto de reunión
  ///
  /// In es, this message translates to:
  /// **'Célula {p0}; semana {p1}; foto de reunión'**
  String m761201703986(String p0, String p1);

  /// Reportar esta foto o usuario
  ///
  /// In es, this message translates to:
  /// **'Reportar esta foto o usuario'**
  String get m50645d660fa1;

  /// Preparando la foto…
  ///
  /// In es, this message translates to:
  /// **'Preparando la foto…'**
  String get m645523b074f4;

  /// Foto pendiente. Se enviará al guardar la reunión.
  ///
  /// In es, this message translates to:
  /// **'Foto pendiente. Se enviará al guardar la reunión.'**
  String get m77f96d59dca3;

  /// El teléfono recuperó una foto que no se había enviado. Comprueba que corresponde a esta semana.
  ///
  /// In es, this message translates to:
  /// **'El teléfono recuperó una foto que no se había enviado. Comprueba que corresponde a esta semana.'**
  String get mcfaa698de8e2;

  /// Usar en esta semana
  ///
  /// In es, this message translates to:
  /// **'Usar en esta semana'**
  String get m81f5818d024d;

  /// Tu espacio de trabajo
  ///
  /// In es, this message translates to:
  /// **'Tu espacio de trabajo'**
  String get m25a2e8bb8311;

  /// Elige una iglesia
  ///
  /// In es, this message translates to:
  /// **'Elige una iglesia'**
  String get m9cb07a120628;

  /// Tu cuenta administra la plataforma. Selecciona la comunidad que quieres abrir en la app.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta administra la plataforma. Selecciona la comunidad que quieres abrir en la app.'**
  String get me6a6069fda35;

  /// Abrir comunidad
  ///
  /// In es, this message translates to:
  /// **'Abrir comunidad'**
  String get m88f5ea4a93e1;

  /// Google access is not configured.
  ///
  /// In es, this message translates to:
  /// **'Google access is not configured.'**
  String get m081350fdaaea;

  /// No pudimos cargar la foto de esta semana.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar la foto de esta semana.'**
  String get mc442ad6fda97;

  /// Reunión semanal guardada. Ya forma parte del historial de tu célula.
  ///
  /// In es, this message translates to:
  /// **'Reunión semanal guardada. Ya forma parte del historial de tu célula.'**
  String get m31d10fde7a16;

  /// La asistencia está guardada; falta guardar la foto o el registro semanal. Reintenta. {{p0}}
  ///
  /// In es, this message translates to:
  /// **'La asistencia está guardada; falta guardar la foto o el registro semanal. Reintenta. {p0}'**
  String m547689bb8b42(String p0);

  /// Servicio confirmado.
  ///
  /// In es, this message translates to:
  /// **'Servicio confirmado.'**
  String get m22b08009589c;

  /// Ausencia reportada al líder del ministerio.
  ///
  /// In es, this message translates to:
  /// **'Ausencia reportada al líder del ministerio.'**
  String get m89a91fa1011b;

  /// Tomar una foto
  ///
  /// In es, this message translates to:
  /// **'Tomar una foto'**
  String get mc5ad79152f73;

  /// No pudimos cambiar tu foto. Inténtalo de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cambiar tu foto. Inténtalo de nuevo.'**
  String get me9cad51432e2;

  /// Foto de perfil de {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil de {p0}'**
  String m391e20da0c2f(String p0);

  /// Guardando foto…
  ///
  /// In es, this message translates to:
  /// **'Guardando foto…'**
  String get me778abe4d995;

  /// Cambiar foto de perfil
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto de perfil'**
  String get m91912ae7c0ef;

  /// Tu espacio
  ///
  /// In es, this message translates to:
  /// **'Tu espacio'**
  String get m4d091d3ccd71;

  /// Mi perfil
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get mce08fdc24c11;

  /// No pudimos completar la acción. Revisa tu conexión e inténtalo de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No pudimos completar la acción. Revisa tu conexión e inténtalo de nuevo.'**
  String get m194139b0bf1f;

  /// Iglesia seleccionada
  ///
  /// In es, this message translates to:
  /// **'Iglesia seleccionada'**
  String get me5cbc5e87577;

  /// Cambiar iglesia
  ///
  /// In es, this message translates to:
  /// **'Cambiar iglesia'**
  String get m074a5e75a8e3;

  /// Teléfono
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get mf1186abd0b8b;

  /// Cumpleaños
  ///
  /// In es, this message translates to:
  /// **'Cumpleaños'**
  String get mb3a165bd5c78;

  /// d 'de' MMMM
  ///
  /// In es, this message translates to:
  /// **'d \'de\' MMMM'**
  String get m82886eb918c3;

  /// Ministerios
  ///
  /// In es, this message translates to:
  /// **'Ministerios'**
  String get m2f8aa99e0a61;

  /// Un recordatorio cercano
  ///
  /// In es, this message translates to:
  /// **'Un recordatorio cercano'**
  String get m86f063376aec;

  /// Cumpleaños y servicio, a tu manera. Los turnos confirmados se recuerdan a las 19:00 del día anterior y dos horas antes. Abre la app para mantener tus avisos actualizados.
  ///
  /// In es, this message translates to:
  /// **'Cumpleaños y servicio, a tu manera. Los turnos confirmados se recuerdan a las 19:00 del día anterior y dos horas antes. Abre la app para mantener tus avisos actualizados.'**
  String get m213667011fa0;

  /// Un momento…
  ///
  /// In es, this message translates to:
  /// **'Un momento…'**
  String get m117814a3584e;

  /// Desactivar avisos
  ///
  /// In es, this message translates to:
  /// **'Desactivar avisos'**
  String get mad2f3e6fd647;

  /// Activar notificaciones
  ///
  /// In es, this message translates to:
  /// **'Activar notificaciones'**
  String get m967eadfb6810;

  /// Reintentar activación de notificaciones
  ///
  /// In es, this message translates to:
  /// **'Reintentar activación de notificaciones'**
  String get mc7aa59693b25;

  /// Cumpleaños de mi célula
  ///
  /// In es, this message translates to:
  /// **'Cumpleaños de mi célula'**
  String get me7f4ac0e4faf;

  /// Mis turnos de servicio
  ///
  /// In es, this message translates to:
  /// **'Mis turnos de servicio'**
  String get ma1aa57b0ae00;

  /// No browser
  ///
  /// In es, this message translates to:
  /// **'No browser'**
  String get meb80d908905f;

  /// Privacidad
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get m52233e2c4d6b;

  /// Términos
  ///
  /// In es, this message translates to:
  /// **'Términos'**
  String get m60eaf1f65f21;

  /// Perfil móvil; comunidad {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Perfil móvil; comunidad {p0}'**
  String me62d1c062cd5(String p0);

  /// Cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get mc6e6960395f4;

  /// Origen no permitido por CORS
  ///
  /// In es, this message translates to:
  /// **'Origen no permitido por CORS'**
  String get m8ca066c6dfaf;

  /// Petición no permitida
  ///
  /// In es, this message translates to:
  /// **'Petición no permitida'**
  String get m2724dd84531f;

  /// No se pudo completar la eliminación de Google. Intenta más tarde.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar la eliminación de Google. Intenta más tarde.'**
  String get md69daf16cbbc;

  /// No se pudo verificar Google. Intenta de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo verificar Google. Intenta de nuevo.'**
  String get ma588e1f94e6d;

  /// El acceso con Google aún no está configurado
  ///
  /// In es, this message translates to:
  /// **'El acceso con Google aún no está configurado'**
  String get mfffaecd0cb7e;

  /// Acceso de Google inválido
  ///
  /// In es, this message translates to:
  /// **'Acceso de Google inválido'**
  String get m1613505a4579;

  /// No se pudo validar el acceso de Google. Vuelve a intentarlo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo validar el acceso de Google. Vuelve a intentarlo.'**
  String get m2737101960dc;

  /// No se pudo enviar el correo. Inténtalo de nuevo en unos minutos.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar el correo. Inténtalo de nuevo en unos minutos.'**
  String get m64e42b32cc3c;

  /// Falta configurar MAIL_FROM_EMAIL en el servidor.
  ///
  /// In es, this message translates to:
  /// **'Falta configurar MAIL_FROM_EMAIL en el servidor.'**
  String get m1cdef3a9e1dd;

  /// El envío de correos no está configurado en el servidor.
  ///
  /// In es, this message translates to:
  /// **'El envío de correos no está configurado en el servidor.'**
  String get md49a2f75a5a6;

  /// La subida de fotos estará disponible cuando se vincule el almacenamiento S3 de Nexode.
  ///
  /// In es, this message translates to:
  /// **'La subida de fotos estará disponible cuando se vincule el almacenamiento S3 de Nexode.'**
  String get mfd5ee96cd03a;

  /// La foto es demasiado grande
  ///
  /// In es, this message translates to:
  /// **'La foto es demasiado grande'**
  String get m0bd1ad5be257;

  /// Usa una imagen JPG, PNG o WebP
  ///
  /// In es, this message translates to:
  /// **'Usa una imagen JPG, PNG o WebP'**
  String get mc4842b4d19d8;

  /// La foto debe pesar hasta 500 KB
  ///
  /// In es, this message translates to:
  /// **'La foto debe pesar hasta 500 KB'**
  String get m001f7716a4e1;

  /// El archivo no es una imagen válida
  ///
  /// In es, this message translates to:
  /// **'El archivo no es una imagen válida'**
  String get m51be20ade068;

  /// No se pudieron borrar todas las fotos. Intenta de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron borrar todas las fotos. Intenta de nuevo.'**
  String get m581039566d05;

  /// Período no encontrado
  ///
  /// In es, this message translates to:
  /// **'Período no encontrado'**
  String get md1228e3c81f8;

  /// El período cambió; vuelve a cargarlo
  ///
  /// In es, this message translates to:
  /// **'El período cambió; vuelve a cargarlo'**
  String get m8d7721030ee5;

  /// El fin debe ser igual o posterior al inicio
  ///
  /// In es, this message translates to:
  /// **'El fin debe ser igual o posterior al inicio'**
  String get m3a6a5d6ef2f5;

  /// Estado inválido
  ///
  /// In es, this message translates to:
  /// **'Estado inválido'**
  String get mf49ab2eaafd2;

  /// Elige un período activo de tu iglesia
  ///
  /// In es, this message translates to:
  /// **'Elige un período activo de tu iglesia'**
  String get m5e9fddcb5c23;

  /// Reglas académicas inválidas
  ///
  /// In es, this message translates to:
  /// **'Reglas académicas inválidas'**
  String get mf1dd891ceb73;

  /// Revisa la nota mínima (0–20), asistencia (0–100) y reglas de evaluación
  ///
  /// In es, this message translates to:
  /// **'Revisa la nota mínima (0–20), asistencia (0–100) y reglas de evaluación'**
  String get m0f9791ddb49d;

  /// El peso debe ser mayor a 0 y no superar 1000
  ///
  /// In es, this message translates to:
  /// **'El peso debe ser mayor a 0 y no superar 1000'**
  String get mf67372245802;

  /// Filtro académico inválido
  ///
  /// In es, this message translates to:
  /// **'Filtro académico inválido'**
  String get mce7b34a6d03e;

  /// Formato inválido
  ///
  /// In es, this message translates to:
  /// **'Formato inválido'**
  String get mc1f8270d480c;

  /// Este curso ya está registrado en el catálogo
  ///
  /// In es, this message translates to:
  /// **'Este curso ya está registrado en el catálogo'**
  String get m998aede32721;

  /// Curso del catálogo no encontrado
  ///
  /// In es, this message translates to:
  /// **'Curso del catálogo no encontrado'**
  String get m419465850996;

  /// Elige un curso activo del catálogo
  ///
  /// In es, this message translates to:
  /// **'Elige un curso activo del catálogo'**
  String get m486bb3f43ca4;

  /// Solo pastor, owner o líder de zona pueden crear cursos
  ///
  /// In es, this message translates to:
  /// **'Solo pastor, owner o líder de zona pueden crear cursos'**
  String get m9180e1278ee3;

  /// Fecha de inicio inválida
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio inválida'**
  String get m990e7ef78621;

  /// Fecha de fin inválida
  ///
  /// In es, this message translates to:
  /// **'Fecha de fin inválida'**
  String get mfe0a72360caa;

  /// La fecha de fin no puede ser anterior a la de inicio
  ///
  /// In es, this message translates to:
  /// **'La fecha de fin no puede ser anterior a la de inicio'**
  String get m9598f28dafe2;

  /// Indica la hora de inicio y fin
  ///
  /// In es, this message translates to:
  /// **'Indica la hora de inicio y fin'**
  String get me6d557f82794;

  /// Indica hasta qué fecha se repetirá la clase
  ///
  /// In es, this message translates to:
  /// **'Indica hasta qué fecha se repetirá la clase'**
  String get m824f1c137149;

  /// El responsable organiza grupos, maestros y horarios. Puedes editar la descripción, modalidad y ubicación
  ///
  /// In es, this message translates to:
  /// **'El responsable organiza grupos, maestros y horarios. Puedes editar la descripción, modalidad y ubicación'**
  String get me0e84b558033;

  /// Para finalizar un curso usa la opción "Finalizar", donde eliges quiénes aprobaron
  ///
  /// In es, this message translates to:
  /// **'Para finalizar un curso usa la opción \"Finalizar\", donde eliges quiénes aprobaron'**
  String get m244358868f2b;

  /// Para otro ciclo crea un nuevo grupo. Los resultados de este grupo se conservan
  ///
  /// In es, this message translates to:
  /// **'Para otro ciclo crea un nuevo grupo. Los resultados de este grupo se conservan'**
  String get m71faa3ee085b;

  /// Curso eliminado por completo
  ///
  /// In es, this message translates to:
  /// **'Curso eliminado por completo'**
  String get m8dbaaebbdfb6;

  /// El curso ya está finalizado
  ///
  /// In es, this message translates to:
  /// **'El curso ya está finalizado'**
  String get mddbcac3b9b90;

  /// approvedMemberIds debe ser una lista
  ///
  /// In es, this message translates to:
  /// **'approvedMemberIds debe ser una lista'**
  String get m4015c0b29344;

  /// Hay personas que no están inscritas en este curso
  ///
  /// In es, this message translates to:
  /// **'Hay personas que no están inscritas en este curso'**
  String get m778d1e70e55d;

  /// Hay alumnos seleccionados que no cumplen la nota o asistencia mínima del curso
  ///
  /// In es, this message translates to:
  /// **'Hay alumnos seleccionados que no cumplen la nota o asistencia mínima del curso'**
  String get m8ed83282c95e;

  /// Curso finalizado
  ///
  /// In es, this message translates to:
  /// **'Curso finalizado'**
  String get mbd27f7c46e19;

  /// El resultado se define al finalizar el curso
  ///
  /// In es, this message translates to:
  /// **'El resultado se define al finalizar el curso'**
  String get m1bb8364d87c4;

  /// Resultado inválido
  ///
  /// In es, this message translates to:
  /// **'Resultado inválido'**
  String get m68b680437320;

  /// Alumno no encontrado
  ///
  /// In es, this message translates to:
  /// **'Alumno no encontrado'**
  String get m6fca084dac49;

  /// El curso está finalizado. Reactívalo para agregar alumnos
  ///
  /// In es, this message translates to:
  /// **'El curso está finalizado. Reactívalo para agregar alumnos'**
  String get mab1b690b3f30;

  /// Elige entre 1 y 100 integrantes
  ///
  /// In es, this message translates to:
  /// **'Elige entre 1 y 100 integrantes'**
  String get m5fcda7d76869;

  /// Hay integrantes que no existen o no están activos
  ///
  /// In es, this message translates to:
  /// **'Hay integrantes que no existen o no están activos'**
  String get m27f6b62f7153;

  /// El curso está finalizado
  ///
  /// In es, this message translates to:
  /// **'El curso está finalizado'**
  String get m93e5cfa4170a;

  /// Alumno quitado del curso
  ///
  /// In es, this message translates to:
  /// **'Alumno quitado del curso'**
  String get me83751df7afd;

  /// Fecha inválida
  ///
  /// In es, this message translates to:
  /// **'Fecha inválida'**
  String get m4fcdd3bc433d;

  /// No se puede registrar asistencia de una fecha futura
  ///
  /// In es, this message translates to:
  /// **'No se puede registrar asistencia de una fecha futura'**
  String get m06c72cf0742c;

  /// records es obligatorio
  ///
  /// In es, this message translates to:
  /// **'records es obligatorio'**
  String get m669e72e76313;

  /// Estado de asistencia inválido
  ///
  /// In es, this message translates to:
  /// **'Estado de asistencia inválido'**
  String get m33b50250ce65;

  /// Asistencia inválida
  ///
  /// In es, this message translates to:
  /// **'Asistencia inválida'**
  String get mba5fd06579b9;

  /// Asistencia registrada
  ///
  /// In es, this message translates to:
  /// **'Asistencia registrada'**
  String get m4e21c82b28e2;

  /// {{p0}} inválida
  ///
  /// In es, this message translates to:
  /// **'{p0} inválida'**
  String mf80088d94c4a(String p0);

  /// Un curso admite hasta {{p0}} evaluaciones
  ///
  /// In es, this message translates to:
  /// **'Un curso admite hasta {p0} evaluaciones'**
  String mcbcc3f1c23db(String p0);

  /// Ya existe una evaluación con ese nombre en este curso
  ///
  /// In es, this message translates to:
  /// **'Ya existe una evaluación con ese nombre en este curso'**
  String get m904395f4a05b;

  /// Evaluación no encontrada
  ///
  /// In es, this message translates to:
  /// **'Evaluación no encontrada'**
  String get m9dea7bd54d02;

  /// Hay notas mayores a {{p0}}. Corrígelas antes de bajar la nota máxima
  ///
  /// In es, this message translates to:
  /// **'Hay notas mayores a {p0}. Corrígelas antes de bajar la nota máxima'**
  String mf4d0ac3ce5fe(String p0);

  /// Evaluación eliminada con sus notas
  ///
  /// In es, this message translates to:
  /// **'Evaluación eliminada con sus notas'**
  String get m4e54fdaa2103;

  /// Hay evaluaciones que no pertenecen a este curso
  ///
  /// In es, this message translates to:
  /// **'Hay evaluaciones que no pertenecen a este curso'**
  String get mf6533f1c48fa;

  /// Notas guardadas
  ///
  /// In es, this message translates to:
  /// **'Notas guardadas'**
  String get m623a05b19744;

  /// El año debe estar entre 1950 y {{p0}}
  ///
  /// In es, this message translates to:
  /// **'El año debe estar entre 1950 y {p0}'**
  String mee62fb957a54(String p0);

  /// Elige entre 1 y 200 personas
  ///
  /// In es, this message translates to:
  /// **'Elige entre 1 y 200 personas'**
  String get mc1c4e906b8c5;

  /// Hay integrantes que no existen
  ///
  /// In es, this message translates to:
  /// **'Hay integrantes que no existen'**
  String get mbf473d605c1e;

  /// Este curso lo culminó en la academia. Para cambiarlo, corrige su resultado dentro del curso (pestaña Alumnos)
  ///
  /// In es, this message translates to:
  /// **'Este curso lo culminó en la academia. Para cambiarlo, corrige su resultado dentro del curso (pestaña Alumnos)'**
  String get mde8e8e3b6fe8;

  /// Registro no encontrado
  ///
  /// In es, this message translates to:
  /// **'Registro no encontrado'**
  String get m4fd17b776e90;

  /// Registro eliminado
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado'**
  String get m98aae573223b;

  /// Corrige el resultado en la pestaña Alumnos del curso
  ///
  /// In es, this message translates to:
  /// **'Corrige el resultado en la pestaña Alumnos del curso'**
  String get m2ed1372db9aa;

  /// Año inválido
  ///
  /// In es, this message translates to:
  /// **'Año inválido'**
  String get m244a4a2def12;

  /// La persona ya tiene ese curso y año
  ///
  /// In es, this message translates to:
  /// **'La persona ya tiene ese curso y año'**
  String get mcb409aeb787b;

  /// Curso no encontrado
  ///
  /// In es, this message translates to:
  /// **'Curso no encontrado'**
  String get mea249b4c6938;

  /// No tienes permiso sobre este curso
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso sobre este curso'**
  String get m9e6ef1ec7cc7;

  /// Las notas deben estar entre 0 y {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Las notas deben estar entre 0 y {p0}'**
  String md544c424a006(String p0);

  /// La nota máxima debe estar entre 1 y 1000
  ///
  /// In es, this message translates to:
  /// **'La nota máxima debe estar entre 1 y 1000'**
  String get mbc987e9bff24;

  /// Elige una persona activa con el rol de maestro de escuela bíblica
  ///
  /// In es, this message translates to:
  /// **'Elige una persona activa con el rol de maestro de escuela bíblica'**
  String get me414973f9e63;

  /// El maestro está fuera de tu ámbito
  ///
  /// In es, this message translates to:
  /// **'El maestro está fuera de tu ámbito'**
  String get m51b1b59222d9;

  /// Zona fuera de tu ámbito
  ///
  /// In es, this message translates to:
  /// **'Zona fuera de tu ámbito'**
  String get md263744f6983;

  /// Selecciona un sector a tu cargo para el curso
  ///
  /// In es, this message translates to:
  /// **'Selecciona un sector a tu cargo para el curso'**
  String get m83bc41f0e6b4;

  /// Modalidad inválida
  ///
  /// In es, this message translates to:
  /// **'Modalidad inválida'**
  String get mc4e5b918b06f;

  /// Usa un enlace HTTPS válido para la reunión o ubicación
  ///
  /// In es, this message translates to:
  /// **'Usa un enlace HTTPS válido para la reunión o ubicación'**
  String get m7d527654038b;

  /// El enlace es demasiado largo
  ///
  /// In es, this message translates to:
  /// **'El enlace es demasiado largo'**
  String get m6e528563763d;

  /// Revisa el horario de la clase
  ///
  /// In es, this message translates to:
  /// **'Revisa el horario de la clase'**
  String get m03004817b202;

  /// Zona horaria inválida
  ///
  /// In es, this message translates to:
  /// **'Zona horaria inválida'**
  String get m7ae15470e1e7;

  /// Frecuencia inválida
  ///
  /// In es, this message translates to:
  /// **'Frecuencia inválida'**
  String get m5778674ffc4f;

  /// Ese horario no existe en la zona horaria elegida
  ///
  /// In es, this message translates to:
  /// **'Ese horario no existe en la zona horaria elegida'**
  String get m76126d167b86;

  /// El horario del maestro se está actualizando. Inténtalo de nuevo
  ///
  /// In es, this message translates to:
  /// **'El horario del maestro se está actualizando. Inténtalo de nuevo'**
  String get m9e0b4a5bd61a;

  /// El maestro ya tiene una clase de {{p0}} en ese horario
  ///
  /// In es, this message translates to:
  /// **'El maestro ya tiene una clase de {p0} en ese horario'**
  String mb3559dbb1b3c(String p0);

  /// La reserva del horario venció. Inténtalo de nuevo
  ///
  /// In es, this message translates to:
  /// **'La reserva del horario venció. Inténtalo de nuevo'**
  String get mae1340819970;

  /// No tienes permiso para esta acción
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para esta acción'**
  String get mf9f0c907148f;

  /// Sector no encontrado
  ///
  /// In es, this message translates to:
  /// **'Sector no encontrado'**
  String get mf7809c492088;

  /// No tienes acceso a este sector
  ///
  /// In es, this message translates to:
  /// **'No tienes acceso a este sector'**
  String get ma24f326f8d5a;

  /// Célula no encontrada
  ///
  /// In es, this message translates to:
  /// **'Célula no encontrada'**
  String get maf7ec8c1150f;

  /// No tienes permiso sobre esta célula
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso sobre esta célula'**
  String get m9554da5bc656;

  /// No puedes registrar asistencias futuras
  ///
  /// In es, this message translates to:
  /// **'No puedes registrar asistencias futuras'**
  String get mdd43d9cb3a66;

  /// Cada asistencia debe indicar presente o ausente
  ///
  /// In es, this message translates to:
  /// **'Cada asistencia debe indicar presente o ausente'**
  String get m89451371fe41;

  /// Hay integrantes duplicados en la reunión
  ///
  /// In es, this message translates to:
  /// **'Hay integrantes duplicados en la reunión'**
  String get mc2c1487c247f;

  /// Hay integrantes que no pertenecen a la célula o no están activos
  ///
  /// In es, this message translates to:
  /// **'Hay integrantes que no pertenecen a la célula o no están activos'**
  String get mac5a010eaa77;

  /// Un integrante ya tiene asistencia registrada en otra célula ese día. Su historial no se sobrescribirá.
  ///
  /// In es, this message translates to:
  /// **'Un integrante ya tiene asistencia registrada en otra célula ese día. Su historial no se sobrescribirá.'**
  String get md27a62bd3158;

  /// La asistencia cambió en otra célula. Recarga antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'La asistencia cambió en otra célula. Recarga antes de guardar.'**
  String get m602e8ccae3be;

  /// El período debe estar ordenado y abarcar como máximo 366 días
  ///
  /// In es, this message translates to:
  /// **'El período debe estar ordenado y abarcar como máximo 366 días'**
  String get mc46b11838c0a;

  /// Página inválida
  ///
  /// In es, this message translates to:
  /// **'Página inválida'**
  String get m50e3f5fc7bc6;

  /// Búsqueda inválida
  ///
  /// In es, this message translates to:
  /// **'Búsqueda inválida'**
  String get m56255fb989ba;

  /// Este integrante no tiene registros en esta célula durante el período
  ///
  /// In es, this message translates to:
  /// **'Este integrante no tiene registros en esta célula durante el período'**
  String get m2ab411996669;

  /// No se pudo verificar la cuenta.
  ///
  /// In es, this message translates to:
  /// **'No se pudo verificar la cuenta.'**
  String get m7c1f267c1b73;

  /// Confirma con la misma cuenta de Google que quieres eliminar.
  ///
  /// In es, this message translates to:
  /// **'Confirma con la misma cuenta de Google que quieres eliminar.'**
  String get m94fe25c9ac61;

  /// No se pudo verificar la cuenta. Revisa tu correo y contraseña.
  ///
  /// In es, this message translates to:
  /// **'No se pudo verificar la cuenta. Revisa tu correo y contraseña.'**
  String get mf6a7e428a78c;

  /// Confirma con la misma cuenta de Google que usas en SheepLink.
  ///
  /// In es, this message translates to:
  /// **'Confirma con la misma cuenta de Google que usas en SheepLink.'**
  String get m3908338baa82;

  /// La contraseña no es correcta. Confirma tu identidad para eliminar la cuenta.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no es correcta. Confirma tu identidad para eliminar la cuenta.'**
  String get mce656101b2d4;

  /// La cuenta de administración de plataforma no se elimina desde este flujo.
  ///
  /// In es, this message translates to:
  /// **'La cuenta de administración de plataforma no se elimina desde este flujo.'**
  String get m8593776fdc58;

  /// Confirma que quieres eliminar tu cuenta.
  ///
  /// In es, this message translates to:
  /// **'Confirma que quieres eliminar tu cuenta.'**
  String get md3000f338319;

  /// Hay otra eliminación en curso. Intenta de nuevo más tarde.
  ///
  /// In es, this message translates to:
  /// **'Hay otra eliminación en curso. Intenta de nuevo más tarde.'**
  String get mccf10ad90976;

  /// Elige un nuevo propietario y confirma el traspaso antes de eliminar tu cuenta.
  ///
  /// In es, this message translates to:
  /// **'Elige un nuevo propietario y confirma el traspaso antes de eliminar tu cuenta.'**
  String get m60e9ce79588c;

  /// Elige otro integrante activo de tu iglesia.
  ///
  /// In es, this message translates to:
  /// **'Elige otro integrante activo de tu iglesia.'**
  String get m698d9310df05;

  /// Sesión requerida
  ///
  /// In es, this message translates to:
  /// **'Sesión requerida'**
  String get m2f6d81e0db44;

  /// Token inválido o expirado
  ///
  /// In es, this message translates to:
  /// **'Token inválido o expirado'**
  String get m0dfd46bdd5e2;

  /// Usuario no válido
  ///
  /// In es, this message translates to:
  /// **'Usuario no válido'**
  String get me2c9720d03a3;

  /// No tienes permiso para administrar la plataforma
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para administrar la plataforma'**
  String get m798e54e760d7;

  /// Selecciona una iglesia desde el panel de administración
  ///
  /// In es, this message translates to:
  /// **'Selecciona una iglesia desde el panel de administración'**
  String get m7512dc6cb77e;

  /// Solo el administrador de plataforma puede acceder
  ///
  /// In es, this message translates to:
  /// **'Solo el administrador de plataforma puede acceder'**
  String get m827a60f8ec71;

  /// Tu cuenta no pertenece a ninguna iglesia
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta no pertenece a ninguna iglesia'**
  String get mdc7060215e05;

  /// Elige un plan para activar tu iglesia.
  ///
  /// In es, this message translates to:
  /// **'Elige un plan para activar tu iglesia.'**
  String get mffe4202a751e;

  /// Tu iglesia está suspendida. Contacta al administrador de la plataforma.
  ///
  /// In es, this message translates to:
  /// **'Tu iglesia está suspendida. Contacta al administrador de la plataforma.'**
  String get m78235a837140;

  /// Tu cuenta se ha eliminado.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta se ha eliminado.'**
  String get m75ae869f3e9a;

  /// Demasiados intentos, intenta de nuevo en unos minutos
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos, intenta de nuevo en unos minutos'**
  String get m62724cfd7301;

  /// Demasiados registros desde tu conexión. Intenta más tarde.
  ///
  /// In es, this message translates to:
  /// **'Demasiados registros desde tu conexión. Intenta más tarde.'**
  String get mdcb8562a5d77;

  /// Escribe un correo válido
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido'**
  String get m9cd5be97318e;

  /// La contraseña debe tener al menos 8 caracteres
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get m31a90f01f968;

  /// La contraseña es demasiado larga (máximo 128 caracteres)
  ///
  /// In es, this message translates to:
  /// **'La contraseña es demasiado larga (máximo 128 caracteres)'**
  String get mec21c22c8e26;

  /// Invitación no válida
  ///
  /// In es, this message translates to:
  /// **'Invitación no válida'**
  String get ma767a0a037fb;

  /// Esta invitación ya no es válida. Pide a tu administrador que te envíe una nueva.
  ///
  /// In es, this message translates to:
  /// **'Esta invitación ya no es válida. Pide a tu administrador que te envíe una nueva.'**
  String get m40e2f6a950b9;

  /// La invitación venció. Pide a tu administrador que te la reenvíe.
  ///
  /// In es, this message translates to:
  /// **'La invitación venció. Pide a tu administrador que te la reenvíe.'**
  String get m228876529129;

  /// Correo y contraseña requeridos
  ///
  /// In es, this message translates to:
  /// **'Correo y contraseña requeridos'**
  String get mc54d410b1b37;

  /// Credenciales incorrectas
  ///
  /// In es, this message translates to:
  /// **'Credenciales incorrectas'**
  String get m2486649f3fd7;

  /// Ya existe una cuenta con ese correo. Inicia sesión.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con ese correo. Inicia sesión.'**
  String get m4756a46c494e;

  /// Espera {{p0}} s antes de pedir otro código
  ///
  /// In es, this message translates to:
  /// **'Espera {p0} s antes de pedir otro código'**
  String m0fcfbe32001b(String p0);

  /// Tu registro venció. Vuelve a completar el formulario.
  ///
  /// In es, this message translates to:
  /// **'Tu registro venció. Vuelve a completar el formulario.'**
  String get mcd0e38caff52;

  /// Llegaste al máximo de reenvíos. Intenta de nuevo en una hora.
  ///
  /// In es, this message translates to:
  /// **'Llegaste al máximo de reenvíos. Intenta de nuevo en una hora.'**
  String get mb4a273c5e709;

  /// El código tiene 6 números
  ///
  /// In es, this message translates to:
  /// **'El código tiene 6 números'**
  String get mcb54630abdb5;

  /// Vuelve a completar el registro y acepta los documentos legales.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a completar el registro y acepta los documentos legales.'**
  String get m3b1b7bda5fe8;

  /// El código venció. Pide uno nuevo.
  ///
  /// In es, this message translates to:
  /// **'El código venció. Pide uno nuevo.'**
  String get m83642d819f3e;

  /// Demasiados intentos con este código. Pide uno nuevo.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos con este código. Pide uno nuevo.'**
  String get m3044a07559ee;

  /// Esta invitación ya fue utilizada. Inicia sesión.
  ///
  /// In es, this message translates to:
  /// **'Esta invitación ya fue utilizada. Inicia sesión.'**
  String get m5dcaa994b3de;

  /// Usa el correo de tu cuenta de SHEEPLINK. Si recibiste una invitación, acéptala primero.
  ///
  /// In es, this message translates to:
  /// **'Usa el correo de tu cuenta de SHEEPLINK. Si recibiste una invitación, acéptala primero.'**
  String get m18ec7be6367a;

  /// Este acceso de Google no corresponde a tu cuenta
  ///
  /// In es, this message translates to:
  /// **'Este acceso de Google no corresponde a tu cuenta'**
  String get m9baa7821dbbe;

  /// Tu iglesia no está disponible. Contacta a su responsable.
  ///
  /// In es, this message translates to:
  /// **'Tu iglesia no está disponible. Contacta a su responsable.'**
  String get mdac846fce706;

  /// Hay una actualización de facturación en curso. Intenta de nuevo.
  ///
  /// In es, this message translates to:
  /// **'Hay una actualización de facturación en curso. Intenta de nuevo.'**
  String get mbbc673073953;

  /// La suscripción tiene una estructura no admitida
  ///
  /// In es, this message translates to:
  /// **'La suscripción tiene una estructura no admitida'**
  String get m7e8c2ebb35bb;

  /// Periodo de facturación inválido
  ///
  /// In es, this message translates to:
  /// **'Periodo de facturación inválido'**
  String get mfa4596bac162;

  /// Los pagos todavía no están disponibles. Tu cuenta conserva su estado actual.
  ///
  /// In es, this message translates to:
  /// **'Los pagos todavía no están disponibles. Tu cuenta conserva su estado actual.'**
  String get mb11ab5d4e00e;

  /// Plan no válido
  ///
  /// In es, this message translates to:
  /// **'Plan no válido'**
  String get m1ea7603de191;

  /// Precio de Stripe no reconocido
  ///
  /// In es, this message translates to:
  /// **'Precio de Stripe no reconocido'**
  String get m14852c5fe8bc;

  /// El plan no está disponible temporalmente.
  ///
  /// In es, this message translates to:
  /// **'El plan no está disponible temporalmente.'**
  String get m844655f5bece;

  /// Solo el responsable de la cuenta puede gestionar su facturación
  ///
  /// In es, this message translates to:
  /// **'Solo el responsable de la cuenta puede gestionar su facturación'**
  String get mfc7dfb07fc88;

  /// Iglesia no encontrada
  ///
  /// In es, this message translates to:
  /// **'Iglesia no encontrada'**
  String get m446d8b343b71;

  /// Esta iglesia no puede contratar una suscripción
  ///
  /// In es, this message translates to:
  /// **'Esta iglesia no puede contratar una suscripción'**
  String get ma45fed82562f;

  /// Ya existe una suscripción. Adminístrala desde el portal de Stripe.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una suscripción. Adminístrala desde el portal de Stripe.'**
  String get mf694720f2f41;

  /// Estamos confirmando tu suscripción. Actualiza el estado en unos instantes.
  ///
  /// In es, this message translates to:
  /// **'Estamos confirmando tu suscripción. Actualiza el estado en unos instantes.'**
  String get mee3898228ed6;

  /// Stripe no devolvió el enlace de pago
  ///
  /// In es, this message translates to:
  /// **'Stripe no devolvió el enlace de pago'**
  String get mfc4c7f5375f8;

  /// Acción de facturación inválida
  ///
  /// In es, this message translates to:
  /// **'Acción de facturación inválida'**
  String get mfa78c2821a6a;

  /// Todavía no hay una cuenta de facturación
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay una cuenta de facturación'**
  String get mcb8739839e7d;

  /// No hay una suscripción para administrar
  ///
  /// In es, this message translates to:
  /// **'No hay una suscripción para administrar'**
  String get m6f3d1640a6e2;

  /// El plan requiere una acción de cambio
  ///
  /// In es, this message translates to:
  /// **'El plan requiere una acción de cambio'**
  String get m60a7a727c7e2;

  /// Suscripción no compatible
  ///
  /// In es, this message translates to:
  /// **'Suscripción no compatible'**
  String get ma508f09f5299;

  /// Elige un plan con capacidad igual o superior
  ///
  /// In es, this message translates to:
  /// **'Elige un plan con capacidad igual o superior'**
  String get m8ae7457b37d5;

  /// El cambio anual no está disponible temporalmente
  ///
  /// In es, this message translates to:
  /// **'El cambio anual no está disponible temporalmente'**
  String get m7525423e9bba;

  /// Suscripción sin vínculo válido a la iglesia
  ///
  /// In es, this message translates to:
  /// **'Suscripción sin vínculo válido a la iglesia'**
  String get m8f961ba4a733;

  /// Hay más de una suscripción para esta iglesia
  ///
  /// In es, this message translates to:
  /// **'Hay más de una suscripción para esta iglesia'**
  String get mf9527baa5d0c;

  /// La prueba requiere una tarjeta confirmada.
  ///
  /// In es, this message translates to:
  /// **'La prueba requiere una tarjeta confirmada.'**
  String get mf55d841885cf;

  /// El evento no pertenece al modo de Stripe configurado
  ///
  /// In es, this message translates to:
  /// **'El evento no pertenece al modo de Stripe configurado'**
  String get m3630c815a01a;

  /// Firma de Stripe requerida
  ///
  /// In es, this message translates to:
  /// **'Firma de Stripe requerida'**
  String get m857a74d28d6c;

  /// Firma de Stripe no válida
  ///
  /// In es, this message translates to:
  /// **'Firma de Stripe no válida'**
  String get m7f217f376e41;

  /// Página no encontrada
  ///
  /// In es, this message translates to:
  /// **'Página no encontrada'**
  String get m66d468d4451f;

  /// Publicación no encontrada
  ///
  /// In es, this message translates to:
  /// **'Publicación no encontrada'**
  String get mf3c1f4c307d0;

  /// Conexión de redes no disponible
  ///
  /// In es, this message translates to:
  /// **'Conexión de redes no disponible'**
  String get m49cc112fd429;

  /// No se pudo consultar n8n. Intenta de nuevo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo consultar n8n. Intenta de nuevo.'**
  String get m50f50cec38f2;

  /// Respuesta de redes inválida
  ///
  /// In es, this message translates to:
  /// **'Respuesta de redes inválida'**
  String get m4974f35a6516;

  /// Usa letras minúsculas, números y guiones en la dirección
  ///
  /// In es, this message translates to:
  /// **'Usa letras minúsculas, números y guiones en la dirección'**
  String get mcbf331937a65;

  /// Portada inválida
  ///
  /// In es, this message translates to:
  /// **'Portada inválida'**
  String get m11b0b7aa2b97;

  /// La portada debe tener una dirección HTTPS pública
  ///
  /// In es, this message translates to:
  /// **'La portada debe tener una dirección HTTPS pública'**
  String get m8a6b1c85d7c8;

  /// Describe la imagen de portada
  ///
  /// In es, this message translates to:
  /// **'Describe la imagen de portada'**
  String get m0a532511843d;

  /// Escribe el contenido del artículo
  ///
  /// In es, this message translates to:
  /// **'Escribe el contenido del artículo'**
  String get m9b10d6a7b52b;

  /// La publicación cambió. Vuelve a abrirla.
  ///
  /// In es, this message translates to:
  /// **'La publicación cambió. Vuelve a abrirla.'**
  String get m36302fae4411;

  /// La dirección se conserva después de publicar para proteger los enlaces
  ///
  /// In es, this message translates to:
  /// **'La dirección se conserva después de publicar para proteger los enlaces'**
  String get md802b379af93;

  /// El integrante no está activo
  ///
  /// In es, this message translates to:
  /// **'El integrante no está activo'**
  String get m9c0a924a068c;

  /// La cuenta vinculada al siervo no está disponible
  ///
  /// In es, this message translates to:
  /// **'La cuenta vinculada al siervo no está disponible'**
  String get m7b4758b5b5cf;

  /// Selecciona hasta 30 células
  ///
  /// In es, this message translates to:
  /// **'Selecciona hasta 30 células'**
  String get m5e93fcb92616;

  /// La célula está desactivada
  ///
  /// In es, this message translates to:
  /// **'La célula está desactivada'**
  String get ma9787c32b52e;

  /// Una célula ya tiene un encuentro ese día. Edita el itinerario existente primero
  ///
  /// In es, this message translates to:
  /// **'Una célula ya tiene un encuentro ese día. Edita el itinerario existente primero'**
  String get mfad75f601418;

  /// Los responsables deben pertenecer a las células participantes
  ///
  /// In es, this message translates to:
  /// **'Los responsables deben pertenecer a las células participantes'**
  String get ma12bdbbb8cdb;

  /// Versión inválida
  ///
  /// In es, this message translates to:
  /// **'Versión inválida'**
  String get mc36e423a0e36;

  /// Otra persona guardó cambios. Recarga el itinerario
  ///
  /// In es, this message translates to:
  /// **'Otra persona guardó cambios. Recarga el itinerario'**
  String get m8b93fa30bc85;

  /// Otra persona actualizó el itinerario. Recarga antes de guardar
  ///
  /// In es, this message translates to:
  /// **'Otra persona actualizó el itinerario. Recarga antes de guardar'**
  String get mb70758837c83;

  /// Perfil de iglesia no encontrado
  ///
  /// In es, this message translates to:
  /// **'Perfil de iglesia no encontrado'**
  String get m6526d1ea1d0e;

  /// El fin debe ser posterior al inicio
  ///
  /// In es, this message translates to:
  /// **'El fin debe ser posterior al inicio'**
  String get mb4edec093f2e;

  /// Disciplina no encontrada
  ///
  /// In es, this message translates to:
  /// **'Disciplina no encontrada'**
  String get me72812bcf9d5;

  /// Perfil no encontrado
  ///
  /// In es, this message translates to:
  /// **'Perfil no encontrado'**
  String get mbc8b030d8f6f;

  /// Integrante no encontrado
  ///
  /// In es, this message translates to:
  /// **'Integrante no encontrado'**
  String get m872c013ad096;

  /// El itinerario admite hasta 100 actividades
  ///
  /// In es, this message translates to:
  /// **'El itinerario admite hasta 100 actividades'**
  String get m7ae28aa34f8e;

  /// Actividad inválida
  ///
  /// In es, this message translates to:
  /// **'Actividad inválida'**
  String get m6592f49dae72;

  /// Actividad duplicada
  ///
  /// In es, this message translates to:
  /// **'Actividad duplicada'**
  String get ma225c44c0b9b;

  /// Indica si la actividad se realizará
  ///
  /// In es, this message translates to:
  /// **'Indica si la actividad se realizará'**
  String get m65aaf20dbdbe;

  /// La duración debe estar entre 1 y 480 minutos
  ///
  /// In es, this message translates to:
  /// **'La duración debe estar entre 1 y 480 minutos'**
  String get m09511e491729;

  /// Cada usuario registra su propio devocional
  ///
  /// In es, this message translates to:
  /// **'Cada usuario registra su propio devocional'**
  String get m0df69e3121ef;

  /// Solo el líder o apoyo registra devocionales de personas sin cuenta
  ///
  /// In es, this message translates to:
  /// **'Solo el líder o apoyo registra devocionales de personas sin cuenta'**
  String get mb384242d9130;

  /// No tienes permiso para revisar devocionales
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para revisar devocionales'**
  String get me1f05510b93c;

  /// Célula fuera de tu responsabilidad
  ///
  /// In es, this message translates to:
  /// **'Célula fuera de tu responsabilidad'**
  String get m1e71bfb8ffae;

  /// Selecciona un rol disponible
  ///
  /// In es, this message translates to:
  /// **'Selecciona un rol disponible'**
  String get m85c7ca4c2ce8;

  /// No puedes consultar el diario de esta persona
  ///
  /// In es, this message translates to:
  /// **'No puedes consultar el diario de esta persona'**
  String get m268d81106121;

  /// El diario personal del pastor es privado
  ///
  /// In es, this message translates to:
  /// **'El diario personal del pastor es privado'**
  String get meded344361f7;

  /// No puedes registrar días futuros
  ///
  /// In es, this message translates to:
  /// **'No puedes registrar días futuros'**
  String get mdaadfad2f3e1;

  /// Otra persona cambió las actividades habituales. Recarga antes de guardar
  ///
  /// In es, this message translates to:
  /// **'Otra persona cambió las actividades habituales. Recarga antes de guardar'**
  String get m504e3384291d;

  /// Registra el bautismo antes de programar a esta persona para servir
  ///
  /// In es, this message translates to:
  /// **'Registra el bautismo antes de programar a esta persona para servir'**
  String get m37dece671318;

  /// La cuenta del siervo está suspendida
  ///
  /// In es, this message translates to:
  /// **'La cuenta del siervo está suspendida'**
  String get m13543eef4a62;

  /// Este siervo tiene una disciplina. Usa fechas concretas fuera del período indicado
  ///
  /// In es, this message translates to:
  /// **'Este siervo tiene una disciplina. Usa fechas concretas fuera del período indicado'**
  String get m9b7b41693bed;

  /// En disciplina el {{p0}}. Un responsable autorizado debe levantar la disciplina para habilitar el servicio
  ///
  /// In es, this message translates to:
  /// **'En disciplina el {p0}. Un responsable autorizado debe levantar la disciplina para habilitar el servicio'**
  String m26567d570396(String p0);

  /// La semana debe comenzar en lunes
  ///
  /// In es, this message translates to:
  /// **'La semana debe comenzar en lunes'**
  String get m7ccd7ba7fdc4;

  /// Guarda la asistencia de esta reunión antes de añadir su foto
  ///
  /// In es, this message translates to:
  /// **'Guarda la asistencia de esta reunión antes de añadir su foto'**
  String get md765cd8d90e5;

  /// El tema debe tener como máximo 120 caracteres
  ///
  /// In es, this message translates to:
  /// **'El tema debe tener como máximo 120 caracteres'**
  String get m349cc3d055d1;

  /// Esta semana ya tiene otra fecha de reunión registrada
  ///
  /// In es, this message translates to:
  /// **'Esta semana ya tiene otra fecha de reunión registrada'**
  String get m51bf99745417;

  /// La reunión cambió. Actualiza esta semana antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'La reunión cambió. Actualiza esta semana antes de guardar.'**
  String get me02514c88abd;

  /// Semana inválida
  ///
  /// In es, this message translates to:
  /// **'Semana inválida'**
  String get mb4f5319c61ca;

  /// Esta semana aún no tiene foto
  ///
  /// In es, this message translates to:
  /// **'Esta semana aún no tiene foto'**
  String get mdf2993131280;

  /// Usuario de iglesia no encontrado
  ///
  /// In es, this message translates to:
  /// **'Usuario de iglesia no encontrado'**
  String get maa80384b1b97;

  /// El perfil de integrante debe reactivarse antes de agregarlo
  ///
  /// In es, this message translates to:
  /// **'El perfil de integrante debe reactivarse antes de agregarlo'**
  String get me65bf19c19da;

  /// Esta persona asiste a otra célula. Confirma el cambio de su célula de asistencia.
  ///
  /// In es, this message translates to:
  /// **'Esta persona asiste a otra célula. Confirma el cambio de su célula de asistencia.'**
  String get md35ff95c82c8;

  /// La célula de asistencia cambió. Recarga antes de continuar
  ///
  /// In es, this message translates to:
  /// **'La célula de asistencia cambió. Recarga antes de continuar'**
  String get m606201b8c0b5;

  /// Esta persona ya tiene un perfil. Recarga la célula
  ///
  /// In es, this message translates to:
  /// **'Esta persona ya tiene un perfil. Recarga la célula'**
  String get m844dcf8a7bdb;

  /// Foto de perfil no encontrada
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil no encontrada'**
  String get mb3b8e9737103;

  /// Indica la hora de reunión de la célula
  ///
  /// In es, this message translates to:
  /// **'Indica la hora de reunión de la célula'**
  String get m2ba89fc51dc3;

  /// La hora de fin debe ser posterior al inicio
  ///
  /// In es, this message translates to:
  /// **'La hora de fin debe ser posterior al inicio'**
  String get mad43ebe0c8f4;

  /// La reunión no pertenece a esta semana
  ///
  /// In es, this message translates to:
  /// **'La reunión no pertenece a esta semana'**
  String get m2c1bdbeb6681;

  /// No puedes registrar una reunión futura
  ///
  /// In es, this message translates to:
  /// **'No puedes registrar una reunión futura'**
  String get m4508f4bfb8ff;

  /// Zona no encontrada
  ///
  /// In es, this message translates to:
  /// **'Zona no encontrada'**
  String get m9e7af05f14ad;

  /// Zona fuera de tu alcance
  ///
  /// In es, this message translates to:
  /// **'Zona fuera de tu alcance'**
  String get m8f1dc62de31e;

  /// Día inválido
  ///
  /// In es, this message translates to:
  /// **'Día inválido'**
  String get m4efbc1478146;

  /// No puedes mover células fuera de tu ámbito
  ///
  /// In es, this message translates to:
  /// **'No puedes mover células fuera de tu ámbito'**
  String get m5bdb1fdc699a;

  /// No puedes reactivar la célula: su zona está desactivada. Reactiva la zona primero
  ///
  /// In es, this message translates to:
  /// **'No puedes reactivar la célula: su zona está desactivada. Reactiva la zona primero'**
  String get m6dc647b05659;

  /// Célula eliminada por completo
  ///
  /// In es, this message translates to:
  /// **'Célula eliminada por completo'**
  String get m0ce13ae790d1;

  /// Has enviado varias consultas. Espera un minuto e inténtalo de nuevo.
  ///
  /// In es, this message translates to:
  /// **'Has enviado varias consultas. Espera un minuto e inténtalo de nuevo.'**
  String get m63ad0a054ff7;

  /// Si encuentras un bug o error, envía una solicitud desde Cuenta y ayuda → Contactar soporte o abre esta página: https://app.sheeplink.app/soporte. Si no puedes entrar, escríbenos a krecarfaz@gmail.com o por WhatsApp al +51 981 427 532: https://wa.me/51981427532?text=Hola%2C%20necesito%20ayuda%20con%20SHEEPLINK
  ///
  /// In es, this message translates to:
  /// **'Si encuentras un bug o error, envía una solicitud desde Cuenta y ayuda → Contactar soporte o abre esta página: https://app.sheeplink.app/soporte. Si no puedes entrar, escríbenos a krecarfaz@gmail.com o por WhatsApp al +51 981 427 532: https://wa.me/51981427532?text=Hola%2C%20necesito%20ayuda%20con%20SHEEPLINK'**
  String get m10f2c0b8b820;

  /// ¡Hola! Soy el asistente de SHEEPLINK. Puedo orientarte sobre Dashboard, Mi espacio, mensajes, comunidad, organización de la iglesia, formación, actividades, planes y uso desde el celular. Si encuentras un bug o error, te indico cómo contactar soporte. ¿Qué necesitas saber?
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Soy el asistente de SHEEPLINK. Puedo orientarte sobre Dashboard, Mi espacio, mensajes, comunidad, organización de la iglesia, formación, actividades, planes y uso desde el celular. Si encuentras un bug o error, te indico cómo contactar soporte. ¿Qué necesitas saber?'**
  String get me4ec7cfda7f0;

  /// SHEEPLINK tiene planes para distintas necesidades y tamaños de iglesia. Los límites de integrantes, células, ministerios y usuarios dependen del plan. Puedes comparar los precios y revisar qué incluye cada uno aquí: https://sheeplink.app/#precios
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK tiene planes para distintas necesidades y tamaños de iglesia. Los límites de integrantes, células, ministerios y usuarios dependen del plan. Puedes comparar los precios y revisar qué incluye cada uno aquí: https://sheeplink.app/#precios '**
  String get mc8a7a7c9cac6;

  /// En “Facturación” puedes consultar tu plan, la fecha de próxima renovación y los pagos procesados con Stripe. Para revisar o resolver un cobro de tu cuenta, contacta a soporte desde Cuenta y ayuda → Contactar soporte.
  ///
  /// In es, this message translates to:
  /// **'En “Facturación” puedes consultar tu plan, la fecha de próxima renovación y los pagos procesados con Stripe. Para revisar o resolver un cobro de tu cuenta, contacta a soporte desde Cuenta y ayuda → Contactar soporte.'**
  String get m1e0ea0cf3c11;

  /// SHEEPLINK te ayuda a organizar los integrantes de tu iglesia y su relación con las células y zonas. Puedes invitar a los líderes con su propio usuario; cada persona ve la información que corresponde a su rol. El pastor principal puede consultar la estructura general, mientras los líderes acompañan a sus grupos.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK te ayuda a organizar los integrantes de tu iglesia y su relación con las células y zonas. Puedes invitar a los líderes con su propio usuario; cada persona ve la información que corresponde a su rol. El pastor principal puede consultar la estructura general, mientras los líderes acompañan a sus grupos.'**
  String get mcccd88696e38;

  /// En “Invitar a mi iglesia” puedes invitar personas y organizar las responsabilidades de tu equipo. Los accesos y permisos disponibles dependen del rol que les asignes. Si tienes problemas con una invitación, contacta a soporte.
  ///
  /// In es, this message translates to:
  /// **'En “Invitar a mi iglesia” puedes invitar personas y organizar las responsabilidades de tu equipo. Los accesos y permisos disponibles dependen del rol que les asignes. Si tienes problemas con una invitación, contacta a soporte.'**
  String get m1f62bc55f062;

  /// Puedes crear zonas y células para reflejar la estructura de tu iglesia, asignar líderes e invitarlos con su propio usuario. El líder de zona puede acompañar a los líderes de célula y revisar la asistencia de su zona; cada usuario ve lo que le corresponde según su rol.
  ///
  /// In es, this message translates to:
  /// **'Puedes crear zonas y células para reflejar la estructura de tu iglesia, asignar líderes e invitarlos con su propio usuario. El líder de zona puede acompañar a los líderes de célula y revisar la asistencia de su zona; cada usuario ve lo que le corresponde según su rol.'**
  String get m5f38559648aa;

  /// “Estructura de la iglesia” organiza las zonas y las células que pertenecen a cada sector, para que el liderazgo pueda ver cómo están agrupados los equipos y acompañarlos según sus permisos.
  ///
  /// In es, this message translates to:
  /// **'“Estructura de la iglesia” organiza las zonas y las células que pertenecen a cada sector, para que el liderazgo pueda ver cómo están agrupados los equipos y acompañarlos según sus permisos.'**
  String get mb590a2d88775;

  /// Los líderes de célula pueden registrar a sus integrantes y marcar la asistencia cada semana. El líder de zona puede revisar la asistencia de su zona, y el pastor principal puede ver la iglesia completa. Se puede usar desde el navegador del celular, sin instalar nada.
  ///
  /// In es, this message translates to:
  /// **'Los líderes de célula pueden registrar a sus integrantes y marcar la asistencia cada semana. El líder de zona puede revisar la asistencia de su zona, y el pastor principal puede ver la iglesia completa. Se puede usar desde el navegador del celular, sin instalar nada.'**
  String get mede1a0e6a1c7;

  /// Con SHEEPLINK puedes organizar zonas y células, registrar integrantes, revisar asistencias semanales y coordinar turnos de servicio. También reúne devocionales, cursos, actividades y comunidad. Los líderes acceden con su propio usuario y cada rol ve lo que le corresponde. La plataforma web funciona en el navegador de la computadora o del celular.
  ///
  /// In es, this message translates to:
  /// **'Con SHEEPLINK puedes organizar zonas y células, registrar integrantes, revisar asistencias semanales y coordinar turnos de servicio. También reúne devocionales, cursos, actividades y comunidad. Los líderes acceden con su propio usuario y cada rol ve lo que le corresponde. La plataforma web funciona en el navegador de la computadora o del celular.'**
  String get mdab066abf002;

  /// Puedes usar SHEEPLINK desde el navegador de tu celular, sin instalar nada: consultar grupos, registrar asistencia y gestionar tus tareas según tu rol. También está disponible la app para iPhone y iPad en App Store: https://apps.apple.com/pe/app/sheeplink/id6829374579. La app para Android está en preparación y se anunciará cuando esté lista.
  ///
  /// In es, this message translates to:
  /// **'Puedes usar SHEEPLINK desde el navegador de tu celular, sin instalar nada: consultar grupos, registrar asistencia y gestionar tus tareas según tu rol. También está disponible la app para iPhone y iPad en App Store: https://apps.apple.com/pe/app/sheeplink/id6829374579. La app para Android está en preparación y se anunciará cuando esté lista.'**
  String get mef53cce7f652;

  /// SHEEPLINK se puede usar desde el navegador del celular. La app para iPhone y iPad ya está disponible en App Store: https://apps.apple.com/pe/app/sheeplink/id6829374579. La app para Android está en preparación; todavía no hay un enlace de descarga de Google Play.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK se puede usar desde el navegador del celular. La app para iPhone y iPad ya está disponible en App Store: https://apps.apple.com/pe/app/sheeplink/id6829374579. La app para Android está en preparación; todavía no hay un enlace de descarga de Google Play.'**
  String get ma7dbd54363ee;

  /// SHEEPLINK permite registrar y dar seguimiento a los devocionales diarios de los cargos de servicio y liderazgo, incluidos los pastores. Si pasan tres días completos consecutivos sin registro, el responsable directo recibe un aviso para acompañar a la persona. El seguimiento queda a criterio del liderazgo y no suspende automáticamente el servicio.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK permite registrar y dar seguimiento a los devocionales diarios de los cargos de servicio y liderazgo, incluidos los pastores. Si pasan tres días completos consecutivos sin registro, el responsable directo recibe un aviso para acompañar a la persona. El seguimiento queda a criterio del liderazgo y no suspende automáticamente el servicio.'**
  String get m583986165251;

  /// En Mis cursos, cada alumno encuentra sus aulas, materiales y resultados. Los cursos pueden mostrar horarios, fechas, modalidad y ubicación o enlace de reunión; el responsable comparte el formulario de inscripción, que también se puede completar desde el celular. El acceso depende de la inscripción o asignación del responsable.
  ///
  /// In es, this message translates to:
  /// **'En Mis cursos, cada alumno encuentra sus aulas, materiales y resultados. Los cursos pueden mostrar horarios, fechas, modalidad y ubicación o enlace de reunión; el responsable comparte el formulario de inscripción, que también se puede completar desde el celular. El acceso depende de la inscripción o asignación del responsable.'**
  String get m4c5827fc32f3;

  /// La sección Formación reúne Mis cursos y Academia Bíblica. Los alumnos pueden acceder a sus aulas, materiales y resultados; quienes administran cursos pueden organizar alumnos, asistencia semanal y calificaciones. Al terminar, los alumnos aprobados quedan en su historial.
  ///
  /// In es, this message translates to:
  /// **'La sección Formación reúne Mis cursos y Academia Bíblica. Los alumnos pueden acceder a sus aulas, materiales y resultados; quienes administran cursos pueden organizar alumnos, asistencia semanal y calificaciones. Al terminar, los alumnos aprobados quedan en su historial.'**
  String get m260392419aca;

  /// En Actividades puedes consultar encuentros de la iglesia como retiros, campamentos, viajes y otras actividades. Los organizadores pueden crear la actividad y compartir un formulario para que las personas se inscriban, incluso desde el celular y sin crear una cuenta. Según los permisos, también pueden gestionar inscripciones, tareas y presupuesto.
  ///
  /// In es, this message translates to:
  /// **'En Actividades puedes consultar encuentros de la iglesia como retiros, campamentos, viajes y otras actividades. Los organizadores pueden crear la actividad y compartir un formulario para que las personas se inscriban, incluso desde el celular y sin crear una cuenta. Según los permisos, también pueden gestionar inscripciones, tareas y presupuesto.'**
  String get m5338c1be6e49;

  /// El Dashboard muestra un resumen del mes con cifras, asistencia, mensajes y cumpleaños. La información visible depende de tu rol y permisos en la iglesia.
  ///
  /// In es, this message translates to:
  /// **'El Dashboard muestra un resumen del mes con cifras, asistencia, mensajes y cumpleaños. La información visible depende de tu rol y permisos en la iglesia.'**
  String get m858df0d88cca;

  /// “Mi espacio” reúne tu calendario personal y tus devocionales. El contenido disponible depende de tu cuenta y responsabilidades en la iglesia.
  ///
  /// In es, this message translates to:
  /// **'“Mi espacio” reúne tu calendario personal y tus devocionales. El contenido disponible depende de tu cuenta y responsabilidades en la iglesia.'**
  String get m11b2bb4575dc;

  /// En “Mensajes” puedes revisar avisos del pastor y de los líderes. Si esperabas un aviso y no aparece, contacta a soporte e indica qué mensaje esperabas y cuándo.
  ///
  /// In es, this message translates to:
  /// **'En “Mensajes” puedes revisar avisos del pastor y de los líderes. Si esperabas un aviso y no aparece, contacta a soporte e indica qué mensaje esperabas y cuándo.'**
  String get m55f79c50962d;

  /// La sección Comunidad reúne devocionales de la iglesia y de tu célula, además de espacios de foro y redes. Lo que puedes consultar depende de tu cuenta y permisos.
  ///
  /// In es, this message translates to:
  /// **'La sección Comunidad reúne devocionales de la iglesia y de tu célula, además de espacios de foro y redes. Lo que puedes consultar depende de tu cuenta y permisos.'**
  String get m356001c5acde;

  /// “Redes de mi iglesia” permite consultar y configurar los enlaces de redes de la iglesia y sus células. Si un enlace está equivocado o no abre, repórtalo a soporte.
  ///
  /// In es, this message translates to:
  /// **'“Redes de mi iglesia” permite consultar y configurar los enlaces de redes de la iglesia y sus células. Si un enlace está equivocado o no abre, repórtalo a soporte.'**
  String get m8f7e346778b3;

  /// “Consultas” muestra estadísticas y comparativos de asistencia para ayudar a revisar la participación a lo largo del tiempo. Los datos que ves dependen de tu rol y alcance en la iglesia.
  ///
  /// In es, this message translates to:
  /// **'“Consultas” muestra estadísticas y comparativos de asistencia para ayudar a revisar la participación a lo largo del tiempo. Los datos que ves dependen de tu rol y alcance en la iglesia.'**
  String get mae7cb3ee1109;

  /// Para reportar un bug o error, abre directamente Cuenta y ayuda → Contactar soporte: https://app.sheeplink.app/soporte. Describe lo ocurrido e indica los pasos para reproducirlo; desde esa página podrás consultar el estado de tu solicitud. Si no puedes acceder, escríbenos a krecarfaz@gmail.com o por WhatsApp: https://wa.me/51981427532?text=Hola%2C%20quiero%20reportar%20un%20error%20en%20SHEEPLINK
  ///
  /// In es, this message translates to:
  /// **'Para reportar un bug o error, abre directamente Cuenta y ayuda → Contactar soporte: https://app.sheeplink.app/soporte. Describe lo ocurrido e indica los pasos para reproducirlo; desde esa página podrás consultar el estado de tu solicitud. Si no puedes acceder, escríbenos a krecarfaz@gmail.com o por WhatsApp: https://wa.me/51981427532?text=Hola%2C%20quiero%20reportar%20un%20error%20en%20SHEEPLINK'**
  String get m2a8f6ebbc9c0;

  /// En Ministerios puedes organizar las áreas de servicio, sus líderes y servidores. Programa turnos para un día de la semana o una fecha específica, consulta quiénes sirven próximamente y revisa el historial de turnos. Cada servidor puede gestionar los turnos de su ministerio según los permisos de su cuenta.
  ///
  /// In es, this message translates to:
  /// **'En Ministerios puedes organizar las áreas de servicio, sus líderes y servidores. Programa turnos para un día de la semana o una fecha específica, consulta quiénes sirven próximamente y revisa el historial de turnos. Cada servidor puede gestionar los turnos de su ministerio según los permisos de su cuenta.'**
  String get m18253c314fee;

  /// Tesorería reúne diezmos, ofrendas, cuentas, ingresos y gastos en un solo lugar. Los usuarios autorizados pueden registrar y corregir movimientos, revisar períodos y consultar informes; el acceso depende del rol: owner y tesorero registran movimientos y el pastor puede consultar. Para dudas sobre permisos o configuración, contáctanos.
  ///
  /// In es, this message translates to:
  /// **'Tesorería reúne diezmos, ofrendas, cuentas, ingresos y gastos en un solo lugar. Los usuarios autorizados pueden registrar y corregir movimientos, revisar períodos y consultar informes; el acceso depende del rol: owner y tesorero registran movimientos y el pastor puede consultar. Para dudas sobre permisos o configuración, contáctanos.'**
  String get mcbe602695f4b;

  /// Puedo orientarte sobre Dashboard, Mi espacio, mensajes, devocionales, comunidad y redes, células, integrantes, asistencias, ministerios y turnos, invitaciones, estructura de la iglesia, tesorería, consultas, formación, cursos, actividades, facturación, uso desde el celular y planes. Si encuentras un bug o error, te indico cómo contactar soporte. ¿Qué tema necesitas?
  ///
  /// In es, this message translates to:
  /// **'Puedo orientarte sobre Dashboard, Mi espacio, mensajes, devocionales, comunidad y redes, células, integrantes, asistencias, ministerios y turnos, invitaciones, estructura de la iglesia, tesorería, consultas, formación, cursos, actividades, facturación, uso desde el celular y planes. Si encuentras un bug o error, te indico cómo contactar soporte. ¿Qué tema necesitas?'**
  String get m3f16fb802976;

  /// ¡Hola! Soy el asistente de SHEEPLINK. Puedo orientarte sobre funciones, grupos, asistencia, planes y contacto. ¿Qué necesitas saber?
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Soy el asistente de SHEEPLINK. Puedo orientarte sobre funciones, grupos, asistencia, planes y contacto. ¿Qué necesitas saber?'**
  String get ma6404ea5e40c;

  /// Puedes reportar bugs y errores al equipo de soporte.
  ///
  /// In es, this message translates to:
  /// **'Puedes reportar bugs y errores al equipo de soporte.'**
  String get mc1694a077a1d;

  /// En Facturación puedes consultar tu plan, renovación y pagos.
  ///
  /// In es, this message translates to:
  /// **'En Facturación puedes consultar tu plan, renovación y pagos.'**
  String get m3225c307e40e;

  /// Los planes y precios de SHEEPLINK se muestran en la página de planes. Para una cotización o ayuda con tu caso, escríbenos a krecarfaz@gmail.com o por WhatsApp al +51 981 427 532.
  ///
  /// In es, this message translates to:
  /// **'Los planes y precios de SHEEPLINK se muestran en la página de planes. Para una cotización o ayuda con tu caso, escríbenos a krecarfaz@gmail.com o por WhatsApp al +51 981 427 532.'**
  String get m92107c82c11d;

  /// El Dashboard muestra el resumen de la iglesia.
  ///
  /// In es, this message translates to:
  /// **'El Dashboard muestra el resumen de la iglesia.'**
  String get m63e176dad6d6;

  /// Mi espacio reúne tu calendario y devocionales.
  ///
  /// In es, this message translates to:
  /// **'Mi espacio reúne tu calendario y devocionales.'**
  String get m72e6ac525546;

  /// En Mensajes puedes revisar avisos de tus líderes.
  ///
  /// In es, this message translates to:
  /// **'En Mensajes puedes revisar avisos de tus líderes.'**
  String get ma5d2604f09ca;

  /// Puedes consultar las redes de tu iglesia y sus células.
  ///
  /// In es, this message translates to:
  /// **'Puedes consultar las redes de tu iglesia y sus células.'**
  String get mf6099b02d6cb;

  /// La sección Comunidad reúne devocionales, foro y redes.
  ///
  /// In es, this message translates to:
  /// **'La sección Comunidad reúne devocionales, foro y redes.'**
  String get m47c99375f32f;

  /// Puedes invitar personas a tu iglesia y organizar sus responsabilidades.
  ///
  /// In es, this message translates to:
  /// **'Puedes invitar personas a tu iglesia y organizar sus responsabilidades.'**
  String get mc264b577a044;

  /// La estructura organiza las zonas y células de la iglesia.
  ///
  /// In es, this message translates to:
  /// **'La estructura organiza las zonas y células de la iglesia.'**
  String get mebce5fa23472;

  /// Consultas muestra estadísticas y comparativos de asistencia.
  ///
  /// In es, this message translates to:
  /// **'Consultas muestra estadísticas y comparativos de asistencia.'**
  String get m952bd58a321b;

  /// SHEEPLINK ayuda a organizar la información de los miembros de tu iglesia. Para detalles de configuración de tu cuenta, contáctanos en krecarfaz@gmail.com.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK ayuda a organizar la información de los miembros de tu iglesia. Para detalles de configuración de tu cuenta, contáctanos en krecarfaz@gmail.com.'**
  String get m300ddf70a7b4;

  /// Puedes organizar células o grupos y consultar su información desde SHEEPLINK. Si necesitas ayuda para configurarlos, escríbenos a krecarfaz@gmail.com o al WhatsApp +51 981 427 532.
  ///
  /// In es, this message translates to:
  /// **'Puedes organizar células o grupos y consultar su información desde SHEEPLINK. Si necesitas ayuda para configurarlos, escríbenos a krecarfaz@gmail.com o al WhatsApp +51 981 427 532.'**
  String get me858747ef76b;

  /// SHEEPLINK permite llevar el control de asistencia. Para resolver dudas sobre el registro en tu iglesia, contáctanos en krecarfaz@gmail.com.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK permite llevar el control de asistencia. Para resolver dudas sobre el registro en tu iglesia, contáctanos en krecarfaz@gmail.com.'**
  String get m3c1a79cd5bc4;

  /// SHEEPLINK incluye registro y seguimiento de devocionales.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK incluye registro y seguimiento de devocionales.'**
  String get ma57577f6711e;

  /// SHEEPLINK cuenta con formación y Academia Bíblica.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK cuenta con formación y Academia Bíblica.'**
  String get m00b6dc341e5d;

  /// SHEEPLINK incluye cursos y aulas para alumnos.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK incluye cursos y aulas para alumnos.'**
  String get m7b6e634da378;

  /// SHEEPLINK permite organizar actividades e inscripciones.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK permite organizar actividades e inscripciones.'**
  String get md09ff4a80b1a;

  /// SHEEPLINK incluye herramientas de tesorería.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK incluye herramientas de tesorería.'**
  String get m3ff87a703d71;

  /// SHEEPLINK permite organizar ministerios y turnos de servicio.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK permite organizar ministerios y turnos de servicio.'**
  String get m1215455f26bf;

  /// SHEEPLINK reúne herramientas para organizar la iglesia, sus zonas y células, integrantes, asistencia y turnos de servicio.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK reúne herramientas para organizar la iglesia, sus zonas y células, integrantes, asistencia y turnos de servicio.'**
  String get mddcdc3bb9121;

  /// SHEEPLINK está pensado para usarse también desde dispositivos móviles. Si algo no carga bien en tu teléfono, indícanos el modelo y navegador por correo a krecarfaz@gmail.com.
  ///
  /// In es, this message translates to:
  /// **'SHEEPLINK está pensado para usarse también desde dispositivos móviles. Si algo no carga bien en tu teléfono, indícanos el modelo y navegador por correo a krecarfaz@gmail.com.'**
  String get m12cafb85c35c;

  /// Puedes contactar al equipo en krecarfaz@gmail.com o por WhatsApp al +51 981 427 532.
  ///
  /// In es, this message translates to:
  /// **'Puedes contactar al equipo en krecarfaz@gmail.com o por WhatsApp al +51 981 427 532.'**
  String get m176efef19731;

  /// Escribe una consulta de hasta 500 caracteres.
  ///
  /// In es, this message translates to:
  /// **'Escribe una consulta de hasta 500 caracteres.'**
  String get ma3486b4b566b;

  /// Días de prueba inválidos (0 a 365)
  ///
  /// In es, this message translates to:
  /// **'Días de prueba inválidos (0 a 365)'**
  String get m5bbc47ac8f4d;

  /// Ya existe un usuario con ese correo
  ///
  /// In es, this message translates to:
  /// **'Ya existe un usuario con ese correo'**
  String get m8627a2bbbdaa;

  /// Segundo usuario inválido
  ///
  /// In es, this message translates to:
  /// **'Segundo usuario inválido'**
  String get m691e015203b7;

  /// Las cuentas de prueba requieren una iglesia temporal con bloqueo al vencer
  ///
  /// In es, this message translates to:
  /// **'Las cuentas de prueba requieren una iglesia temporal con bloqueo al vencer'**
  String get m0e6eb2575dcb;

  /// El segundo correo ya está en uso
  ///
  /// In es, this message translates to:
  /// **'El segundo correo ya está en uso'**
  String get m0e4cdbbb2d37;

  /// El periodo pagado se confirma desde Stripe.
  ///
  /// In es, this message translates to:
  /// **'El periodo pagado se confirma desde Stripe.'**
  String get m3f9e5b4dbb14;

  /// exempt debe ser verdadero o falso
  ///
  /// In es, this message translates to:
  /// **'exempt debe ser verdadero o falso'**
  String get ma55774647b66;

  /// La iglesia no está suspendida
  ///
  /// In es, this message translates to:
  /// **'La iglesia no está suspendida'**
  String get m5f072aa67dc4;

  /// No hay nada que cambiar
  ///
  /// In es, this message translates to:
  /// **'No hay nada que cambiar'**
  String get m6a155efde4c8;

  /// Los límites del plan se gestionan desde Stripe.
  ///
  /// In es, this message translates to:
  /// **'Los límites del plan se gestionan desde Stripe.'**
  String get m539b867a2da6;

  /// Una iglesia activa necesita la fecha "Pagada hasta". El periodo pagado se confirma mediante Stripe.
  ///
  /// In es, this message translates to:
  /// **'Una iglesia activa necesita la fecha \"Pagada hasta\". El periodo pagado se confirma mediante Stripe.'**
  String get mbb640b6f584b;

  /// Una iglesia en prueba necesita la fecha "Fin de la prueba". Indícala o márcala como exonerada.
  ///
  /// In es, this message translates to:
  /// **'Una iglesia en prueba necesita la fecha \"Fin de la prueba\". Indícala o márcala como exonerada.'**
  String get m084b15989190;

  /// Los pagos se gestionan exclusivamente desde Stripe.
  ///
  /// In es, this message translates to:
  /// **'Los pagos se gestionan exclusivamente desde Stripe.'**
  String get m6467218c7dad;

  /// Días de prueba inválidos (1 a 365)
  ///
  /// In es, this message translates to:
  /// **'Días de prueba inválidos (1 a 365)'**
  String get m1054774e58a7;

  /// Esta iglesia ya tiene facturación en Stripe. Gestiona su plan allí.
  ///
  /// In es, this message translates to:
  /// **'Esta iglesia ya tiene facturación en Stripe. Gestiona su plan allí.'**
  String get ma38bc587ece7;

  /// Esta iglesia está exonerada: no necesita prueba
  ///
  /// In es, this message translates to:
  /// **'Esta iglesia está exonerada: no necesita prueba'**
  String get m13e6f30b5d4d;

  /// Esta iglesia todavía tiene la suscripción pagada. Podrás darle una prueba cuando venza.
  ///
  /// In es, this message translates to:
  /// **'Esta iglesia todavía tiene la suscripción pagada. Podrás darle una prueba cuando venza.'**
  String get ma601583e9de8;

  /// Cancela primero la suscripción en Stripe antes de eliminar la iglesia.
  ///
  /// In es, this message translates to:
  /// **'Cancela primero la suscripción en Stripe antes de eliminar la iglesia.'**
  String get m2f1dfa5619b9;

  /// Para eliminarla, escribe el nombre exacto de la iglesia
  ///
  /// In es, this message translates to:
  /// **'Para eliminarla, escribe el nombre exacto de la iglesia'**
  String get mffa08249ce6b;

  /// Iglesia "{{p0}}" eliminada por completo
  ///
  /// In es, this message translates to:
  /// **'Iglesia \"{p0}\" eliminada por completo'**
  String m58b827ec72ce(String p0);

  /// La iglesia no tiene un usuario principal activo
  ///
  /// In es, this message translates to:
  /// **'La iglesia no tiene un usuario principal activo'**
  String get m19b5b657bcce;

  /// {{p0}} inválida (usa AAAA-MM-DD)
  ///
  /// In es, this message translates to:
  /// **'{p0} inválida (usa AAAA-MM-DD)'**
  String m19951c9ca4e8(String p0);

  /// {{p0}} inválido (número entero mayor a 0, o vacío para sin tope)
  ///
  /// In es, this message translates to:
  /// **'{p0} inválido (número entero mayor a 0, o vacío para sin tope)'**
  String m6678248badd6(String p0);

  /// Tu plan permite hasta {{p0}} usuarios activos. {{p1}}
  ///
  /// In es, this message translates to:
  /// **'Tu plan permite hasta {p0} usuarios activos. {p1}'**
  String mf259ed5d763e(String p0, String p1);

  /// Tu plan permite hasta {{p0}} integrantes activos. {{p1}}
  ///
  /// In es, this message translates to:
  /// **'Tu plan permite hasta {p0} integrantes activos. {p1}'**
  String mff847d2eb505(String p0, String p1);

  /// Tu plan permite hasta {{p0}} células activas. {{p1}}
  ///
  /// In es, this message translates to:
  /// **'Tu plan permite hasta {p0} células activas. {p1}'**
  String m5ea0de903f82(String p0, String p1);

  /// Tu plan permite hasta {{p0}} ministerios activos. {{p1}}
  ///
  /// In es, this message translates to:
  /// **'Tu plan permite hasta {p0} ministerios activos. {p1}'**
  String m88e44468523b(String p0, String p1);

  /// El devocional ya cambió. Recarga antes de guardar
  ///
  /// In es, this message translates to:
  /// **'El devocional ya cambió. Recarga antes de guardar'**
  String get ma2f9156dff08;

  /// Solo owner y pastor pueden cambiar la foto de la iglesia
  ///
  /// In es, this message translates to:
  /// **'Solo owner y pastor pueden cambiar la foto de la iglesia'**
  String get m4c02430e9bec;

  /// Conversación no encontrada
  ///
  /// In es, this message translates to:
  /// **'Conversación no encontrada'**
  String get ma69c0b55eea5;

  /// Respuestas inválidas
  ///
  /// In es, this message translates to:
  /// **'Respuestas inválidas'**
  String get m3d6f58e10474;

  /// Respuesta inválida
  ///
  /// In es, this message translates to:
  /// **'Respuesta inválida'**
  String get m78bdd7baa63d;

  /// Cursor inválido
  ///
  /// In es, this message translates to:
  /// **'Cursor inválido'**
  String get me930cc7153ac;

  /// Mensaje no encontrado
  ///
  /// In es, this message translates to:
  /// **'Mensaje no encontrado'**
  String get mf54ecd02ebf6;

  /// No puedes ocultar este mensaje
  ///
  /// In es, this message translates to:
  /// **'No puedes ocultar este mensaje'**
  String get m73dc17c2acb3;

  /// Sin portada
  ///
  /// In es, this message translates to:
  /// **'Sin portada'**
  String get m33e37c673240;

  /// Si ya tienes una cuenta, inicia sesión para inscribirte.
  ///
  /// In es, this message translates to:
  /// **'Si ya tienes una cuenta, inicia sesión para inscribirte.'**
  String get mfb0d5721f7e7;

  /// Revisa tu correo para confirmar la inscripción
  ///
  /// In es, this message translates to:
  /// **'Revisa tu correo para confirmar la inscripción'**
  String get m20efbf5cbd38;

  /// Escribe los seis números del código
  ///
  /// In es, this message translates to:
  /// **'Escribe los seis números del código'**
  String get m3ff2cf3d4ed4;

  /// El código venció o agotó sus intentos. Inicia la inscripción nuevamente
  ///
  /// In es, this message translates to:
  /// **'El código venció o agotó sus intentos. Inicia la inscripción nuevamente'**
  String get m7dac7c65b16b;

  /// Código incorrecto
  ///
  /// In es, this message translates to:
  /// **'Código incorrecto'**
  String get m4454e8b15406;

  /// Esta inscripción ya fue procesada
  ///
  /// In es, this message translates to:
  /// **'Esta inscripción ya fue procesada'**
  String get m951971b82d63;

  /// Tu cuenta ya existe. Inicia sesión para inscribirte.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta ya existe. Inicia sesión para inscribirte.'**
  String get m2b3becd33ae4;

  /// Indica tu fecha de nacimiento
  ///
  /// In es, this message translates to:
  /// **'Indica tu fecha de nacimiento'**
  String get m5eb44d828b39;

  /// Indica una fecha de nacimiento válida, anterior o igual a hoy
  ///
  /// In es, this message translates to:
  /// **'Indica una fecha de nacimiento válida, anterior o igual a hoy'**
  String get md1eab2b23bd9;

  /// La inscripción de esta iglesia no está disponible
  ///
  /// In es, this message translates to:
  /// **'La inscripción de esta iglesia no está disponible'**
  String get m43b821535fad;

  /// Usa una cuenta activa de esta iglesia
  ///
  /// In es, this message translates to:
  /// **'Usa una cuenta activa de esta iglesia'**
  String get m3d45dd7655e5;

  /// Portada actualizada
  ///
  /// In es, this message translates to:
  /// **'Portada actualizada'**
  String get m3f51efc58b24;

  /// Nombre inválido
  ///
  /// In es, this message translates to:
  /// **'Nombre inválido'**
  String get m84b9f3abd554;

  /// Título inválido
  ///
  /// In es, this message translates to:
  /// **'Título inválido'**
  String get mf651b91f81b1;

  /// Material no encontrado
  ///
  /// In es, this message translates to:
  /// **'Material no encontrado'**
  String get m33214bb7e1a0;

  /// Material retirado del curso
  ///
  /// In es, this message translates to:
  /// **'Material retirado del curso'**
  String get ma461262a6057;

  /// Indica si habilitar la inscripción
  ///
  /// In es, this message translates to:
  /// **'Indica si habilitar la inscripción'**
  String get me3ee26708ba8;

  /// Cuenta no disponible
  ///
  /// In es, this message translates to:
  /// **'Cuenta no disponible'**
  String get m1e54e8186f9a;

  /// Integrante no disponible
  ///
  /// In es, this message translates to:
  /// **'Integrante no disponible'**
  String get m87037a78ad79;

  /// Alumno inscrito
  ///
  /// In es, this message translates to:
  /// **'Alumno inscrito'**
  String get m603c80c0b7e3;

  /// No puedes modificar este curso
  ///
  /// In es, this message translates to:
  /// **'No puedes modificar este curso'**
  String get md9675f7894a8;

  /// No estás inscrito en este curso
  ///
  /// In es, this message translates to:
  /// **'No estás inscrito en este curso'**
  String get m54777ee5e7a0;

  /// Inscripción no disponible
  ///
  /// In es, this message translates to:
  /// **'Inscripción no disponible'**
  String get mfb6a2dbbfbad;

  /// El archivo debe pesar hasta 10 MB
  ///
  /// In es, this message translates to:
  /// **'El archivo debe pesar hasta 10 MB'**
  String get m7e120943731d;

  /// Nombre de archivo inválido
  ///
  /// In es, this message translates to:
  /// **'Nombre de archivo inválido'**
  String get m49bb69172b93;

  /// Usa PDF, JPG, PNG, WebP, Word o PowerPoint
  ///
  /// In es, this message translates to:
  /// **'Usa PDF, JPG, PNG, WebP, Word o PowerPoint'**
  String get mf2a9a8d6ce38;

  /// El contenido del archivo no coincide con su formato
  ///
  /// In es, this message translates to:
  /// **'El contenido del archivo no coincide con su formato'**
  String get m2f09ead1e46c;

  /// Material no disponible
  ///
  /// In es, this message translates to:
  /// **'Material no disponible'**
  String get mb7bccfceaae8;

  /// Aviso no encontrado
  ///
  /// In es, this message translates to:
  /// **'Aviso no encontrado'**
  String get m2b3895aa10ac;

  /// Este aviso corresponde a su responsable directo
  ///
  /// In es, this message translates to:
  /// **'Este aviso corresponde a su responsable directo'**
  String get ma06459ac6457;

  /// Este seguimiento ya fue resuelto
  ///
  /// In es, this message translates to:
  /// **'Este seguimiento ya fue resuelto'**
  String get m9daccfdd30d3;

  /// El seguimiento cambió. Recarga antes de continuar
  ///
  /// In es, this message translates to:
  /// **'El seguimiento cambió. Recarga antes de continuar'**
  String get m20fccb677bba;

  /// La nota admite hasta 500 caracteres
  ///
  /// In es, this message translates to:
  /// **'La nota admite hasta 500 caracteres'**
  String get m68464ed0d6db;

  /// Acción inválida
  ///
  /// In es, this message translates to:
  /// **'Acción inválida'**
  String get md2f2cb85499d;

  /// Selecciona su superior o un pastor responsable
  ///
  /// In es, this message translates to:
  /// **'Selecciona su superior o un pastor responsable'**
  String get meb6cb05f3899;

  /// El devocional debe tener hasta 60 000 caracteres
  ///
  /// In es, this message translates to:
  /// **'El devocional debe tener hasta 60 000 caracteres'**
  String get m93f64b5a3d09;

  /// Escribe una reflexión de hasta 20 000 caracteres
  ///
  /// In es, this message translates to:
  /// **'Escribe una reflexión de hasta 20 000 caracteres'**
  String get mdfd97523cd3f;

  /// Iglesia no disponible
  ///
  /// In es, this message translates to:
  /// **'Iglesia no disponible'**
  String get maf0a00c813f1;

  /// Tipo de devocional inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo de devocional inválido'**
  String get mb2ac19c180d5;

  /// Elige publicar o guardar borrador
  ///
  /// In es, this message translates to:
  /// **'Elige publicar o guardar borrador'**
  String get mb18133a27e77;

  /// La publicación cambió. Recarga antes de guardar
  ///
  /// In es, this message translates to:
  /// **'La publicación cambió. Recarga antes de guardar'**
  String get mbeed9b399478;

  /// Elige un pastor activo de tu iglesia
  ///
  /// In es, this message translates to:
  /// **'Elige un pastor activo de tu iglesia'**
  String get m13adc0586369;

  /// Ya existe un devocional para ese día. Recarga y edítalo
  ///
  /// In es, this message translates to:
  /// **'Ya existe un devocional para ese día. Recarga y edítalo'**
  String get mb07161585609;

  /// Imagen no encontrada
  ///
  /// In es, this message translates to:
  /// **'Imagen no encontrada'**
  String get m30b5156eb711;

  /// Solo el equipo pastoral publica para la iglesia
  ///
  /// In es, this message translates to:
  /// **'Solo el equipo pastoral publica para la iglesia'**
  String get m1163dafb0c27;

  /// No puedes publicar para esta célula
  ///
  /// In es, this message translates to:
  /// **'No puedes publicar para esta célula'**
  String get m90898cfb9116;

  /// Devocional no encontrado
  ///
  /// In es, this message translates to:
  /// **'Devocional no encontrado'**
  String get md7e4a19cd228;

  /// Devocional no disponible
  ///
  /// In es, this message translates to:
  /// **'Devocional no disponible'**
  String get md34cfa84cd75;

  /// Sitemap no encontrado
  ///
  /// In es, this message translates to:
  /// **'Sitemap no encontrado'**
  String get m4ddd69f25cd0;

  /// Acepta los términos y confirma la lectura de la política de privacidad.
  ///
  /// In es, this message translates to:
  /// **'Acepta los términos y confirma la lectura de la política de privacidad.'**
  String get m4383edb2d872;

  /// Los documentos legales se actualizaron. Recarga la página y revísalos.
  ///
  /// In es, this message translates to:
  /// **'Los documentos legales se actualizaron. Recarga la página y revísalos.'**
  String get m25fff146dbb3;

  /// Activa primero al integrante
  ///
  /// In es, this message translates to:
  /// **'Activa primero al integrante'**
  String get m0bd1e8b6d0bd;

  /// Actualiza primero el correo del integrante antes de enviar la invitación
  ///
  /// In es, this message translates to:
  /// **'Actualiza primero el correo del integrante antes de enviar la invitación'**
  String get m1ea7e5cf499a;

  /// Disponibilidad inválida
  ///
  /// In es, this message translates to:
  /// **'Disponibilidad inválida'**
  String get mfe1972be3f01;

  /// Horario inválido
  ///
  /// In es, this message translates to:
  /// **'Horario inválido'**
  String get me4482a0334e2;

  /// Usa una foto JPG, PNG o WebP de hasta 500 KB
  ///
  /// In es, this message translates to:
  /// **'Usa una foto JPG, PNG o WebP de hasta 500 KB'**
  String get m434a9894f9ca;

  /// Bautismo inválido
  ///
  /// In es, this message translates to:
  /// **'Bautismo inválido'**
  String get md87eb79f3ad6;

  /// El correo de una cuenta vinculada se cambia desde la administración de la cuenta
  ///
  /// In es, this message translates to:
  /// **'El correo de una cuenta vinculada se cambia desde la administración de la cuenta'**
  String get m2987758c4a85;

  /// Integrante eliminado
  ///
  /// In es, this message translates to:
  /// **'Integrante eliminado'**
  String get maad84023c330;

  /// Edad inválida
  ///
  /// In es, this message translates to:
  /// **'Edad inválida'**
  String get m54dafa7f8386;

  /// Tipo de audiencia inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo de audiencia inválido'**
  String get m2bcbeaa32780;

  /// Solo el pastor o usuario principal puede fijar comunicados
  ///
  /// In es, this message translates to:
  /// **'Solo el pastor o usuario principal puede fijar comunicados'**
  String get m080f8bf888c1;

  /// La fecha de vencimiento del fijado debe ser hoy o posterior
  ///
  /// In es, this message translates to:
  /// **'La fecha de vencimiento del fijado debe ser hoy o posterior'**
  String get mfc1cd6b0c073;

  /// Actividad no encontrada
  ///
  /// In es, this message translates to:
  /// **'Actividad no encontrada'**
  String get m7a73861cac2d;

  /// Selecciona al menos un grupo de destinatarios válido
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un grupo de destinatarios válido'**
  String get mce1deecd3160;

  /// Solo puedes enviar a roles inferiores dentro de tu ámbito
  ///
  /// In es, this message translates to:
  /// **'Solo puedes enviar a roles inferiores dentro de tu ámbito'**
  String get m8cdf4dc0b78a;

  /// No hay destinatarios activos para esos roles dentro de tu ámbito
  ///
  /// In es, this message translates to:
  /// **'No hay destinatarios activos para esos roles dentro de tu ámbito'**
  String get mbd0b68753ed8;

  /// No hay destinatarios activos en esa audiencia
  ///
  /// In es, this message translates to:
  /// **'No hay destinatarios activos en esa audiencia'**
  String get m18053caf9255;

  /// Marcado como leído
  ///
  /// In es, this message translates to:
  /// **'Marcado como leído'**
  String get m3123b65b1912;

  /// Mensaje eliminado
  ///
  /// In es, this message translates to:
  /// **'Mensaje eliminado'**
  String get ma89072806e9e;

  /// Solo el pastor o usuario principal puede enviar a toda la iglesia
  ///
  /// In es, this message translates to:
  /// **'Solo el pastor o usuario principal puede enviar a toda la iglesia'**
  String get m1cd51e5cd589;

  /// No tienes permiso para enviar comunicados a esa célula
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para enviar comunicados a esa célula'**
  String get m3c23f77301f5;

  /// Ministerio no encontrado
  ///
  /// In es, this message translates to:
  /// **'Ministerio no encontrado'**
  String get m9aa4d9636e70;

  /// No tienes permiso para enviar comunicados a este ministerio
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para enviar comunicados a este ministerio'**
  String get m6d054731d7b7;

  /// Ministerio eliminado por completo
  ///
  /// In es, this message translates to:
  /// **'Ministerio eliminado por completo'**
  String get m806882647047;

  /// El ministerio está desactivado
  ///
  /// In es, this message translates to:
  /// **'El ministerio está desactivado'**
  String get m2fc3ca32614a;

  /// Integrante no encontrado o no activo
  ///
  /// In es, this message translates to:
  /// **'Integrante no encontrado o no activo'**
  String get m1e241ed41db5;

  /// Esa persona ya sirve en este ministerio
  ///
  /// In es, this message translates to:
  /// **'Esa persona ya sirve en este ministerio'**
  String get mf5df4c5a7900;

  /// Registra el bautismo antes de añadir a esta persona al servicio
  ///
  /// In es, this message translates to:
  /// **'Registra el bautismo antes de añadir a esta persona al servicio'**
  String get mb1d79ed26f22;

  /// Registra el bautismo antes de activar el servicio
  ///
  /// In es, this message translates to:
  /// **'Registra el bautismo antes de activar el servicio'**
  String get m845f5aaae128;

  /// Servidor quitado del ministerio
  ///
  /// In es, this message translates to:
  /// **'Servidor quitado del ministerio'**
  String get m49a01b7b2cf5;

  /// Este siervo está en pausa
  ///
  /// In es, this message translates to:
  /// **'Este siervo está en pausa'**
  String get m540e0fbdc688;

  /// Hora inválida
  ///
  /// In es, this message translates to:
  /// **'Hora inválida'**
  String get m8fdb31ec6976;

  /// Fechas inválidas
  ///
  /// In es, this message translates to:
  /// **'Fechas inválidas'**
  String get mc88df0fd2fce;

  /// Elige entre 1 y 62 fechas
  ///
  /// In es, this message translates to:
  /// **'Elige entre 1 y 62 fechas'**
  String get mc6b86037b1e9;

  /// Fecha inválida: {{p0}}
  ///
  /// In es, this message translates to:
  /// **'Fecha inválida: {p0}'**
  String m7fef71f32acf(String p0);

  /// Turno no encontrado
  ///
  /// In es, this message translates to:
  /// **'Turno no encontrado'**
  String get m1e04efaf878b;

  /// Turno eliminado
  ///
  /// In es, this message translates to:
  /// **'Turno eliminado'**
  String get m0d109051c146;

  /// Fecha inválida para el reemplazo
  ///
  /// In es, this message translates to:
  /// **'Fecha inválida para el reemplazo'**
  String get m553797d19e8a;

  /// Elige a otro servidor para el reemplazo
  ///
  /// In es, this message translates to:
  /// **'Elige a otro servidor para el reemplazo'**
  String get md9d841514795;

  /// Ese servidor ya tiene un turno asignado en ese horario
  ///
  /// In es, this message translates to:
  /// **'Ese servidor ya tiene un turno asignado en ese horario'**
  String get m725d06685332;

  /// Fecha inválida para registrar asistencia
  ///
  /// In es, this message translates to:
  /// **'Fecha inválida para registrar asistencia'**
  String get m5d09518e2fae;

  /// Solo puedes registrar participación en fechas pasadas o de hoy
  ///
  /// In es, this message translates to:
  /// **'Solo puedes registrar participación en fechas pasadas o de hoy'**
  String get m4574656ac909;

  /// No tienes permiso sobre este ministerio
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso sobre este ministerio'**
  String get m7eed36c0a36f;

  /// Servidor no encontrado
  ///
  /// In es, this message translates to:
  /// **'Servidor no encontrado'**
  String get m648e6bf2b74a;

  /// Otra persona actualizó las indicaciones. Recarga antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'Otra persona actualizó las indicaciones. Recarga antes de guardar.'**
  String get mb69d55e94ef4;

  /// Las notificaciones del navegador aún no están disponibles
  ///
  /// In es, this message translates to:
  /// **'Las notificaciones del navegador aún no están disponibles'**
  String get m3204389ff814;

  /// Tipo de dispositivo inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo de dispositivo inválido'**
  String get mad1bcce76a27;

  /// Identificador de instalación inválido
  ///
  /// In es, this message translates to:
  /// **'Identificador de instalación inválido'**
  String get m0bd73514053e;

  /// Registra primero el bautismo de esta persona para asignarle servicio o liderazgo
  ///
  /// In es, this message translates to:
  /// **'Registra primero el bautismo de esta persona para asignarle servicio o liderazgo'**
  String get m0ad8e1375393;

  /// No se puede usar este correo para una nueva cuenta en esta iglesia
  ///
  /// In es, this message translates to:
  /// **'No se puede usar este correo para una nueva cuenta en esta iglesia'**
  String get ma07387e45710;

  /// La cuenta está suspendida. Su responsable debe reactivarla
  ///
  /// In es, this message translates to:
  /// **'La cuenta está suspendida. Su responsable debe reactivarla'**
  String get mb38d62d4184f;

  /// Esta persona ya tiene otra célula de asistencia. Usa su célula actual o actualiza la asignación desde el panel de permisos
  ///
  /// In es, this message translates to:
  /// **'Esta persona ya tiene otra célula de asistencia. Usa su célula actual o actualiza la asignación desde el panel de permisos'**
  String get m3810c09b5e93;

  /// Integrante no disponible para vincular
  ///
  /// In es, this message translates to:
  /// **'Integrante no disponible para vincular'**
  String get m3161bf551480;

  /// Este correo ya pertenece a un integrante de otra célula. Selecciona su perfil actual
  ///
  /// In es, this message translates to:
  /// **'Este correo ya pertenece a un integrante de otra célula. Selecciona su perfil actual'**
  String get m0406053a801d;

  /// El correo debe coincidir con el del integrante seleccionado
  ///
  /// In es, this message translates to:
  /// **'El correo debe coincidir con el del integrante seleccionado'**
  String get mf0d2169dce20;

  /// Esta persona ya tiene cuenta. Cambia sus cargos desde su perfil
  ///
  /// In es, this message translates to:
  /// **'Esta persona ya tiene cuenta. Cambia sus cargos desde su perfil'**
  String get md4af4fb83614;

  /// Esta persona ya tiene cuenta. Usa Roles y asignaciones para cambiar sus responsabilidades
  ///
  /// In es, this message translates to:
  /// **'Esta persona ya tiene cuenta. Usa Roles y asignaciones para cambiar sus responsabilidades'**
  String get mbffda598af20;

  /// El owner o el pastor debe asignar su rol de iglesia desde el panel de permisos
  ///
  /// In es, this message translates to:
  /// **'El owner o el pastor debe asignar su rol de iglesia desde el panel de permisos'**
  String get m90a73b032bb9;

  /// Sector eliminado
  ///
  /// In es, this message translates to:
  /// **'Sector eliminado'**
  String get m498a4bc83bff;

  /// Solo el owner asigna pastores a los sectores
  ///
  /// In es, this message translates to:
  /// **'Solo el owner asigna pastores a los sectores'**
  String get m479adaeb50a5;

  /// Pastores inválidos
  ///
  /// In es, this message translates to:
  /// **'Pastores inválidos'**
  String get ma132cac22c15;

  /// Selecciona pastores de tu iglesia
  ///
  /// In es, this message translates to:
  /// **'Selecciona pastores de tu iglesia'**
  String get m1bdb89b8a015;

  /// Solo el owner y el pastor pueden cambiar roles
  ///
  /// In es, this message translates to:
  /// **'Solo el owner y el pastor pueden cambiar roles'**
  String get m2faf793f0c04;

  /// Usuario no encontrado
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado'**
  String get m2b23ceeae12a;

  /// Solo el administrador del sistema modifica los cargos adicionales del owner
  ///
  /// In es, this message translates to:
  /// **'Solo el administrador del sistema modifica los cargos adicionales del owner'**
  String get m63aaa756bad4;

  /// La cuenta ya está activada o está suspendida
  ///
  /// In es, this message translates to:
  /// **'La cuenta ya está activada o está suspendida'**
  String get m5aaf684022f4;

  /// Solo el owner y el pastor administran cuentas
  ///
  /// In es, this message translates to:
  /// **'Solo el owner y el pastor administran cuentas'**
  String get mfc77df7cc102;

  /// No puedes asignar uno de estos roles
  ///
  /// In es, this message translates to:
  /// **'No puedes asignar uno de estos roles'**
  String get mc48daa6d07a0;

  /// Rol desconocido
  ///
  /// In es, this message translates to:
  /// **'Rol desconocido'**
  String get mca5421af369e;

  /// La relación de supervisión formaría un ciclo
  ///
  /// In es, this message translates to:
  /// **'La relación de supervisión formaría un ciclo'**
  String get me5289a2ff214;

  /// No puedes modificar tus propios permisos
  ///
  /// In es, this message translates to:
  /// **'No puedes modificar tus propios permisos'**
  String get m7e02145abb7a;

  /// No puedes administrar un cargo de igual o mayor jerarquía
  ///
  /// In es, this message translates to:
  /// **'No puedes administrar un cargo de igual o mayor jerarquía'**
  String get m3095a9dd286f;

  /// Esta persona no está bajo tu supervisión
  ///
  /// In es, this message translates to:
  /// **'Esta persona no está bajo tu supervisión'**
  String get m3d63ee7cf811;

  /// Célula de asistencia no encontrada
  ///
  /// In es, this message translates to:
  /// **'Célula de asistencia no encontrada'**
  String get mfd3e8af376a5;

  /// Célula desactivada
  ///
  /// In es, this message translates to:
  /// **'Célula desactivada'**
  String get m8b84506a5e1e;

  /// La célula a cargo debe pertenecer a tu zona asignada
  ///
  /// In es, this message translates to:
  /// **'La célula a cargo debe pertenecer a tu zona asignada'**
  String get m9a5096f31f86;

  /// La célula a cargo debe pertenecer a tu sector asignado
  ///
  /// In es, this message translates to:
  /// **'La célula a cargo debe pertenecer a tu sector asignado'**
  String get m5fddb87d37b8;

  /// Curso no disponible
  ///
  /// In es, this message translates to:
  /// **'Curso no disponible'**
  String get me041248fe6ba;

  /// Solo puedes invitar alumnos a tus cursos
  ///
  /// In es, this message translates to:
  /// **'Solo puedes invitar alumnos a tus cursos'**
  String get m0b461373f3d2;

  /// No puedes asignar líderes de ministerio
  ///
  /// In es, this message translates to:
  /// **'No puedes asignar líderes de ministerio'**
  String get mfdac7c5b7cfd;

  /// Solo puedes invitar siervos a tu ministerio
  ///
  /// In es, this message translates to:
  /// **'Solo puedes invitar siervos a tu ministerio'**
  String get mb270e5cc23c0;

  /// Supervisor no disponible
  ///
  /// In es, this message translates to:
  /// **'Supervisor no disponible'**
  String get ma925fdf30d57;

  /// El supervisor debe tener una jerarquía mayor
  ///
  /// In es, this message translates to:
  /// **'El supervisor debe tener una jerarquía mayor'**
  String get me6aabafb296b;

  /// Esta responsabilidad ya tiene un líder activo
  ///
  /// In es, this message translates to:
  /// **'Esta responsabilidad ya tiene un líder activo'**
  String get m2802ed794a45;

  /// Jerarquía demasiado profunda
  ///
  /// In es, this message translates to:
  /// **'Jerarquía demasiado profunda'**
  String get m3a7bd55f5a7a;

  /// Existe un ciclo en la jerarquía
  ///
  /// In es, this message translates to:
  /// **'Existe un ciclo en la jerarquía'**
  String get mb7ee19c4dc21;

  /// No se puede eliminar: tiene personas, grupos o historial vinculados. Reasigna sus dependencias o desactívalo para conservar la información.
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar: tiene personas, grupos o historial vinculados. Reasigna sus dependencias o desactívalo para conservar la información.'**
  String get m7086e0f8bd3b;

  /// Foto no encontrada
  ///
  /// In es, this message translates to:
  /// **'Foto no encontrada'**
  String get m810836f77330;

  /// Sin acceso a esta foto
  ///
  /// In es, this message translates to:
  /// **'Sin acceso a esta foto'**
  String get m40d774f249a9;

  /// Asignación no encontrada
  ///
  /// In es, this message translates to:
  /// **'Asignación no encontrada'**
  String get m59574faa5411;

  /// Esta asignación ya tiene una respuesta
  ///
  /// In es, this message translates to:
  /// **'Esta asignación ya tiene una respuesta'**
  String get mb1ff1405a132;

  /// La asignación ya cambió
  ///
  /// In es, this message translates to:
  /// **'La asignación ya cambió'**
  String get mfb0d26bb4b10;

  /// Esta asignación ya fue declinada
  ///
  /// In es, this message translates to:
  /// **'Esta asignación ya fue declinada'**
  String get m58151fbaed35;

  /// No puedes declinar un turno pasado
  ///
  /// In es, this message translates to:
  /// **'No puedes declinar un turno pasado'**
  String get mea71c5a4167d;

  /// Fecha inválida para este turno semanal
  ///
  /// In es, this message translates to:
  /// **'Fecha inválida para este turno semanal'**
  String get m3dbf02d26cc4;

  /// Este diario privado corresponde al pastor
  ///
  /// In es, this message translates to:
  /// **'Este diario privado corresponde al pastor'**
  String get m4bf390b55c03;

  /// Género inválido
  ///
  /// In es, this message translates to:
  /// **'Género inválido'**
  String get mbba5902f0583;

  /// Escribe un teléfono válido
  ///
  /// In es, this message translates to:
  /// **'Escribe un teléfono válido'**
  String get m21d47385a934;

  /// Célula o ministerio no disponible
  ///
  /// In es, this message translates to:
  /// **'Célula o ministerio no disponible'**
  String get m0bb070a3e881;

  /// Conecta Stripe para consultar ingresos, comisiones y resultado.
  ///
  /// In es, this message translates to:
  /// **'Conecta Stripe para consultar ingresos, comisiones y resultado.'**
  String get m5a1f7ea6f6e6;

  /// No se pudo consultar Stripe. Reintenta en unos instantes.
  ///
  /// In es, this message translates to:
  /// **'No se pudo consultar Stripe. Reintenta en unos instantes.'**
  String get mda9cbf1451b7;

  /// Elige un periodo de hasta 366 días, con inicio anterior al fin
  ///
  /// In es, this message translates to:
  /// **'Elige un periodo de hasta 366 días, con inicio anterior al fin'**
  String get m985727b7c693;

  /// Escribe un importe positivo con hasta dos decimales
  ///
  /// In es, this message translates to:
  /// **'Escribe un importe positivo con hasta dos decimales'**
  String get m22d322811e8d;

  /// El importe debe ser mayor a cero
  ///
  /// In es, this message translates to:
  /// **'El importe debe ser mayor a cero'**
  String get m290cbbf78480;

  /// Moneda inválida
  ///
  /// In es, this message translates to:
  /// **'Moneda inválida'**
  String get m0fc3f0a6dc23;

  /// Indica si el costo se repite mensualmente
  ///
  /// In es, this message translates to:
  /// **'Indica si el costo se repite mensualmente'**
  String get mcd9d0af6a8b7;

  /// Gasto no encontrado
  ///
  /// In es, this message translates to:
  /// **'Gasto no encontrado'**
  String get me18b0c64ec22;

  /// Restaura el costo antes de cambiar su frecuencia
  ///
  /// In es, this message translates to:
  /// **'Restaura el costo antes de cambiar su frecuencia'**
  String get m4dacfcb18677;

  /// Para una nueva serie, registra otro costo con su fecha de inicio
  ///
  /// In es, this message translates to:
  /// **'Para una nueva serie, registra otro costo con su fecha de inicio'**
  String get m4d71eb8344a8;

  /// Este costo no es mensual
  ///
  /// In es, this message translates to:
  /// **'Este costo no es mensual'**
  String get m716f77182bb8;

  /// Rol inválido
  ///
  /// In es, this message translates to:
  /// **'Rol inválido'**
  String get m2664250e7b4d;

  /// Estado de actividad inválido
  ///
  /// In es, this message translates to:
  /// **'Estado de actividad inválido'**
  String get m3f632d15f63d;

  /// groupBy inválido
  ///
  /// In es, this message translates to:
  /// **'groupBy inválido'**
  String get mfebeae94bf91;

  /// No tienes permiso para esta consulta
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para esta consulta'**
  String get m5a52b9b48b4d;

  /// No tienes permiso sobre esa zona
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso sobre esa zona'**
  String get m0a5d700ce089;

  /// Esta acción solo cambia el estado del bien
  ///
  /// In es, this message translates to:
  /// **'Esta acción solo cambia el estado del bien'**
  String get m9457af4e3331;

  /// Primero registra el daño; desde Dañados puedes enviar a reparación o dar de baja
  ///
  /// In es, this message translates to:
  /// **'Primero registra el daño; desde Dañados puedes enviar a reparación o dar de baja'**
  String get m6f751ea2f43c;

  /// Selecciona un estado diferente
  ///
  /// In es, this message translates to:
  /// **'Selecciona un estado diferente'**
  String get maef3e44f787f;

  /// El bien cambió, está prestado o dado de baja. Actualiza el inventario.
  ///
  /// In es, this message translates to:
  /// **'El bien cambió, está prestado o dado de baja. Actualiza el inventario.'**
  String get mdc023a8ee5d2;

  /// Selecciona un icono válido para el bien
  ///
  /// In es, this message translates to:
  /// **'Selecciona un icono válido para el bien'**
  String get m31a57a02b91d;

  /// Categoría inválida
  ///
  /// In es, this message translates to:
  /// **'Categoría inválida'**
  String get m4b6d1388fad5;

  /// Filtro de estado inválido
  ///
  /// In es, this message translates to:
  /// **'Filtro de estado inválido'**
  String get me72e07dd6527;

  /// Bien no encontrado
  ///
  /// In es, this message translates to:
  /// **'Bien no encontrado'**
  String get mda5b2abcb44a;

  /// El bien ya no está disponible
  ///
  /// In es, this message translates to:
  /// **'El bien ya no está disponible'**
  String get mf2320ead5f5d;

  /// Indica el resultado de la reparación
  ///
  /// In es, this message translates to:
  /// **'Indica el resultado de la reparación'**
  String get m1486edae92c3;

  /// La finalización no puede ser anterior al inicio
  ///
  /// In es, this message translates to:
  /// **'La finalización no puede ser anterior al inicio'**
  String get me5ba17088d71;

  /// La fecha de inicio no coincide con la reparación
  ///
  /// In es, this message translates to:
  /// **'La fecha de inicio no coincide con la reparación'**
  String get mef51003546aa;

  /// Identificador del envío inválido
  ///
  /// In es, this message translates to:
  /// **'Identificador del envío inválido'**
  String get mbaa1c7e99359;

  /// Este envío ya se utilizó con otros datos de reparación
  ///
  /// In es, this message translates to:
  /// **'Este envío ya se utilizó con otros datos de reparación'**
  String get mcc234822609a;

  /// La finalización ya está en proceso; actualiza el inventario
  ///
  /// In es, this message translates to:
  /// **'La finalización ya está en proceso; actualiza el inventario'**
  String get mec9d9fff9e0f;

  /// El bien no está en reparación
  ///
  /// In es, this message translates to:
  /// **'El bien no está en reparación'**
  String get m45c5da1f9c64;

  /// La reparación cambió; actualiza antes de finalizar
  ///
  /// In es, this message translates to:
  /// **'La reparación cambió; actualiza antes de finalizar'**
  String get m87f02ebd83ac;

  /// Registra el bien como dañado y luego envíalo a reparación con su fecha
  ///
  /// In es, this message translates to:
  /// **'Registra el bien como dañado y luego envíalo a reparación con su fecha'**
  String get m5e93190e6f91;

  /// Registra entre 1 y 100 unidades
  ///
  /// In es, this message translates to:
  /// **'Registra entre 1 y 100 unidades'**
  String get m6addda95d165;

  /// El número de serie corresponde a una sola unidad
  ///
  /// In es, this message translates to:
  /// **'El número de serie corresponde a una sola unidad'**
  String get mda0f72288b4b;

  /// Usa letras, números, guion o guion bajo en el código
  ///
  /// In es, this message translates to:
  /// **'Usa letras, números, guion o guion bajo en el código'**
  String get m8965bb0605f1;

  /// No puedes editar un bien prestado, dado de baja o con una reparación pendiente
  ///
  /// In es, this message translates to:
  /// **'No puedes editar un bien prestado, dado de baja o con una reparación pendiente'**
  String get mb9ea507e981b;

  /// Usa la acción de reparación para cambiar el estado
  ///
  /// In es, this message translates to:
  /// **'Usa la acción de reparación para cambiar el estado'**
  String get m322032c513ae;

  /// Habilita explícitamente la edición de los datos de identificación
  ///
  /// In es, this message translates to:
  /// **'Habilita explícitamente la edición de los datos de identificación'**
  String get m6e55237ce7b9;

  /// El bien cambió. Actualiza antes de editar.
  ///
  /// In es, this message translates to:
  /// **'El bien cambió. Actualiza antes de editar.'**
  String get mb39fa937bc42;

  /// Solo puedes dar de baja un bien dañado sin préstamo ni reparación pendiente
  ///
  /// In es, this message translates to:
  /// **'Solo puedes dar de baja un bien dañado sin préstamo ni reparación pendiente'**
  String get me3f840d43900;

  /// La devolución prevista debe ser igual o posterior a la entrega
  ///
  /// In es, this message translates to:
  /// **'La devolución prevista debe ser igual o posterior a la entrega'**
  String get m06fedf8b85c9;

  /// Este envío ya se utilizó para otro préstamo
  ///
  /// In es, this message translates to:
  /// **'Este envío ya se utilizó para otro préstamo'**
  String get m1d9f3bda3371;

  /// El bien ya está prestado, dado de baja o no está operativo. Actualiza el inventario.
  ///
  /// In es, this message translates to:
  /// **'El bien ya está prestado, dado de baja o no está operativo. Actualiza el inventario.'**
  String get m9de846ea3209;

  /// Devuelve el bien como dañado y luego registra la reparación
  ///
  /// In es, this message translates to:
  /// **'Devuelve el bien como dañado y luego registra la reparación'**
  String get madbd02368ca7;

  /// Préstamo no encontrado
  ///
  /// In es, this message translates to:
  /// **'Préstamo no encontrado'**
  String get mcc8607f6bb1a;

  /// Revisa la fecha de devolución o actualiza el préstamo: ya pudo haber sido devuelto
  ///
  /// In es, this message translates to:
  /// **'Revisa la fecha de devolución o actualiza el préstamo: ya pudo haber sido devuelto'**
  String get mebf61e659ad3;

  /// Demasiadas inscripciones desde esta conexión. Intenta más tarde.
  ///
  /// In es, this message translates to:
  /// **'Demasiadas inscripciones desde esta conexión. Intenta más tarde.'**
  String get m5974c608ab46;

  /// Completa el formulario de inscripción. No necesitas crear una cuenta
  ///
  /// In es, this message translates to:
  /// **'Completa el formulario de inscripción. No necesitas crear una cuenta'**
  String get me2aecb7547c4;

  /// La inscripción a actividades ya no crea cuentas. Completa el formulario
  ///
  /// In es, this message translates to:
  /// **'La inscripción a actividades ya no crea cuentas. Completa el formulario'**
  String get ma0553759519c;

  /// {{p0}} inválido
  ///
  /// In es, this message translates to:
  /// **'{p0} inválido'**
  String mf0f2ef142fe6(String p0);

  /// {{p0}}: usa un importe positivo con hasta dos decimales
  ///
  /// In es, this message translates to:
  /// **'{p0}: usa un importe positivo con hasta dos decimales'**
  String m383cac389373(String p0);

  /// {{p0}} debe ser mayor que cero
  ///
  /// In es, this message translates to:
  /// **'{p0} debe ser mayor que cero'**
  String m3c41898cb268(String p0);

  /// Cantidad inválida
  ///
  /// In es, this message translates to:
  /// **'Cantidad inválida'**
  String get m5ebd1ac4c051;

  /// Presupuesto demasiado grande
  ///
  /// In es, this message translates to:
  /// **'Presupuesto demasiado grande'**
  String get m25a94117096b;

  /// Indica si el gasto fue realizado
  ///
  /// In es, this message translates to:
  /// **'Indica si el gasto fue realizado'**
  String get md99a69cf46bd;

  /// No puedes elegir administradores
  ///
  /// In es, this message translates to:
  /// **'No puedes elegir administradores'**
  String get m01285174d983;

  /// Solo el creador y el owner pueden cambiar los administradores
  ///
  /// In es, this message translates to:
  /// **'Solo el creador y el owner pueden cambiar los administradores'**
  String get m34bf86fbe4ef;

  /// La actividad cambió. Recarga antes de guardar
  ///
  /// In es, this message translates to:
  /// **'La actividad cambió. Recarga antes de guardar'**
  String get m5e3326c8cbb8;

  /// Selecciona hasta 30 administradores
  ///
  /// In es, this message translates to:
  /// **'Selecciona hasta 30 administradores'**
  String get me1e847d69bba;

  /// Selecciona líderes activos desde líder de zona de tu misma iglesia
  ///
  /// In es, this message translates to:
  /// **'Selecciona líderes activos desde líder de zona de tu misma iglesia'**
  String get mefa120082fe8;

  /// Inscripción no encontrada
  ///
  /// In es, this message translates to:
  /// **'Inscripción no encontrada'**
  String get m650fb5779bed;

  /// Esta inscripción no tiene costo
  ///
  /// In es, this message translates to:
  /// **'Esta inscripción no tiene costo'**
  String get m979fbbb9d25b;

  /// Indica una fecha válida para el abono
  ///
  /// In es, this message translates to:
  /// **'Indica una fecha válida para el abono'**
  String get m814040f27741;

  /// El importe supera el saldo pendiente de la inscripción
  ///
  /// In es, this message translates to:
  /// **'El importe supera el saldo pendiente de la inscripción'**
  String get m2de2f3c2aa1e;

  /// Abono no encontrado
  ///
  /// In es, this message translates to:
  /// **'Abono no encontrado'**
  String get m24fa12d343ef;

  /// El abono ya fue revisado. Anula un pago confirmado para corregirlo
  ///
  /// In es, this message translates to:
  /// **'El abono ya fue revisado. Anula un pago confirmado para corregirlo'**
  String get m2e5416fffc15;

  /// La inscripci�n no est� activa
  ///
  /// In es, this message translates to:
  /// **'La inscripci�n no est� activa'**
  String get m00c204a83ed4;

  /// El importe supera el saldo pendiente
  ///
  /// In es, this message translates to:
  /// **'El importe supera el saldo pendiente'**
  String get m5d9a5ac61929;

  /// Solo puedes corregir el importe al confirmar
  ///
  /// In es, this message translates to:
  /// **'Solo puedes corregir el importe al confirmar'**
  String get mf77a54e8a109;

  /// Sin comprobante
  ///
  /// In es, this message translates to:
  /// **'Sin comprobante'**
  String get mb7dfa133d92f;

  /// Indica la llegada del participante
  ///
  /// In es, this message translates to:
  /// **'Indica la llegada del participante'**
  String get m83eb65507a07;

  /// Espera un minuto para reenviar
  ///
  /// In es, this message translates to:
  /// **'Espera un minuto para reenviar'**
  String get m4570e41a637a;

  /// Concepto no encontrado
  ///
  /// In es, this message translates to:
  /// **'Concepto no encontrado'**
  String get m58dc2e8ee1b6;

  /// El presupuesto cambió. Recarga antes de guardar
  ///
  /// In es, this message translates to:
  /// **'El presupuesto cambió. Recarga antes de guardar'**
  String get m955d89078916;

  /// Estado de tarea inválido
  ///
  /// In es, this message translates to:
  /// **'Estado de tarea inválido'**
  String get m1f5310613e92;

  /// Tarea no encontrada
  ///
  /// In es, this message translates to:
  /// **'Tarea no encontrada'**
  String get m16f493642166;

  /// La tarea cambió. Recarga antes de guardar
  ///
  /// In es, this message translates to:
  /// **'La tarea cambió. Recarga antes de guardar'**
  String get me3ca622ced17;

  /// Estado de inscripción inválido
  ///
  /// In es, this message translates to:
  /// **'Estado de inscripción inválido'**
  String get m65cf051293e4;

  /// Usa la inscripción actual de este participante
  ///
  /// In es, this message translates to:
  /// **'Usa la inscripción actual de este participante'**
  String get m2f06eab757b0;

  /// No tienes una inscripción activa
  ///
  /// In es, this message translates to:
  /// **'No tienes una inscripción activa'**
  String get m70895aa89021;

  /// El abono supera el saldo disponible; revisa también los comprobantes pendientes
  ///
  /// In es, this message translates to:
  /// **'El abono supera el saldo disponible; revisa también los comprobantes pendientes'**
  String get m78fc5691b395;

  /// Adjunta el comprobante de este abono
  ///
  /// In es, this message translates to:
  /// **'Adjunta el comprobante de este abono'**
  String get m90045f68e286;

  /// Comprobante no encontrado
  ///
  /// In es, this message translates to:
  /// **'Comprobante no encontrado'**
  String get m29634a59b493;

  /// Indica una edad válida
  ///
  /// In es, this message translates to:
  /// **'Indica una edad válida'**
  String get m200e02ee2f93;

  /// Autoriza el uso de estos datos para organizar la actividad y atender necesidades de salud
  ///
  /// In es, this message translates to:
  /// **'Autoriza el uso de estos datos para organizar la actividad y atender necesidades de salud'**
  String get m2fba42fd67cb;

  /// El abono supera el costo de la actividad
  ///
  /// In es, this message translates to:
  /// **'El abono supera el costo de la actividad'**
  String get mcd00915d6091;

  /// Esta actividad es gratuita
  ///
  /// In es, this message translates to:
  /// **'Esta actividad es gratuita'**
  String get mc0465a03a167;

  /// Indica el importe del comprobante
  ///
  /// In es, this message translates to:
  /// **'Indica el importe del comprobante'**
  String get md12ffcf23626;

  /// Esta inscripción fue retirada. Contacta al organizador para restaurarla
  ///
  /// In es, this message translates to:
  /// **'Esta inscripción fue retirada. Contacta al organizador para restaurarla'**
  String get m6aee14131ee9;

  /// Este correo ya está inscrito. Revisa tu confirmación o contacta al organizador
  ///
  /// In es, this message translates to:
  /// **'Este correo ya está inscrito. Revisa tu confirmación o contacta al organizador'**
  String get mbb188e3da48a;

  /// Tu inscripción está registrada
  ///
  /// In es, this message translates to:
  /// **'Tu inscripción está registrada'**
  String get mbaf468631bbc;

  /// Pega un enlace de Google Maps
  ///
  /// In es, this message translates to:
  /// **'Pega un enlace de Google Maps'**
  String get mcad70a967781;

  /// Enlace de Google Maps inválido
  ///
  /// In es, this message translates to:
  /// **'Enlace de Google Maps inválido'**
  String get md76ced269452;

  /// Usa un enlace HTTPS de Google Maps
  ///
  /// In es, this message translates to:
  /// **'Usa un enlace HTTPS de Google Maps'**
  String get mde442e11310f;

  /// El enlace debe abrir Google Maps
  ///
  /// In es, this message translates to:
  /// **'El enlace debe abrir Google Maps'**
  String get m2a05d1d77e28;

  /// Enlace de ubicación inválido
  ///
  /// In es, this message translates to:
  /// **'Enlace de ubicación inválido'**
  String get m49a3423c6c8e;

  /// No puedes configurar actividades
  ///
  /// In es, this message translates to:
  /// **'No puedes configurar actividades'**
  String get m2ced94e9045d;

  /// El ámbito del retiro se conserva; crea otro retiro para otro ámbito
  ///
  /// In es, this message translates to:
  /// **'El ámbito del retiro se conserva; crea otro retiro para otro ámbito'**
  String get m0d919371e19d;

  /// Usa el panel de administradores para cambiar el equipo
  ///
  /// In es, this message translates to:
  /// **'Usa el panel de administradores para cambiar el equipo'**
  String get m10bbaa56ac43;

  /// Con inscripciones o presupuesto, la moneda se conserva
  ///
  /// In es, this message translates to:
  /// **'Con inscripciones o presupuesto, la moneda se conserva'**
  String get m59e9188b7e6d;

  /// No tienes acceso a esta actividad
  ///
  /// In es, this message translates to:
  /// **'No tienes acceso a esta actividad'**
  String get m84ee9196db1f;

  /// Solo desde líder de zona puedes crear actividades
  ///
  /// In es, this message translates to:
  /// **'Solo desde líder de zona puedes crear actividades'**
  String get m3cc36d0adf9d;

  /// Selecciona tu zona
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu zona'**
  String get m926873e3160a;

  /// Primero debes tener una zona asignada
  ///
  /// In es, this message translates to:
  /// **'Primero debes tener una zona asignada'**
  String get m90619fc3f069;

  /// Selecciona un sector a tu cargo
  ///
  /// In es, this message translates to:
  /// **'Selecciona un sector a tu cargo'**
  String get mf15d8e431c90;

  /// Revisa las fechas del retiro
  ///
  /// In es, this message translates to:
  /// **'Revisa las fechas del retiro'**
  String get m6e190b8117b9;

  /// Tipo de actividad inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo de actividad inválido'**
  String get mf00b08d43d4a;

  /// Indica el titular de la cuenta bancaria
  ///
  /// In es, this message translates to:
  /// **'Indica el titular de la cuenta bancaria'**
  String get m33685b17972c;

  /// Indica el titular de Yape
  ///
  /// In es, this message translates to:
  /// **'Indica el titular de Yape'**
  String get ma1911806fcad;

  /// Revisa el número de contacto o Yape
  ///
  /// In es, this message translates to:
  /// **'Revisa el número de contacto o Yape'**
  String get m419e43e81f6d;

  /// Usa un enlace HTTPS válido para la ubicación
  ///
  /// In es, this message translates to:
  /// **'Usa un enlace HTTPS válido para la ubicación'**
  String get m7f15ead7ddca;

  /// Has enviado varios tickets. Espera unos minutos antes de volver a intentarlo.
  ///
  /// In es, this message translates to:
  /// **'Has enviado varios tickets. Espera unos minutos antes de volver a intentarlo.'**
  String get m91d14507d898;

  /// Adjunto no encontrado
  ///
  /// In es, this message translates to:
  /// **'Adjunto no encontrado'**
  String get ma010dadcb816;

  /// Ticket no encontrado
  ///
  /// In es, this message translates to:
  /// **'Ticket no encontrado'**
  String get mf81afa4e7d14;

  /// Identificador de envío inválido
  ///
  /// In es, this message translates to:
  /// **'Identificador de envío inválido'**
  String get mcc2df05fb40a;

  /// Describe tu consulta en un máximo de 10 000 caracteres
  ///
  /// In es, this message translates to:
  /// **'Describe tu consulta en un máximo de 10 000 caracteres'**
  String get m813c6916d060;

  /// Puedes adjuntar hasta tres imágenes
  ///
  /// In es, this message translates to:
  /// **'Puedes adjuntar hasta tres imágenes'**
  String get mdff180f4b7dd;

  /// Estado o versión inválidos
  ///
  /// In es, this message translates to:
  /// **'Estado o versión inválidos'**
  String get m579cb4a65d83;

  /// El ticket cambió. Actualiza el tablero.
  ///
  /// In es, this message translates to:
  /// **'El ticket cambió. Actualiza el tablero.'**
  String get m761f95c6de55;

  /// Este ticket ya está resuelto. Puedes consultar su historial.
  ///
  /// In es, this message translates to:
  /// **'Este ticket ya está resuelto. Puedes consultar su historial.'**
  String get m3fdd36193a57;

  /// Otro administrador actualizó este ticket. Recarga el tablero.
  ///
  /// In es, this message translates to:
  /// **'Otro administrador actualizó este ticket. Recarga el tablero.'**
  String get m89823083559e;

  /// Gasto pendiente no encontrado
  ///
  /// In es, this message translates to:
  /// **'Gasto pendiente no encontrado'**
  String get m41f465b12418;

  /// Este gasto ya se está registrando con otros datos
  ///
  /// In es, this message translates to:
  /// **'Este gasto ya se está registrando con otros datos'**
  String get mdc93cb56f353;

  /// El gasto cambió; actualiza Tesorería
  ///
  /// In es, this message translates to:
  /// **'El gasto cambió; actualiza Tesorería'**
  String get mdbf1c2759296;

  /// Tipo de movimiento inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo de movimiento inválido'**
  String get m4a2ee0949167;

  /// Cuenta no encontrada
  ///
  /// In es, this message translates to:
  /// **'Cuenta no encontrada'**
  String get m8daa990493d2;

  /// El movimiento es anterior a la apertura de la cuenta
  ///
  /// In es, this message translates to:
  /// **'El movimiento es anterior a la apertura de la cuenta'**
  String get m27073581d1fb;

  /// Tipo de ingreso inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo de ingreso inválido'**
  String get mf5f39f96db78;

  /// Elige otra cuenta de destino
  ///
  /// In es, this message translates to:
  /// **'Elige otra cuenta de destino'**
  String get me2059fda0b75;

  /// El movimiento es anterior a la cuenta de destino
  ///
  /// In es, this message translates to:
  /// **'El movimiento es anterior a la cuenta de destino'**
  String get m670bdaa46ce4;

  /// Usa transferencia para la misma moneda o cambio para monedas distintas
  ///
  /// In es, this message translates to:
  /// **'Usa transferencia para la misma moneda o cambio para monedas distintas'**
  String get mfca19193c1f1;

  /// Este movimiento no tiene cuenta de destino
  ///
  /// In es, this message translates to:
  /// **'Este movimiento no tiene cuenta de destino'**
  String get m77cf946036a8;

  /// Solo un ingreso puede vincularse a un integrante
  ///
  /// In es, this message translates to:
  /// **'Solo un ingreso puede vincularse a un integrante'**
  String get m38dabda97d0e;

  /// Integrante activo no encontrado
  ///
  /// In es, this message translates to:
  /// **'Integrante activo no encontrado'**
  String get mcbd9849028ee;

  /// El diezmo debe vincularse a un integrante
  ///
  /// In es, this message translates to:
  /// **'El diezmo debe vincularse a un integrante'**
  String get m214470b25f8d;

  /// El período de diezmo solo corresponde a un diezmo
  ///
  /// In es, this message translates to:
  /// **'El período de diezmo solo corresponde a un diezmo'**
  String get m4d5b3adefbed;

  /// Recaudación no encontrada
  ///
  /// In es, this message translates to:
  /// **'Recaudación no encontrada'**
  String get m83af83da004c;

  /// Selecciona la recaudación
  ///
  /// In es, this message translates to:
  /// **'Selecciona la recaudación'**
  String get m1a4f648d569a;

  /// Este envío ya se utilizó con otros datos
  ///
  /// In es, this message translates to:
  /// **'Este envío ya se utilizó con otros datos'**
  String get mb825e617b2d1;

  /// El movimiento o pago mensual ya fue registrado. Actualiza la lista.
  ///
  /// In es, this message translates to:
  /// **'El movimiento o pago mensual ya fue registrado. Actualiza la lista.'**
  String get m3ca594bc8ca5;

  /// Movimiento no encontrado
  ///
  /// In es, this message translates to:
  /// **'Movimiento no encontrado'**
  String get m63eebdee1962;

  /// El movimiento cambió o ya está anulado
  ///
  /// In es, this message translates to:
  /// **'El movimiento cambió o ya está anulado'**
  String get mb19740ce1ed5;

  /// Anula el pago recurrente y vuelve a confirmarlo para corregirlo
  ///
  /// In es, this message translates to:
  /// **'Anula el pago recurrente y vuelve a confirmarlo para corregirlo'**
  String get m5c67c182b62f;

  /// Otra persona modificó este movimiento. Actualiza antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'Otra persona modificó este movimiento. Actualiza antes de guardar.'**
  String get m9ca0e3360825;

  /// Tipo inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo inválido'**
  String get m86b1a6a5d8b3;

  /// Los gastos recurrentes solo permiten gastos
  ///
  /// In es, this message translates to:
  /// **'Los gastos recurrentes solo permiten gastos'**
  String get m2d38a11682a1;

  /// El primer vencimiento es anterior a la apertura de la cuenta
  ///
  /// In es, this message translates to:
  /// **'El primer vencimiento es anterior a la apertura de la cuenta'**
  String get m2738e00c1eb4;

  /// El final debe ser posterior al inicio
  ///
  /// In es, this message translates to:
  /// **'El final debe ser posterior al inicio'**
  String get md74dc06a104f;

  /// La programación cambió. Actualiza antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'La programación cambió. Actualiza antes de guardar.'**
  String get md38a944694a3;

  /// Programación activa no encontrada
  ///
  /// In es, this message translates to:
  /// **'Programación activa no encontrada'**
  String get m6ea9c37c4f6f;

  /// La fecha no pertenece a esta programación
  ///
  /// In es, this message translates to:
  /// **'La fecha no pertenece a esta programación'**
  String get mbf4d413e2b1e;

  /// El envío ya se usó con otro informe
  ///
  /// In es, this message translates to:
  /// **'El envío ya se usó con otro informe'**
  String get mac6ff12f490b;

  /// Selecciona hasta 50 destinatarios
  ///
  /// In es, this message translates to:
  /// **'Selecciona hasta 50 destinatarios'**
  String get m99af6b81518a;

  /// Solo puedes enviar a responsables autorizados de tu iglesia
  ///
  /// In es, this message translates to:
  /// **'Solo puedes enviar a responsables autorizados de tu iglesia'**
  String get mf6863b8c3c2d;

  /// Selecciona hasta 100 integrantes
  ///
  /// In es, this message translates to:
  /// **'Selecciona hasta 100 integrantes'**
  String get m6e8e70e47db2;

  /// Selección de integrantes inválida
  ///
  /// In es, this message translates to:
  /// **'Selección de integrantes inválida'**
  String get me2a6a0876b4d;

  /// Selecciona hasta 100 integrantes para este informe
  ///
  /// In es, this message translates to:
  /// **'Selecciona hasta 100 integrantes para este informe'**
  String get ma72428126a15;

  /// Uno de los integrantes no pertenece a tu iglesia
  ///
  /// In es, this message translates to:
  /// **'Uno de los integrantes no pertenece a tu iglesia'**
  String get mdf7ae4ea1c7a;

  /// El informe cambió
  ///
  /// In es, this message translates to:
  /// **'El informe cambió'**
  String get mdb93eb5a2e49;

  /// Moneda o tipo de cuenta inválido
  ///
  /// In es, this message translates to:
  /// **'Moneda o tipo de cuenta inválido'**
  String get mc61bb8524d88;

  /// Ya existe una cuenta con ese nombre y moneda
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con ese nombre y moneda'**
  String get mf76d7d33faa4;

  /// Reduce el período para exportar hasta 5000 movimientos
  ///
  /// In es, this message translates to:
  /// **'Reduce el período para exportar hasta 5000 movimientos'**
  String get mbc986cd07aed;

  /// Confirma si el integrante no diezmó
  ///
  /// In es, this message translates to:
  /// **'Confirma si el integrante no diezmó'**
  String get m240e37d056df;

  /// El registro cambió
  ///
  /// In es, this message translates to:
  /// **'El registro cambió'**
  String get me2beeb7d204c;

  /// Otra persona actualizó este registro
  ///
  /// In es, this message translates to:
  /// **'Otra persona actualizó este registro'**
  String get m04edd6ea1cfe;

  /// Otra persona actualizó este registro. Recarga para continuar.
  ///
  /// In es, this message translates to:
  /// **'Otra persona actualizó este registro. Recarga para continuar.'**
  String get mf5d098c43d4c;

  /// La fecha no es válida o todavía no ocurrió
  ///
  /// In es, this message translates to:
  /// **'La fecha no es válida o todavía no ocurrió'**
  String get m277c4be531e5;

  /// Mes inválido
  ///
  /// In es, this message translates to:
  /// **'Mes inválido'**
  String get m741a0b66a9db;

  /// Elige un período de hasta 366 días
  ///
  /// In es, this message translates to:
  /// **'Elige un período de hasta 366 días'**
  String get m96333c4a6e2e;

  /// Usa un importe positivo con hasta dos decimales
  ///
  /// In es, this message translates to:
  /// **'Usa un importe positivo con hasta dos decimales'**
  String get mf06450f0ff8e;

  /// Identificador inválido
  ///
  /// In es, this message translates to:
  /// **'Identificador inválido'**
  String get m50ea273de177;

  /// Informe no encontrado
  ///
  /// In es, this message translates to:
  /// **'Informe no encontrado'**
  String get m29ede22e05e0;

  /// Permiso inválido
  ///
  /// In es, this message translates to:
  /// **'Permiso inválido'**
  String get m315464ee7e4e;

  /// La cuenta cambió o no está disponible en tu iglesia
  ///
  /// In es, this message translates to:
  /// **'La cuenta cambió o no está disponible en tu iglesia'**
  String get md31b5ca3140c;

  /// Suspende la cuenta para conservar el historial de la iglesia
  ///
  /// In es, this message translates to:
  /// **'Suspende la cuenta para conservar el historial de la iglesia'**
  String get mf5e84453cbc0;

  /// Seguimiento no encontrado
  ///
  /// In es, this message translates to:
  /// **'Seguimiento no encontrado'**
  String get md9975093224b;

  /// Elige un responsable activo dentro de tu ámbito
  ///
  /// In es, this message translates to:
  /// **'Elige un responsable activo dentro de tu ámbito'**
  String get mb6d0ef688b57;

  /// El próximo contacto no puede preceder a la primera visita
  ///
  /// In es, this message translates to:
  /// **'El próximo contacto no puede preceder a la primera visita'**
  String get mfeb31aebde39;

  /// Ya hay un seguimiento abierto con ese correo
  ///
  /// In es, this message translates to:
  /// **'Ya hay un seguimiento abierto con ese correo'**
  String get ma6500ddb5460;

  /// Fecha anterior a la primera visita
  ///
  /// In es, this message translates to:
  /// **'Fecha anterior a la primera visita'**
  String get m9865897c085a;

  /// El seguimiento cambió. Actualiza antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'El seguimiento cambió. Actualiza antes de guardar.'**
  String get m646b2d16d4ba;

  /// Tipo de contacto inválido
  ///
  /// In es, this message translates to:
  /// **'Tipo de contacto inválido'**
  String get m3bab6485aa4a;

  /// El contacto no puede preceder a la primera visita
  ///
  /// In es, this message translates to:
  /// **'El contacto no puede preceder a la primera visita'**
  String get mffa9033cb89d;

  /// Este envío ya se utilizó
  ///
  /// In es, this message translates to:
  /// **'Este envío ya se utilizó'**
  String get m6e0286eea0ba;

  /// Cierre inválido
  ///
  /// In es, this message translates to:
  /// **'Cierre inválido'**
  String get mefcf39eaac40;

  /// El próximo contacto debe ser posterior o igual al contacto registrado
  ///
  /// In es, this message translates to:
  /// **'El próximo contacto debe ser posterior o igual al contacto registrado'**
  String get m40ab2273d10c;

  /// Elige una persona activa
  ///
  /// In es, this message translates to:
  /// **'Elige una persona activa'**
  String get m53b3357bbc18;

  /// El seguimiento cambió. Actualiza antes de vincular.
  ///
  /// In es, this message translates to:
  /// **'El seguimiento cambió. Actualiza antes de vincular.'**
  String get mfe70281bf7b5;

  /// El owner debe asignar esta zona a un sector
  ///
  /// In es, this message translates to:
  /// **'El owner debe asignar esta zona a un sector'**
  String get ma45599925205;

  /// La zona todavía tiene células activas
  ///
  /// In es, this message translates to:
  /// **'La zona todavía tiene células activas'**
  String get m6154fd0dea5d;

  /// Sin acceso
  ///
  /// In es, this message translates to:
  /// **'Sin acceso'**
  String get m8e647845ce8c;

  /// Revisa la fecha indicada
  ///
  /// In es, this message translates to:
  /// **'Revisa la fecha indicada'**
  String get m4ba5d091135e;

  /// Ruta no encontrada
  ///
  /// In es, this message translates to:
  /// **'Ruta no encontrada'**
  String get mc960040bb747;

  /// La petición es demasiado grande
  ///
  /// In es, this message translates to:
  /// **'La petición es demasiado grande'**
  String get mfbd411cea5d3;

  /// JSON inválido
  ///
  /// In es, this message translates to:
  /// **'JSON inválido'**
  String get mad9f8ac43207;

  /// Otra persona actualizó este registro. Recarga antes de guardar.
  ///
  /// In es, this message translates to:
  /// **'Otra persona actualizó este registro. Recarga antes de guardar.'**
  String get m0afbba58fd4b;

  /// Dato inválido
  ///
  /// In es, this message translates to:
  /// **'Dato inválido'**
  String get ma360cee02fc5;

  /// Ya existe un registro con esos datos
  ///
  /// In es, this message translates to:
  /// **'Ya existe un registro con esos datos'**
  String get m000fe1c08252;

  /// Error interno del servidor
  ///
  /// In es, this message translates to:
  /// **'Error interno del servidor'**
  String get m66d8af67c3da;

  /// {{p0}} es obligatorio
  ///
  /// In es, this message translates to:
  /// **'{p0} es obligatorio'**
  String mb53e2632bac2(String p0);

  /// {{p0}} es demasiado largo (máximo {{p1}} caracteres)
  ///
  /// In es, this message translates to:
  /// **'{p0} es demasiado largo (máximo {p1} caracteres)'**
  String m5f57d0531daf(String p0, String p1);

  /// Petición inválida
  ///
  /// In es, this message translates to:
  /// **'Petición inválida'**
  String get md051f9debd87;

  /// Agrega hasta 8 enlaces
  ///
  /// In es, this message translates to:
  /// **'Agrega hasta 8 enlaces'**
  String get m4670c1601513;

  /// Escribe un enlace HTTPS válido
  ///
  /// In es, this message translates to:
  /// **'Escribe un enlace HTTPS válido'**
  String get md21305a0d8f4;

  /// Los enlaces deben usar HTTPS y no incluir credenciales
  ///
  /// In es, this message translates to:
  /// **'Los enlaces deben usar HTTPS y no incluir credenciales'**
  String get me33603bf73ec;

  /// Para organizar y acompañar a una comunidad que empieza.
  ///
  /// In es, this message translates to:
  /// **'Para organizar y acompañar a una comunidad que empieza.'**
  String get mcf28643de99c;

  /// Para una iglesia con más equipos y comunidades.
  ///
  /// In es, this message translates to:
  /// **'Para una iglesia con más equipos y comunidades.'**
  String get mffe1028c4468;

  /// Para coordinar una iglesia con varios equipos y comunidades.
  ///
  /// In es, this message translates to:
  /// **'Para coordinar una iglesia con varios equipos y comunidades.'**
  String get m915220d46810;

  /// Para coordinar una congregación sin topes de integrantes ni equipos.
  ///
  /// In es, this message translates to:
  /// **'Para coordinar una congregación sin topes de integrantes ni equipos.'**
  String get m879c9381646c;

  /// Guardar
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get m13e51a210f45;

  /// Inicio
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get m58fcc9468fe1;

  /// Añadir integrante
  ///
  /// In es, this message translates to:
  /// **'Añadir integrante'**
  String get cellMemberRegistration0;

  /// Registra sus datos para la asistencia. No se crea una cuenta ni se envía una invitación.
  ///
  /// In es, this message translates to:
  /// **'Registra sus datos para la asistencia. No se crea una cuenta ni se envía una invitación.'**
  String get cellMemberRegistration1;

  /// Nombre completo
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get cellMemberRegistration2;

  /// Escribe el nombre del integrante.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre del integrante.'**
  String get cellMemberRegistration3;

  /// Correo electrónico (opcional)
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico (opcional)'**
  String get cellMemberRegistration4;

  /// Introduce un correo válido o deja el campo vacío.
  ///
  /// In es, this message translates to:
  /// **'Introduce un correo válido o deja el campo vacío.'**
  String get cellMemberRegistration5;

  /// Edad (opcional)
  ///
  /// In es, this message translates to:
  /// **'Edad (opcional)'**
  String get cellMemberRegistration6;

  /// La edad debe estar entre 0 y 120 años.
  ///
  /// In es, this message translates to:
  /// **'La edad debe estar entre 0 y 120 años.'**
  String get cellMemberRegistration7;

  /// Cumpleaños (opcional)
  ///
  /// In es, this message translates to:
  /// **'Cumpleaños (opcional)'**
  String get cellMemberRegistration8;

  /// Elegir cumpleaños
  ///
  /// In es, this message translates to:
  /// **'Elegir cumpleaños'**
  String get cellMemberRegistration9;

  /// Quitar cumpleaños
  ///
  /// In es, this message translates to:
  /// **'Quitar cumpleaños'**
  String get cellMemberRegistration10;

  /// Guardar integrante
  ///
  /// In es, this message translates to:
  /// **'Guardar integrante'**
  String get cellMemberRegistration11;

  /// Si sales ahora, perderás los datos de este integrante.
  ///
  /// In es, this message translates to:
  /// **'Si sales ahora, perderás los datos de este integrante.'**
  String get cellMemberRegistration12;

  /// Integrante añadido a la célula.
  ///
  /// In es, this message translates to:
  /// **'Integrante añadido a la célula.'**
  String get cellMemberRegistration13;

  /// Integrantes
  ///
  /// In es, this message translates to:
  /// **'Integrantes'**
  String get cellWorkspace0;

  /// Buscar integrante
  ///
  /// In es, this message translates to:
  /// **'Buscar integrante'**
  String get cellWorkspace1;

  /// Limpiar búsqueda
  ///
  /// In es, this message translates to:
  /// **'Limpiar búsqueda'**
  String get cellWorkspace2;

  /// No encontramos integrantes con ese nombre.
  ///
  /// In es, this message translates to:
  /// **'No encontramos integrantes con ese nombre.'**
  String get cellWorkspace3;

  /// Añadir datos opcionales
  ///
  /// In es, this message translates to:
  /// **'Añadir datos opcionales'**
  String get cellWorkspace4;

  /// Fecha del encuentro
  ///
  /// In es, this message translates to:
  /// **'Fecha del encuentro'**
  String get cellWorkspace5;

  /// Próximo encuentro
  ///
  /// In es, this message translates to:
  /// **'Próximo encuentro'**
  String get cellWorkspace6;

  /// Elegir fecha
  ///
  /// In es, this message translates to:
  /// **'Elegir fecha'**
  String get cellWorkspace7;

  /// Gestionar actividades
  ///
  /// In es, this message translates to:
  /// **'Gestionar actividades'**
  String get cellWorkspace8;

  /// Opciones de asistencia
  ///
  /// In es, this message translates to:
  /// **'Opciones de asistencia'**
  String get cellWorkspace9;

  /// Tema y foto del encuentro
  ///
  /// In es, this message translates to:
  /// **'Tema y foto del encuentro'**
  String get cellWorkspace10;

  /// Quitar marca
  ///
  /// In es, this message translates to:
  /// **'Quitar marca'**
  String get cellWorkspace11;

  /// Tema del encuentro
  ///
  /// In es, this message translates to:
  /// **'Tema del encuentro'**
  String get photoPickerFix0;

  /// El selector de fotos no respondió. Ciérralo y vuelve a intentarlo.
  ///
  /// In es, this message translates to:
  /// **'El selector de fotos no respondió. Ciérralo y vuelve a intentarlo.'**
  String get photoPickerFix1;

  /// La foto tardó demasiado en prepararse. Intenta con otra imagen.
  ///
  /// In es, this message translates to:
  /// **'La foto tardó demasiado en prepararse. Intenta con otra imagen.'**
  String get photoPickerFix2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
