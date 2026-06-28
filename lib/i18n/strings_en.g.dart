///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: '1.0.0'
	String get version => '1.0.0';

	late final Translations$app$en app = Translations$app$en._(_root);
	late final Translations$nav$en nav = Translations$nav$en._(_root);
	late final Translations$navShort$en navShort = Translations$navShort$en._(_root);
	late final Translations$common$en common = Translations$common$en._(_root);
	late final Translations$engine$en engine = Translations$engine$en._(_root);
	late final Translations$status$en status = Translations$status$en._(_root);
	late final Translations$folders$en folders = Translations$folders$en._(_root);
	late final Translations$devices$en devices = Translations$devices$en._(_root);
	late final Translations$activity$en activity = Translations$activity$en._(_root);
	late final Translations$settings$en settings = Translations$settings$en._(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Syncthing'
	String get name => 'Syncthing';
}

// Path: nav
class Translations$nav$en {
	Translations$nav$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Folders'
	String get folders => 'Folders';

	/// en: 'Devices'
	String get devices => 'Devices';

	/// en: 'Activity'
	String get activity => 'Activity';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: navShort
class Translations$navShort$en {
	Translations$navShort$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Folders'
	String get folders => 'Folders';

	/// en: 'Devices'
	String get devices => 'Devices';

	/// en: 'Activity'
	String get activity => 'Activity';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: common
class Translations$common$en {
	Translations$common$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Pause'
	String get pause => 'Pause';

	/// en: 'Resume'
	String get resume => 'Resume';

	/// en: 'Online'
	String get online => 'Online';

	/// en: 'Offline'
	String get offline => 'Offline';

	/// en: 'Unknown'
	String get unknown => 'Unknown';

	/// en: 'Copied to clipboard'
	String get copied => 'Copied to clipboard';

	/// en: '{value}/s'
	String perSecond({required Object value}) => '${value}/s';
}

// Path: engine
class Translations$engine$en {
	Translations$engine$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Starting engine'
	String get starting => 'Starting engine';

	/// en: 'Engine running'
	String get running => 'Engine running';

	/// en: 'Engine stopped'
	String get stopped => 'Engine stopped';

	/// en: 'Engine error'
	String get error => 'Engine error';

	/// en: 'Remote engine'
	String get remote => 'Remote engine';

	/// en: 'Restart'
	String get restart => 'Restart';

	/// en: 'Shut down'
	String get shutdown => 'Shut down';

	/// en: 'Restarting engine'
	String get restarting => 'Restarting engine';

	/// en: 'Could not reach Syncthing'
	String get connectFailed => 'Could not reach Syncthing';

	/// en: 'Bundled engine'
	String get bundledTitle => 'Bundled engine';

	/// en: 'Run and manage Syncthing inside this app'
	String get bundledSubtitle => 'Run and manage Syncthing inside this app';

	/// en: 'Remote engine'
	String get remoteTitle => 'Remote engine';

	/// en: 'Connect to an existing Syncthing instance'
	String get remoteSubtitle => 'Connect to an existing Syncthing instance';

	/// en: 'Server URL'
	String get remoteUrl => 'Server URL';

	/// en: 'API key'
	String get remoteApiKey => 'API key';

	/// en: 'Apply'
	String get apply => 'Apply';
}

// Path: status
class Translations$status$en {
	Translations$status$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Overview'
	String get overview => 'Overview';

	/// en: 'State'
	String get state => 'State';

	/// en: 'Uptime'
	String get uptime => 'Uptime';

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'Upload'
	String get upload => 'Upload';

	/// en: 'Files'
	String get totalFiles => 'Files';

	/// en: 'Folders'
	String get totalFolders => 'Folders';

	/// en: 'Devices'
	String get totalDevices => 'Devices';

	/// en: 'This device'
	String get thisDevice => 'This device';

	/// en: 'Device ID'
	String get deviceId => 'Device ID';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Listeners'
	String get listeners => 'Listeners';

	/// en: 'Discovery'
	String get discovery => 'Discovery';

	/// en: 'Up to date'
	String get idle => 'Up to date';

	/// en: 'Syncing'
	String get syncing => 'Syncing';

	/// en: 'Scanning'
	String get scanning => 'Scanning';

	/// en: 'Paused'
	String get paused => 'Paused';

	/// en: 'Disconnected'
	String get disconnected => 'Disconnected';

	/// en: '{n} connected'
	String connected({required Object n}) => '${n} connected';

	/// en: 'Engine is not ready yet'
	String get empty => 'Engine is not ready yet';
}

// Path: folders
class Translations$folders$en {
	Translations$folders$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Folders'
	String get title => 'Folders';

	/// en: 'Add folder'
	String get add => 'Add folder';

	/// en: 'No folders yet'
	String get empty => 'No folders yet';

	/// en: 'Add a folder to start syncing it across your devices.'
	String get emptyHint => 'Add a folder to start syncing it across your devices.';

	/// en: 'Label'
	String get label => 'Label';

	/// en: 'Folder ID'
	String get folderId => 'Folder ID';

	/// en: 'Folder path'
	String get path => 'Folder path';

	/// en: 'Choose path'
	String get choosePath => 'Choose path';

	/// en: 'Folder type'
	String get type => 'Folder type';

	/// en: 'Send & Receive'
	String get typeSendReceive => 'Send & Receive';

	/// en: 'Send only'
	String get typeSendOnly => 'Send only';

	/// en: 'Receive only'
	String get typeReceiveOnly => 'Receive only';

	/// en: 'Shared with'
	String get sharedWith => 'Shared with';

	/// en: 'Rescan'
	String get rescan => 'Rescan';

	/// en: 'Rescan'
	String get rescanIntervalLabel => 'Rescan';

	/// en: 'Scan now'
	String get scanNow => 'Scan now';

	/// en: 'Global'
	String get globalState => 'Global';

	/// en: 'Local'
	String get localState => 'Local';

	/// en: '{n} items to sync'
	String needItems({required Object n}) => '${n} items to sync';

	/// en: 'State'
	String get state => 'State';

	/// en: 'Remove folder'
	String get remove => 'Remove folder';

	/// en: 'Remove this folder from Syncthing? Files on disk are kept.'
	String get removeConfirm => 'Remove this folder from Syncthing? Files on disk are kept.';

	/// en: 'Open folder'
	String get open => 'Open folder';

	/// en: 'Could not open folder'
	String get openFailed => 'Could not open folder';

	/// en: 'Folder added'
	String get added => 'Folder added';

	/// en: 'Pair a device first to share folders.'
	String get noDevices => 'Pair a device first to share folders.';
}

// Path: devices
class Translations$devices$en {
	Translations$devices$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Devices'
	String get title => 'Devices';

	/// en: 'Add device'
	String get add => 'Add device';

	/// en: 'No remote devices'
	String get empty => 'No remote devices';

	/// en: 'Add a device by its ID or scan its QR code.'
	String get emptyHint => 'Add a device by its ID or scan its QR code.';

	/// en: 'This device'
	String get thisDevice => 'This device';

	/// en: 'Device name'
	String get name => 'Device name';

	/// en: 'Device ID'
	String get id => 'Device ID';

	/// en: 'Paste a device ID or scan a QR code'
	String get idHint => 'Paste a device ID or scan a QR code';

	/// en: 'Scan QR'
	String get scan => 'Scan QR';

	/// en: 'Scan QR from image'
	String get scanFromImage => 'Scan QR from image';

	/// en: 'No QR code found in the image'
	String get qrNotFound => 'No QR code found in the image';

	/// en: 'Show my QR'
	String get showQr => 'Show my QR';

	/// en: 'Introducer'
	String get introducer => 'Introducer';

	/// en: 'Auto accept folders'
	String get autoAccept => 'Auto accept folders';

	/// en: 'Remove device'
	String get remove => 'Remove device';

	/// en: 'Remove this device?'
	String get removeConfirm => 'Remove this device?';

	/// en: 'Device added'
	String get added => 'Device added';

	/// en: 'Last seen {when}'
	String lastSeen({required Object when}) => 'Last seen ${when}';

	/// en: 'In'
	String get download => 'In';

	/// en: 'Out'
	String get upload => 'Out';

	/// en: 'Address'
	String get address => 'Address';

	/// en: 'Wants to connect'
	String get pendingTitle => 'Wants to connect';

	/// en: 'New folder offered'
	String get pendingFolderTitle => 'New folder offered';

	/// en: 'Accept'
	String get accept => 'Accept';

	/// en: 'Dismiss'
	String get dismiss => 'Dismiss';
}

// Path: activity
class Translations$activity$en {
	Translations$activity$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Activity'
	String get title => 'Activity';

	/// en: 'No activity yet'
	String get empty => 'No activity yet';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Events'
	String get events => 'Events';

	/// en: 'Engine log'
	String get log => 'Engine log';

	/// en: 'Copy log'
	String get copyLog => 'Copy log';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'System'
	String get themeSystem => 'System';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'Color scheme'
	String get palette => 'Color scheme';

	/// en: 'Language'
	String get languageTitle => 'Language';

	/// en: 'Choose the interface language'
	String get languageSubtitle => 'Choose the interface language';

	/// en: 'English'
	String get languageEnglish => 'English';

	/// en: 'Russian'
	String get languageRussian => 'Russian';

	/// en: 'Syncthing engine'
	String get engine => 'Syncthing engine';

	/// en: 'Network'
	String get network => 'Network';

	/// en: 'NAT traversal'
	String get natTitle => 'NAT traversal';

	/// en: 'Allow Syncthing to map external ports'
	String get natSubtitle => 'Allow Syncthing to map external ports';

	/// en: 'Global discovery'
	String get globalDiscoveryTitle => 'Global discovery';

	/// en: 'Find devices via the global discovery servers'
	String get globalDiscoverySubtitle => 'Find devices via the global discovery servers';

	/// en: 'Local discovery'
	String get localDiscoveryTitle => 'Local discovery';

	/// en: 'Find devices on the local network'
	String get localDiscoverySubtitle => 'Find devices on the local network';

	/// en: 'Relays'
	String get relaysTitle => 'Relays';

	/// en: 'Connect through relay servers when direct fails'
	String get relaysSubtitle => 'Connect through relay servers when direct fails';

	/// en: 'Rate limits'
	String get limitsTitle => 'Rate limits';

	/// en: 'Download limit (KiB/s)'
	String get downLimit => 'Download limit (KiB/s)';

	/// en: 'Upload limit (KiB/s)'
	String get upLimit => 'Upload limit (KiB/s)';

	/// en: 'Security'
	String get security => 'Security';

	/// en: 'GUI authentication'
	String get guiAuthTitle => 'GUI authentication';

	/// en: 'Set a username and password to protect the Syncthing GUI on this machine.'
	String get guiAuthSubtitle => 'Set a username and password to protect the Syncthing GUI on this machine.';

	/// en: 'Username'
	String get guiUser => 'Username';

	/// en: 'Password'
	String get guiPassword => 'Password';

	/// en: 'Leave blank to keep the current password'
	String get guiPasswordHint => 'Leave blank to keep the current password';

	/// en: 'Authentication is configured'
	String get guiAuthConfigured => 'Authentication is configured';

	/// en: 'No authentication set'
	String get guiAuthNotConfigured => 'No authentication set';

	/// en: 'GUI authentication updated'
	String get guiAuthSaved => 'GUI authentication updated';

	/// en: 'Disable'
	String get guiClear => 'Disable';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Engine and app information'
	String get aboutSubtitle => 'Engine and app information';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'version' => '1.0.0',
			'app.name' => 'Syncthing',
			'nav.status' => 'Status',
			'nav.folders' => 'Folders',
			'nav.devices' => 'Devices',
			'nav.activity' => 'Activity',
			'nav.settings' => 'Settings',
			'navShort.status' => 'Status',
			'navShort.folders' => 'Folders',
			'navShort.devices' => 'Devices',
			'navShort.activity' => 'Activity',
			'navShort.settings' => 'Settings',
			'common.add' => 'Add',
			'common.cancel' => 'Cancel',
			'common.save' => 'Save',
			'common.remove' => 'Remove',
			'common.close' => 'Close',
			'common.retry' => 'Retry',
			'common.edit' => 'Edit',
			'common.pause' => 'Pause',
			'common.resume' => 'Resume',
			'common.online' => 'Online',
			'common.offline' => 'Offline',
			'common.unknown' => 'Unknown',
			'common.copied' => 'Copied to clipboard',
			'common.perSecond' => ({required Object value}) => '${value}/s',
			'engine.starting' => 'Starting engine',
			'engine.running' => 'Engine running',
			'engine.stopped' => 'Engine stopped',
			'engine.error' => 'Engine error',
			'engine.remote' => 'Remote engine',
			'engine.restart' => 'Restart',
			'engine.shutdown' => 'Shut down',
			'engine.restarting' => 'Restarting engine',
			'engine.connectFailed' => 'Could not reach Syncthing',
			'engine.bundledTitle' => 'Bundled engine',
			'engine.bundledSubtitle' => 'Run and manage Syncthing inside this app',
			'engine.remoteTitle' => 'Remote engine',
			'engine.remoteSubtitle' => 'Connect to an existing Syncthing instance',
			'engine.remoteUrl' => 'Server URL',
			'engine.remoteApiKey' => 'API key',
			'engine.apply' => 'Apply',
			'status.overview' => 'Overview',
			'status.state' => 'State',
			'status.uptime' => 'Uptime',
			'status.download' => 'Download',
			'status.upload' => 'Upload',
			'status.totalFiles' => 'Files',
			'status.totalFolders' => 'Folders',
			'status.totalDevices' => 'Devices',
			'status.thisDevice' => 'This device',
			'status.deviceId' => 'Device ID',
			'status.version' => 'Version',
			'status.listeners' => 'Listeners',
			'status.discovery' => 'Discovery',
			'status.idle' => 'Up to date',
			'status.syncing' => 'Syncing',
			'status.scanning' => 'Scanning',
			'status.paused' => 'Paused',
			'status.disconnected' => 'Disconnected',
			'status.connected' => ({required Object n}) => '${n} connected',
			'status.empty' => 'Engine is not ready yet',
			'folders.title' => 'Folders',
			'folders.add' => 'Add folder',
			'folders.empty' => 'No folders yet',
			'folders.emptyHint' => 'Add a folder to start syncing it across your devices.',
			'folders.label' => 'Label',
			'folders.folderId' => 'Folder ID',
			'folders.path' => 'Folder path',
			'folders.choosePath' => 'Choose path',
			'folders.type' => 'Folder type',
			'folders.typeSendReceive' => 'Send & Receive',
			'folders.typeSendOnly' => 'Send only',
			'folders.typeReceiveOnly' => 'Receive only',
			'folders.sharedWith' => 'Shared with',
			'folders.rescan' => 'Rescan',
			'folders.rescanIntervalLabel' => 'Rescan',
			'folders.scanNow' => 'Scan now',
			'folders.globalState' => 'Global',
			'folders.localState' => 'Local',
			'folders.needItems' => ({required Object n}) => '${n} items to sync',
			'folders.state' => 'State',
			'folders.remove' => 'Remove folder',
			'folders.removeConfirm' => 'Remove this folder from Syncthing? Files on disk are kept.',
			'folders.open' => 'Open folder',
			'folders.openFailed' => 'Could not open folder',
			'folders.added' => 'Folder added',
			'folders.noDevices' => 'Pair a device first to share folders.',
			'devices.title' => 'Devices',
			'devices.add' => 'Add device',
			'devices.empty' => 'No remote devices',
			'devices.emptyHint' => 'Add a device by its ID or scan its QR code.',
			'devices.thisDevice' => 'This device',
			'devices.name' => 'Device name',
			'devices.id' => 'Device ID',
			'devices.idHint' => 'Paste a device ID or scan a QR code',
			'devices.scan' => 'Scan QR',
			'devices.scanFromImage' => 'Scan QR from image',
			'devices.qrNotFound' => 'No QR code found in the image',
			'devices.showQr' => 'Show my QR',
			'devices.introducer' => 'Introducer',
			'devices.autoAccept' => 'Auto accept folders',
			'devices.remove' => 'Remove device',
			'devices.removeConfirm' => 'Remove this device?',
			'devices.added' => 'Device added',
			'devices.lastSeen' => ({required Object when}) => 'Last seen ${when}',
			'devices.download' => 'In',
			'devices.upload' => 'Out',
			'devices.address' => 'Address',
			'devices.pendingTitle' => 'Wants to connect',
			'devices.pendingFolderTitle' => 'New folder offered',
			'devices.accept' => 'Accept',
			'devices.dismiss' => 'Dismiss',
			'activity.title' => 'Activity',
			'activity.empty' => 'No activity yet',
			'activity.clear' => 'Clear',
			'activity.events' => 'Events',
			'activity.log' => 'Engine log',
			'activity.copyLog' => 'Copy log',
			'settings.title' => 'Settings',
			'settings.appearance' => 'Appearance',
			'settings.themeSystem' => 'System',
			'settings.themeLight' => 'Light',
			'settings.themeDark' => 'Dark',
			'settings.palette' => 'Color scheme',
			'settings.languageTitle' => 'Language',
			'settings.languageSubtitle' => 'Choose the interface language',
			'settings.languageEnglish' => 'English',
			'settings.languageRussian' => 'Russian',
			'settings.engine' => 'Syncthing engine',
			'settings.network' => 'Network',
			'settings.natTitle' => 'NAT traversal',
			'settings.natSubtitle' => 'Allow Syncthing to map external ports',
			'settings.globalDiscoveryTitle' => 'Global discovery',
			'settings.globalDiscoverySubtitle' => 'Find devices via the global discovery servers',
			'settings.localDiscoveryTitle' => 'Local discovery',
			'settings.localDiscoverySubtitle' => 'Find devices on the local network',
			'settings.relaysTitle' => 'Relays',
			'settings.relaysSubtitle' => 'Connect through relay servers when direct fails',
			'settings.limitsTitle' => 'Rate limits',
			'settings.downLimit' => 'Download limit (KiB/s)',
			'settings.upLimit' => 'Upload limit (KiB/s)',
			'settings.security' => 'Security',
			'settings.guiAuthTitle' => 'GUI authentication',
			'settings.guiAuthSubtitle' => 'Set a username and password to protect the Syncthing GUI on this machine.',
			'settings.guiUser' => 'Username',
			'settings.guiPassword' => 'Password',
			'settings.guiPasswordHint' => 'Leave blank to keep the current password',
			'settings.guiAuthConfigured' => 'Authentication is configured',
			'settings.guiAuthNotConfigured' => 'No authentication set',
			'settings.guiAuthSaved' => 'GUI authentication updated',
			'settings.guiClear' => 'Disable',
			'settings.about' => 'About',
			'settings.aboutSubtitle' => 'Engine and app information',
			_ => null,
		};
	}
}
