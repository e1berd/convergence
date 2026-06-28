///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsRu with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override String get version => '1.0.0';
	@override late final _Translations$app$ru app = _Translations$app$ru._(_root);
	@override late final _Translations$nav$ru nav = _Translations$nav$ru._(_root);
	@override late final _Translations$navShort$ru navShort = _Translations$navShort$ru._(_root);
	@override late final _Translations$common$ru common = _Translations$common$ru._(_root);
	@override late final _Translations$engine$ru engine = _Translations$engine$ru._(_root);
	@override late final _Translations$status$ru status = _Translations$status$ru._(_root);
	@override late final _Translations$folders$ru folders = _Translations$folders$ru._(_root);
	@override late final _Translations$devices$ru devices = _Translations$devices$ru._(_root);
	@override late final _Translations$activity$ru activity = _Translations$activity$ru._(_root);
	@override late final _Translations$settings$ru settings = _Translations$settings$ru._(_root);
}

// Path: app
class _Translations$app$ru implements Translations$app$en {
	_Translations$app$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get name => 'Syncthing';
}

// Path: nav
class _Translations$nav$ru implements Translations$nav$en {
	_Translations$nav$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get status => 'Статус';
	@override String get folders => 'Папки';
	@override String get devices => 'Устройства';
	@override String get activity => 'Активность';
	@override String get settings => 'Настройки';
}

// Path: navShort
class _Translations$navShort$ru implements Translations$navShort$en {
	_Translations$navShort$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get status => 'Статус';
	@override String get folders => 'Папки';
	@override String get devices => 'Устройства';
	@override String get activity => 'Активность';
	@override String get settings => 'Настройки';
}

// Path: common
class _Translations$common$ru implements Translations$common$en {
	_Translations$common$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get add => 'Добавить';
	@override String get cancel => 'Отмена';
	@override String get save => 'Сохранить';
	@override String get remove => 'Удалить';
	@override String get close => 'Закрыть';
	@override String get retry => 'Повторить';
	@override String get edit => 'Изменить';
	@override String get pause => 'Пауза';
	@override String get resume => 'Возобновить';
	@override String get online => 'В сети';
	@override String get offline => 'Не в сети';
	@override String get unknown => 'Неизвестно';
	@override String get copied => 'Скопировано';
	@override String perSecond({required Object value}) => '${value}/с';
}

// Path: engine
class _Translations$engine$ru implements Translations$engine$en {
	_Translations$engine$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get starting => 'Запуск движка';
	@override String get running => 'Движок работает';
	@override String get stopped => 'Движок остановлен';
	@override String get error => 'Ошибка движка';
	@override String get remote => 'Удалённый движок';
	@override String get restart => 'Перезапустить';
	@override String get shutdown => 'Выключить';
	@override String get restarting => 'Перезапуск движка';
	@override String get connectFailed => 'Нет связи с Syncthing';
	@override String get bundledTitle => 'Встроенный движок';
	@override String get bundledSubtitle => 'Запускать и управлять Syncthing внутри приложения';
	@override String get remoteTitle => 'Удалённый движок';
	@override String get remoteSubtitle => 'Подключиться к существующему Syncthing';
	@override String get remoteUrl => 'Адрес сервера';
	@override String get remoteApiKey => 'API-ключ';
	@override String get apply => 'Применить';
}

// Path: status
class _Translations$status$ru implements Translations$status$en {
	_Translations$status$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get overview => 'Обзор';
	@override String get state => 'Состояние';
	@override String get uptime => 'Аптайм';
	@override String get download => 'Загрузка';
	@override String get upload => 'Отдача';
	@override String get totalFiles => 'Файлы';
	@override String get totalFolders => 'Папки';
	@override String get totalDevices => 'Устройства';
	@override String get thisDevice => 'Это устройство';
	@override String get deviceId => 'ID устройства';
	@override String get version => 'Версия';
	@override String get listeners => 'Слушатели';
	@override String get discovery => 'Обнаружение';
	@override String get idle => 'Синхронизировано';
	@override String get syncing => 'Синхронизация';
	@override String get scanning => 'Сканирование';
	@override String get paused => 'Пауза';
	@override String get disconnected => 'Отключено';
	@override String connected({required Object n}) => 'Подключено: ${n}';
	@override String get empty => 'Движок ещё не готов';
}

// Path: folders
class _Translations$folders$ru implements Translations$folders$en {
	_Translations$folders$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Папки';
	@override String get add => 'Добавить папку';
	@override String get empty => 'Папок пока нет';
	@override String get emptyHint => 'Добавьте папку, чтобы синхронизировать её между устройствами.';
	@override String get label => 'Название';
	@override String get folderId => 'ID папки';
	@override String get path => 'Путь к папке';
	@override String get choosePath => 'Выбрать путь';
	@override String get type => 'Тип папки';
	@override String get typeSendReceive => 'Приём и отправка';
	@override String get typeSendOnly => 'Только отправка';
	@override String get typeReceiveOnly => 'Только приём';
	@override String get sharedWith => 'Доступ устройствам';
	@override String get rescan => 'Пересканировать';
	@override String get rescanIntervalLabel => 'Пересканирование';
	@override String get scanNow => 'Сканировать';
	@override String get globalState => 'Глобально';
	@override String get localState => 'Локально';
	@override String needItems({required Object n}) => 'К синхронизации: ${n}';
	@override String get state => 'Состояние';
	@override String get remove => 'Удалить папку';
	@override String get removeConfirm => 'Удалить эту папку из Syncthing? Файлы на диске останутся.';
	@override String get open => 'Открыть папку';
	@override String get openFailed => 'Не удалось открыть папку';
	@override String get added => 'Папка добавлена';
	@override String get noDevices => 'Сначала добавьте устройство, чтобы делиться папками.';
}

// Path: devices
class _Translations$devices$ru implements Translations$devices$en {
	_Translations$devices$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Устройства';
	@override String get add => 'Добавить устройство';
	@override String get empty => 'Нет удалённых устройств';
	@override String get emptyHint => 'Добавьте устройство по ID или отсканируйте QR-код.';
	@override String get thisDevice => 'Это устройство';
	@override String get name => 'Имя устройства';
	@override String get id => 'ID устройства';
	@override String get idHint => 'Вставьте ID устройства или отсканируйте QR';
	@override String get scan => 'Сканировать QR';
	@override String get scanFromImage => 'Считать QR из изображения';
	@override String get qrNotFound => 'QR-код не найден на изображении';
	@override String get showQr => 'Показать мой QR';
	@override String get pairTitle => 'Сопряжение устройства';
	@override String get myQrTab => 'Мой QR';
	@override String get scanTab => 'Сканировать';
	@override String get myQrHint => 'Отсканируйте этот код с другого устройства, чтобы добавить его.';
	@override String get pointCamera => 'Наведите камеру на QR-код устройства';
	@override String get cameraUnsupported => 'Живая камера недоступна на этой платформе';
	@override String get introducer => 'Представитель';
	@override String get autoAccept => 'Автоприём папок';
	@override String get remove => 'Удалить устройство';
	@override String get removeConfirm => 'Удалить это устройство?';
	@override String get added => 'Устройство добавлено';
	@override String lastSeen({required Object when}) => 'Был(а) ${when}';
	@override String get download => 'Вход';
	@override String get upload => 'Выход';
	@override String get address => 'Адрес';
	@override String get pendingTitle => 'Хочет подключиться';
	@override String get pendingFolderTitle => 'Предложена папка';
	@override String get accept => 'Принять';
	@override String get dismiss => 'Отклонить';
}

// Path: activity
class _Translations$activity$ru implements Translations$activity$en {
	_Translations$activity$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Активность';
	@override String get empty => 'Активности пока нет';
	@override String get clear => 'Очистить';
	@override String get events => 'События';
	@override String get log => 'Лог движка';
	@override String get copyLog => 'Скопировать лог';
}

// Path: settings
class _Translations$settings$ru implements Translations$settings$en {
	_Translations$settings$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки';
	@override String get appearance => 'Внешний вид';
	@override String get themeSystem => 'Системная';
	@override String get themeLight => 'Светлая';
	@override String get themeDark => 'Тёмная';
	@override String get palette => 'Цветовая схема';
	@override String get languageTitle => 'Язык';
	@override String get languageSubtitle => 'Выберите язык интерфейса';
	@override String get languageEnglish => 'Английский';
	@override String get languageRussian => 'Русский';
	@override String get engine => 'Движок Syncthing';
	@override String get network => 'Сеть';
	@override String get natTitle => 'Обход NAT';
	@override String get natSubtitle => 'Разрешить Syncthing пробрасывать порты';
	@override String get globalDiscoveryTitle => 'Глобальное обнаружение';
	@override String get globalDiscoverySubtitle => 'Искать устройства через серверы обнаружения';
	@override String get localDiscoveryTitle => 'Локальное обнаружение';
	@override String get localDiscoverySubtitle => 'Искать устройства в локальной сети';
	@override String get relaysTitle => 'Реле';
	@override String get relaysSubtitle => 'Соединяться через реле, если прямое не удалось';
	@override String get limitsTitle => 'Ограничения скорости';
	@override String get downLimit => 'Лимит загрузки (КиБ/с)';
	@override String get upLimit => 'Лимит отдачи (КиБ/с)';
	@override String get security => 'Безопасность';
	@override String get guiAuthTitle => 'Аутентификация GUI';
	@override String get guiAuthSubtitle => 'Задайте логин и пароль, чтобы защитить GUI Syncthing на этом компьютере.';
	@override String get guiUser => 'Имя пользователя';
	@override String get guiPassword => 'Пароль';
	@override String get guiPasswordHint => 'Оставьте пустым, чтобы не менять пароль';
	@override String get guiAuthConfigured => 'Аутентификация настроена';
	@override String get guiAuthNotConfigured => 'Аутентификация не настроена';
	@override String get guiAuthSaved => 'Аутентификация GUI обновлена';
	@override String get guiClear => 'Отключить';
	@override String get about => 'О приложении';
	@override String get aboutSubtitle => 'Информация о движке и приложении';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'version' => '1.0.0',
			'app.name' => 'Syncthing',
			'nav.status' => 'Статус',
			'nav.folders' => 'Папки',
			'nav.devices' => 'Устройства',
			'nav.activity' => 'Активность',
			'nav.settings' => 'Настройки',
			'navShort.status' => 'Статус',
			'navShort.folders' => 'Папки',
			'navShort.devices' => 'Устройства',
			'navShort.activity' => 'Активность',
			'navShort.settings' => 'Настройки',
			'common.add' => 'Добавить',
			'common.cancel' => 'Отмена',
			'common.save' => 'Сохранить',
			'common.remove' => 'Удалить',
			'common.close' => 'Закрыть',
			'common.retry' => 'Повторить',
			'common.edit' => 'Изменить',
			'common.pause' => 'Пауза',
			'common.resume' => 'Возобновить',
			'common.online' => 'В сети',
			'common.offline' => 'Не в сети',
			'common.unknown' => 'Неизвестно',
			'common.copied' => 'Скопировано',
			'common.perSecond' => ({required Object value}) => '${value}/с',
			'engine.starting' => 'Запуск движка',
			'engine.running' => 'Движок работает',
			'engine.stopped' => 'Движок остановлен',
			'engine.error' => 'Ошибка движка',
			'engine.remote' => 'Удалённый движок',
			'engine.restart' => 'Перезапустить',
			'engine.shutdown' => 'Выключить',
			'engine.restarting' => 'Перезапуск движка',
			'engine.connectFailed' => 'Нет связи с Syncthing',
			'engine.bundledTitle' => 'Встроенный движок',
			'engine.bundledSubtitle' => 'Запускать и управлять Syncthing внутри приложения',
			'engine.remoteTitle' => 'Удалённый движок',
			'engine.remoteSubtitle' => 'Подключиться к существующему Syncthing',
			'engine.remoteUrl' => 'Адрес сервера',
			'engine.remoteApiKey' => 'API-ключ',
			'engine.apply' => 'Применить',
			'status.overview' => 'Обзор',
			'status.state' => 'Состояние',
			'status.uptime' => 'Аптайм',
			'status.download' => 'Загрузка',
			'status.upload' => 'Отдача',
			'status.totalFiles' => 'Файлы',
			'status.totalFolders' => 'Папки',
			'status.totalDevices' => 'Устройства',
			'status.thisDevice' => 'Это устройство',
			'status.deviceId' => 'ID устройства',
			'status.version' => 'Версия',
			'status.listeners' => 'Слушатели',
			'status.discovery' => 'Обнаружение',
			'status.idle' => 'Синхронизировано',
			'status.syncing' => 'Синхронизация',
			'status.scanning' => 'Сканирование',
			'status.paused' => 'Пауза',
			'status.disconnected' => 'Отключено',
			'status.connected' => ({required Object n}) => 'Подключено: ${n}',
			'status.empty' => 'Движок ещё не готов',
			'folders.title' => 'Папки',
			'folders.add' => 'Добавить папку',
			'folders.empty' => 'Папок пока нет',
			'folders.emptyHint' => 'Добавьте папку, чтобы синхронизировать её между устройствами.',
			'folders.label' => 'Название',
			'folders.folderId' => 'ID папки',
			'folders.path' => 'Путь к папке',
			'folders.choosePath' => 'Выбрать путь',
			'folders.type' => 'Тип папки',
			'folders.typeSendReceive' => 'Приём и отправка',
			'folders.typeSendOnly' => 'Только отправка',
			'folders.typeReceiveOnly' => 'Только приём',
			'folders.sharedWith' => 'Доступ устройствам',
			'folders.rescan' => 'Пересканировать',
			'folders.rescanIntervalLabel' => 'Пересканирование',
			'folders.scanNow' => 'Сканировать',
			'folders.globalState' => 'Глобально',
			'folders.localState' => 'Локально',
			'folders.needItems' => ({required Object n}) => 'К синхронизации: ${n}',
			'folders.state' => 'Состояние',
			'folders.remove' => 'Удалить папку',
			'folders.removeConfirm' => 'Удалить эту папку из Syncthing? Файлы на диске останутся.',
			'folders.open' => 'Открыть папку',
			'folders.openFailed' => 'Не удалось открыть папку',
			'folders.added' => 'Папка добавлена',
			'folders.noDevices' => 'Сначала добавьте устройство, чтобы делиться папками.',
			'devices.title' => 'Устройства',
			'devices.add' => 'Добавить устройство',
			'devices.empty' => 'Нет удалённых устройств',
			'devices.emptyHint' => 'Добавьте устройство по ID или отсканируйте QR-код.',
			'devices.thisDevice' => 'Это устройство',
			'devices.name' => 'Имя устройства',
			'devices.id' => 'ID устройства',
			'devices.idHint' => 'Вставьте ID устройства или отсканируйте QR',
			'devices.scan' => 'Сканировать QR',
			'devices.scanFromImage' => 'Считать QR из изображения',
			'devices.qrNotFound' => 'QR-код не найден на изображении',
			'devices.showQr' => 'Показать мой QR',
			'devices.pairTitle' => 'Сопряжение устройства',
			'devices.myQrTab' => 'Мой QR',
			'devices.scanTab' => 'Сканировать',
			'devices.myQrHint' => 'Отсканируйте этот код с другого устройства, чтобы добавить его.',
			'devices.pointCamera' => 'Наведите камеру на QR-код устройства',
			'devices.cameraUnsupported' => 'Живая камера недоступна на этой платформе',
			'devices.introducer' => 'Представитель',
			'devices.autoAccept' => 'Автоприём папок',
			'devices.remove' => 'Удалить устройство',
			'devices.removeConfirm' => 'Удалить это устройство?',
			'devices.added' => 'Устройство добавлено',
			'devices.lastSeen' => ({required Object when}) => 'Был(а) ${when}',
			'devices.download' => 'Вход',
			'devices.upload' => 'Выход',
			'devices.address' => 'Адрес',
			'devices.pendingTitle' => 'Хочет подключиться',
			'devices.pendingFolderTitle' => 'Предложена папка',
			'devices.accept' => 'Принять',
			'devices.dismiss' => 'Отклонить',
			'activity.title' => 'Активность',
			'activity.empty' => 'Активности пока нет',
			'activity.clear' => 'Очистить',
			'activity.events' => 'События',
			'activity.log' => 'Лог движка',
			'activity.copyLog' => 'Скопировать лог',
			'settings.title' => 'Настройки',
			'settings.appearance' => 'Внешний вид',
			'settings.themeSystem' => 'Системная',
			'settings.themeLight' => 'Светлая',
			'settings.themeDark' => 'Тёмная',
			'settings.palette' => 'Цветовая схема',
			'settings.languageTitle' => 'Язык',
			'settings.languageSubtitle' => 'Выберите язык интерфейса',
			'settings.languageEnglish' => 'Английский',
			'settings.languageRussian' => 'Русский',
			'settings.engine' => 'Движок Syncthing',
			'settings.network' => 'Сеть',
			'settings.natTitle' => 'Обход NAT',
			'settings.natSubtitle' => 'Разрешить Syncthing пробрасывать порты',
			'settings.globalDiscoveryTitle' => 'Глобальное обнаружение',
			'settings.globalDiscoverySubtitle' => 'Искать устройства через серверы обнаружения',
			'settings.localDiscoveryTitle' => 'Локальное обнаружение',
			'settings.localDiscoverySubtitle' => 'Искать устройства в локальной сети',
			'settings.relaysTitle' => 'Реле',
			'settings.relaysSubtitle' => 'Соединяться через реле, если прямое не удалось',
			'settings.limitsTitle' => 'Ограничения скорости',
			'settings.downLimit' => 'Лимит загрузки (КиБ/с)',
			'settings.upLimit' => 'Лимит отдачи (КиБ/с)',
			'settings.security' => 'Безопасность',
			'settings.guiAuthTitle' => 'Аутентификация GUI',
			'settings.guiAuthSubtitle' => 'Задайте логин и пароль, чтобы защитить GUI Syncthing на этом компьютере.',
			'settings.guiUser' => 'Имя пользователя',
			'settings.guiPassword' => 'Пароль',
			'settings.guiPasswordHint' => 'Оставьте пустым, чтобы не менять пароль',
			'settings.guiAuthConfigured' => 'Аутентификация настроена',
			'settings.guiAuthNotConfigured' => 'Аутентификация не настроена',
			'settings.guiAuthSaved' => 'Аутентификация GUI обновлена',
			'settings.guiClear' => 'Отключить',
			'settings.about' => 'О приложении',
			'settings.aboutSubtitle' => 'Информация о движке и приложении',
			_ => null,
		};
	}
}
