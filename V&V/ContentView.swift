//
//  ContentView.swift
//  Firs İos
//
//  Created by Atilla Köz on 26.12.2024.
//

import SwiftUI
import AVFoundation
import AudioToolbox

// Oyuncu modeli
struct Player: Identifiable, Codable {
    let id = UUID()
    var name: String
    var role: GameRole?
    var isDead: Bool = false
}

// Oyun rolleri
enum GameRole: String, CaseIterable, Identifiable, Codable {
    case vampir = "🧛"
    case köylü = "👨‍🌾"
    case masumKöylü = "😇"
    case kahin = "🔮"
    case doktor = "👨‍⚕️"
    case avcı = "🏹"
    case büyücü = "🧙‍♂️"
    case custom = "❓"
    
    var id: String { self.rawValue }
    
    func localizedName(language: Language, customRoleName: String?) -> String {
        if self == .custom {
            return "❓ \(customRoleName ?? self.rawValue)"
        }
        let key = "role_\(self)_name"
        return "\(self.rawValue) \(Translations.text(for: key, language: language))"
    }
    
    func localizedDescription(language: Language, customRoleDescription: String?) -> String {
        if self == .custom {
            return customRoleDescription ?? ""
        }
        let key = "role_\(self)_description"
        return Translations.text(for: key, language: language)
    }
    
    var backgroundColor: Color {
        switch self {
        case .vampir: return .red
        case .köylü: return .brown
        case .masumKöylü: return Color(red: 0.9, green: 0.7, blue: 0.3)
        case .kahin: return Color(red: 0.4, green: 0.2, blue: 0.6)
        case .doktor: return .blue
        case .avcı: return .green
        case .büyücü: return .purple
        case .custom: return Color(red: 0.6, green: 0.4, blue: 0.8)
        }
    }
}

// Dil seçenekleri
enum Language: String, CaseIterable, Codable {
    case turkish = "Türkçe"
    case english = "English"
    case german = "Deutsch"
    case french = "Français"
    case spanish = "Español"
    
    var flagEmoji: String {
        switch self {
        case .turkish: return "🇹🇷"
        case .english: return "🇬🇧"
        case .german: return "🇩🇪"
        case .french: return "🇫🇷"
        case .spanish: return "🇪🇸"
        }
    }
}

// Çeviriler
struct Translations {
    static func text(for key: String, language: Language) -> String {
        switch language {
        case .turkish:
            return turkishTexts[key] ?? key
        case .english:
            return englishTexts[key] ?? key
        case .german:
            return germanTexts[key] ?? key
        case .french:
            return frenchTexts[key] ?? key
        case .spanish:
            return spanishTexts[key] ?? key
        }
    }
    
    static let turkishTexts: [String: String] = [
        "title": "Vampir Köylü",
        "settings": "Ayarlar",
        "language": "Dil Seçimi",
        "done": "Tamam",
        "player_name": "Oyuncu Adı",
        "distribute_roles": "Rolleri Dağıt",
        "redistribute_roles": "Yeniden Dağıt",
        "reset": "Sıfırla",
        "delete_all": "Tümünü Sil",
        "delete_all_warning": "Tüm oyuncular silinecek. Bu işlem geri alınamaz. Emin misiniz?",
        "cancel": "İptal",
        "delete": "Sil",
        "roles": "Roller",
        "role_distribution": "Rol Dağılımı",
        "redistribute_warning": "Mevcut roller silinecek ve yeniden dağıtılacak. Emin misiniz?",
        "delete_player_warning": "isimli oyuncuyu silmek istediğinize emin misiniz?",
        "delete_player": "Oyuncuyu Sil",
        "close": "Kapat",
        "add_custom_role": "Özel Rol Ekle",
        "custom_role_name": "Rol Adı",
        "custom_role_description": "Rol Açıklaması",
        "add": "Ekle",
        "role_vampir_name": "Vampir",
        "role_köylü_name": "Köylü",
        "role_masumKöylü_name": "Masum Köylü",
        "role_kahin_name": "Kahin",
        "role_doktor_name": "Doktor",
        "role_avcı_name": "Avcı",
        "role_büyücü_name": "Büyücü",
        "role_vampir_description": "Geceleri köylüleri öldürür",
        "role_köylü_description": "Vampirleri bulmaya çalışır",
        "role_masumKöylü_description": "Gece olduğunda diğer vampirlere belli etmeden gözlerini açabilir",
        "role_kahin_description": "Her gece bir kişinin rolünü öğrenebilir",
        "role_doktor_description": "Her gece bir kişiyi iyileştirir",
        "role_avcı_description": "Bir kişiyi öldürme hakkı var",
        "role_büyücü_description": "Bir kez diriltme, bir kez öldürme hakkı var",
        "timer_settings": "Sayaç Ayarları",
        "timer_enabled": "Sayaç Aktif",
        "timer_duration": "Süre (saniye)",
        "minutes": "dakika",
        "seconds": "saniye",
        "sound_enabled": "Ses Aktif",
        "how_to_play": "Nasıl Oynanır",
        "game_description": "Vampir Köylü, bir sosyal çıkarım oyunudur. Bu uygulama, oyun yöneticisinin rol dağıtımını ve süre takibini kolayca yapabilmesini sağlar.\n\nOyun Kuralları:\n\n1. Oyuncular iki gruba ayrılır: Vampirler ve Köylüler\n\n2. Oyun gece ve gündüz olmak üzere iki fazda oynanır:\n- Gece: Vampirler bir köylüyü öldürmeye çalışır\n- Gündüz: Tüm oyuncular tartışır ve şüpheli bir kişiyi oylamaya sunar\n\n3. Özel Roller:\n- Kahin: Her gece bir kişinin rolünü öğrenebilir\n- Doktor: Her gece bir kişiyi vampir saldırısından koruyabilir\n- Avcı: Oyun boyunca bir kez birini öldürebilir\n- Büyücü: Bir kez diriltme ve bir kez öldürme hakkı vardır\n- Masum Köylü: Gece fazında gözlerini açabilir\n\n4. Kazanma Koşulları:\n- Vampirler: Tüm köylüleri öldürdüklerinde\n- Köylüler: Tüm vampirleri bulup öldürdüklerinde",
        "app_description": "Bu uygulama, Vampir Köylü oyununun yönetimini kolaylaştırmak için tasarlanmıştır. Oyuncu ekleme, rol dağıtma ve süre takibi gibi özellikleri içerir."
    ]
    
    static let englishTexts: [String: String] = [
        "title": "Vampire Village",
        "settings": "Settings",
        "language": "Language",
        "done": "Done",
        "player_name": "Player Name",
        "distribute_roles": "Distribute Roles",
        "redistribute_roles": "Redistribute",
        "reset": "Reset",
        "delete_all": "Delete All",
        "delete_all_warning": "All players will be deleted. This action cannot be undone. Are you sure?",
        "cancel": "Cancel",
        "delete": "Delete",
        "roles": "Roles",
        "role_distribution": "Role Distribution",
        "redistribute_warning": "Current roles will be deleted and redistributed. Are you sure?",
        "delete_player_warning": "Are you sure you want to delete player",
        "delete_player": "Delete Player",
        "close": "Close",
        "add_custom_role": "Add Custom Role",
        "custom_role_name": "Role Name",
        "custom_role_description": "Role Description",
        "add": "Add",
        "role_vampir_name": "Vampire",
        "role_köylü_name": "Villager",
        "role_masumKöylü_name": "Innocent Villager",
        "role_kahin_name": "Seer",
        "role_doktor_name": "Doctor",
        "role_avcı_name": "Hunter",
        "role_büyücü_name": "Wizard",
        "role_vampir_description": "Kills villagers at night",
        "role_köylü_description": "Tries to find vampires",
        "role_masumKöylü_description": "Can open eyes at night without being noticed by vampires",
        "role_kahin_description": "Can learn one person's role each night",
        "role_doktor_description": "Heals one person each night",
        "role_avcı_description": "Has the right to kill one person",
        "role_büyücü_description": "Has one resurrection and one kill right",
        "timer_settings": "Timer Settings",
        "timer_enabled": "Timer Enabled",
        "timer_duration": "Duration (seconds)",
        "minutes": "minutes",
        "seconds": "seconds",
        "sound_enabled": "Sound Enabled",
        "how_to_play": "How to Play",
        "game_description": "Vampire Village is a social deduction game. This app helps the game master easily distribute roles and track time.\n\nGame Rules:\n\n1. Players are divided into two groups: Vampires and Villagers\n\n2. The game is played in two phases, night and day:\n- Night: Vampires try to kill a villager\n- Day: All players discuss and vote on a suspicious person\n\n3. Special Roles:\n- Seer: Can learn one person's role each night\n- Doctor: Can protect someone from vampire attacks each night\n- Hunter: Can kill one person during the game\n- Wizard: Has one resurrection and one kill right\n- Innocent Villager: Can open eyes during night phase\n\n4. Win Conditions:\n- Vampires: When all villagers are dead\n- Villagers: When all vampires are found and killed",
        "app_description": "This app is designed to facilitate the management of the Vampire Village game. It includes features such as adding players, distributing roles, and time tracking."
    ]
    
    static let germanTexts: [String: String] = [
        "title": "Vampirdorf",
        "settings": "Einstellungen",
        "language": "Sprache",
        "done": "Fertig",
        "player_name": "Spielername",
        "distribute_roles": "Rollen verteilen",
        "redistribute_roles": "Neu verteilen",
        "reset": "Zurücksetzen",
        "delete_all": "Alle löschen",
        "delete_all_warning": "Alle Spieler werden gelöscht. Diese Aktion kann nicht rückgängig gemacht werden. Sind Sie sicher?",
        "cancel": "Abbrechen",
        "delete": "Löschen",
        "roles": "Rollen",
        "role_distribution": "Rollenverteilung",
        "redistribute_warning": "Aktuelle Rollen werden gelöscht und neu verteilt. Sind Sie sicher?",
        "delete_player_warning": "Sind Sie sicher, dass Sie den Spieler löschen möchten",
        "delete_player": "Spieler löschen",
        "close": "Schließen",
        "add_custom_role": "Benutzerdefinierte Rolle hinzufügen",
        "custom_role_name": "Rollenname",
        "custom_role_description": "Rollenbeschreibung",
        "add": "Hinzufügen",
        "role_vampir_name": "Vampir",
        "role_köylü_name": "Dorfbewohner",
        "role_masumKöylü_name": "Unschuldiger Dorfbewohner",
        "role_kahin_name": "Seher",
        "role_doktor_name": "Arzt",
        "role_avcı_name": "Jäger",
        "role_büyücü_name": "Zauberer",
        "role_vampir_description": "Tötet nachts Dorfbewohner",
        "role_köylü_description": "Versucht Vampire zu finden",
        "role_masumKöylü_description": "Kann nachts die Augen öffnen, ohne von Vampiren bemerkt zu werden",
        "role_kahin_description": "Kann jede Nacht die Rolle einer Person erfahren",
        "role_doktor_description": "Heilt jede Nacht eine Person",
        "role_avcı_description": "Hat das Recht, eine Person zu töten",
        "role_büyücü_description": "Hat ein Wiederbelebungsrecht und ein Tötungsrecht",
        "timer_settings": "Timer-Einstellungen",
        "timer_enabled": "Timer Aktiviert",
        "timer_duration": "Dauer (Sekunden)",
        "minutes": "Minuten",
        "seconds": "Sekunden",
        "sound_enabled": "Ton Aktiviert",
        "how_to_play": "Wie man spielt",
        "game_description": "Vampire Village ist ein sozialer Entdeckungsspiel. Diese App hilft dem Spielleiter, Rollen einfach zu verteilen und die Zeit zu verfolgen.\n\nSpielregeln:\n\n1. Spieler werden in zwei Gruppen aufgeteilt: Vampiren und Dorfbewohner\n\n2. Das Spiel wird in zwei Phasen gespielt, Nacht und Tag:\n- Nacht: Vampiren versuchen, einen Dorfbewohner zu töten\n- Tag: Alle Spieler diskutieren und stimmen über eine verdächtige Person ab\n\n3. Besondere Rollen:\n- Seher: Kann die Rolle einer Person jeden Abend erfahren\n- Arzt: Kann jemanden vor Nachtsangriffen schützen\n- Jäger: Kann während des Spiels eine Person töten\n- Zauberer: Hat ein Wiederauferstehungsrecht und ein Tötungsrecht\n- Unschuldiger Dorfbewohner: Kann die Augen während der Nachtphase öffnen\n\n4. Siegbedingungen:\n- Vampiren: Wenn alle Dorfbewohner tot sind\n- Dorfbewohner: Wenn alle Vampiren gefunden und getötet sind",
        "app_description": "Diese App wurde entwickelt, um die Verwaltung des Vampire Village Spiels zu erleichtern. Sie enthält Funktionen wie Spieler hinzufügen, Rollen verteilen und Zeit verfolgen."
    ]
    
    static let frenchTexts: [String: String] = [
        "title": "Village Vampire",
        "settings": "Paramètres",
        "language": "Langue",
        "done": "Terminé",
        "player_name": "Nom du joueur",
        "distribute_roles": "Distribuer les rôles",
        "redistribute_roles": "Redistribuer",
        "reset": "Réinitialiser",
        "delete_all": "Tout supprimer",
        "delete_all_warning": "Tous les joueurs seront supprimés. Cette action ne peut pas être annulée. Êtes-vous sûr?",
        "cancel": "Annuler",
        "delete": "Supprimer",
        "roles": "Rôles",
        "role_distribution": "Distribution des rôles",
        "redistribute_warning": "Les rôles actuels seront supprimés et redistribués. Êtes-vous sûr?",
        "delete_player_warning": "Êtes-vous sûr de vouloir supprimer le joueur",
        "delete_player": "Supprimer le joueur",
        "close": "Fermer",
        "add_custom_role": "Ajouter un rôle personnalisé",
        "custom_role_name": "Nom du rôle",
        "custom_role_description": "Description du rôle",
        "add": "Ajouter",
        "role_vampir_name": "Vampire",
        "role_köylü_name": "Villageois",
        "role_masumKöylü_name": "Villageois Innocent",
        "role_kahin_name": "Voyant",
        "role_doktor_name": "Médecin",
        "role_avcı_name": "Chasseur",
        "role_büyücü_name": "Sorcier",
        "role_vampir_description": "Tue les villageois la nuit",
        "role_köylü_description": "Essaie de trouver les vampires",
        "role_masumKöylü_description": "Peut ouvrir les yeux la nuit sans être remarqué par les vampires",
        "role_kahin_description": "Peut découvrir le rôle d'une personne chaque nuit",
        "role_doktor_description": "Soigne une personne chaque nuit",
        "role_avcı_description": "A le droit de tuer une personne",
        "role_büyücü_description": "A un droit de résurrection et un droit de mort",
        "timer_settings": "Paramètres du minuteur",
        "timer_enabled": "Minuteur activé",
        "timer_duration": "Durée (secondes)",
        "minutes": "minutes",
        "seconds": "secondes",
        "sound_enabled": "Son Activé",
        "how_to_play": "Comment jouer",
        "game_description": "Vampire Village est un jeu de déduction sociale. Cette application facilite la distribution des rôles et le suivi du temps.\n\nRègles du jeu :\n\n1. Les joueurs sont divisés en deux groupes : les vampires et les villageois\n\n2. Le jeu se déroule en deux phases, la nuit et le jour :\n- Nuit : Les vampires tentent de tuer un villageois\n- Jour : Tous les joueurs discutent et votent pour une personne suspecte\n\n3. Rôles spéciaux :\n- Voyant : Peut apprendre le rôle d'une personne chaque nuit\n- Médecin : Peut protéger quelqu'un des attaques de vampire chaque nuit\n- Chasseur : Peut tuer une personne pendant le jeu\n- Sorcier : A le droit de résurrection et de mort\n- Villageois Innocent : Peut ouvrir les yeux pendant la phase de nuit\n\n4. Conditions de victoire :\n- Vampires : Lorsque tous les villageois sont morts\n- Villageois : Lorsque tous les vampires sont trouvés et tués",
        "app_description": "Cette application est conçue pour faciliter la gestion du jeu Vampire Village. Elle inclut des fonctionnalités telles que l'ajout de joueurs, la distribution des rôles et le suivi du temps."
    ]
    
    static let spanishTexts: [String: String] = [
        "title": "Pueblo Vampiro",
        "settings": "Ajustes",
        "language": "Idioma",
        "done": "Listo",
        "player_name": "Nombre del jugador",
        "distribute_roles": "Distribuir roles",
        "redistribute_roles": "Redistribuir",
        "reset": "Reiniciar",
        "delete_all": "Eliminar todo",
        "delete_all_warning": "Se eliminarán todos los jugadores. Esta acción no se puede deshacer. ¿Estás seguro?",
        "cancel": "Cancelar",
        "delete": "Eliminar",
        "roles": "Roles",
        "role_distribution": "Distribución de roles",
        "redistribute_warning": "Los roles actuales se eliminarán y redistribuirán. ¿Estás seguro?",
        "delete_player_warning": "¿Estás seguro de que quieres eliminar al jugador",
        "delete_player": "Eliminar jugador",
        "close": "Cerrar",
        "add_custom_role": "Agregar rol personalizado",
        "custom_role_name": "Nombre del rol",
        "custom_role_description": "Descripción del rol",
        "add": "Agregar",
        "role_vampir_name": "Vampiro",
        "role_köylü_name": "Aldeano",
        "role_masumKöylü_name": "Aldeano Inocente",
        "role_kahin_name": "Vidente",
        "role_doktor_name": "Doctor",
        "role_avcı_name": "Cazador",
        "role_büyücü_name": "Mago",
        "role_vampir_description": "Mata a los aldeanos por la noche",
        "role_köylü_description": "Intenta encontrar vampiros",
        "role_masumKöylü_description": "Puede abrir los ojos por la noche sin ser notado por los vampiros",
        "role_kahin_description": "Puede conocer el rol de una persona cada noche",
        "role_doktor_description": "Cura a una persona cada noche",
        "role_avcı_description": "Tiene el derecho de matar a una persona",
        "role_büyücü_description": "Tiene un derecho de resurrección y un derecho de muerte",
        "timer_settings": "Ajustes del temporizador",
        "timer_enabled": "Temporizador activado",
        "timer_duration": "Duración (segundos)",
        "minutes": "minutos",
        "seconds": "segundos",
        "sound_enabled": "Sonido Activado",
        "how_to_play": "Cómo jugar",
        "game_description": "Vampire Village es un juego de deducción social. Esta aplicación facilita la distribución de roles y el seguimiento del tiempo.\n\nReglas del juego :\n\n1. Los jugadores se dividen en dos grupos : los vampiros y los aldeanos\n\n2. El juego se juega en dos fases, la noche y el día :\n- Noche : Los vampiros intentan matar a un aldeano\n- Día : Todos los jugadores discuten y votan por una persona sospechosa\n\n3. Roles especiales :\n- Vidente : Puede aprender el rol de una persona cada noche\n- Doctor : Puede proteger a alguien de los ataques de vampiro cada noche\n- Cazador : Puede matar a una persona durante el juego\n- Mago : Tiene el derecho de resurrección y de muerte\n- Aldeano Inocente : Puede abrir los ojos durante la fase de noche\n\n4. Condiciones de victoria :\n- Vampiros : Cuando todos los aldeanos están muertos\n- Aldeanos : Cuando todos los vampiros están encontrados y muertos",
        "app_description": "Esta aplicación está diseñada para facilitar la gestión del juego Vampire Village. Incluye funciones como agregar jugadores, distribuir roles y rastrear el tiempo."
    ]
}

// ViewModel
class GameViewModel: ObservableObject {
    @Published var players: [Player] = [] {
        didSet {
            saveData()
        }
    }
    @Published var selectedLanguage: Language = .turkish {
        didSet {
            saveData()
        }
    }
    @Published var customRoleName: String? {
        didSet {
            saveData()
        }
    }
    @Published var customRoleDescription: String? {
        didSet {
            saveData()
        }
    }
    @Published var isTimerEnabled: Bool = true {
        didSet {
            saveData()
        }
    }
    @Published var timerDuration: Int = 180 {
        didSet {
            saveData()
        }
    }
    @Published var remainingTime: Int = 180
    @Published var isTimerRunning: Bool = false
    @Published var roleDistribution: [GameRole: Int] = [
        .vampir: 2,
        .köylü: 3,
        .masumKöylü: 1,
        .kahin: 1,
        .doktor: 1,
        .avcı: 1,
        .büyücü: 1
    ] {
        didSet {
            saveData()
        }
    }

    init() {
        loadData()
    }

    private func saveData() {
        // Oyuncuları Dictionary'e çevir
        let playerDicts = players.map { player -> [String: Any] in
            [
                "name": player.name,
                "role": player.role?.rawValue ?? "",
                "isDead": player.isDead
            ]
        }

        // Role dağılımını Dictionary'e çevir
        let distributionDict = roleDistribution.mapKeys { $0.rawValue }

        // Tüm verileri kaydet
        let data: [String: Any] = [
            "players": playerDicts,
            "selectedLanguage": selectedLanguage.rawValue,
            "customRoleName": customRoleName ?? "",
            "customRoleDescription": customRoleDescription ?? "",
            "isTimerEnabled": isTimerEnabled,
            "timerDuration": timerDuration,
            "roleDistribution": distributionDict
        ]

        UserDefaults.standard.set(data, forKey: "GameData")
    }

    private func loadData() {
        guard let data = UserDefaults.standard.dictionary(forKey: "GameData") else { return }

        // Dil seçimini yükle
        if let languageStr = data["selectedLanguage"] as? String,
           let language = Language(rawValue: languageStr) {
            selectedLanguage = language
        }

        // Özel rol bilgilerini yükle
        customRoleName = data["customRoleName"] as? String
        customRoleDescription = data["customRoleDescription"] as? String

        // Sayaç ayarlarını yükle
        isTimerEnabled = data["isTimerEnabled"] as? Bool ?? true
        timerDuration = data["timerDuration"] as? Int ?? 180
        remainingTime = timerDuration

        // Rol dağılımını yükle
        if let distributionDict = data["roleDistribution"] as? [String: Int] {
            var newDistribution: [GameRole: Int] = [:]
            for (roleStr, count) in distributionDict {
                if let role = GameRole(rawValue: roleStr) {
                    newDistribution[role] = count
                }
            }
            roleDistribution = newDistribution
        }

        // Oyuncuları yükle
        if let playerDicts = data["players"] as? [[String: Any]] {
            players = playerDicts.compactMap { dict -> Player? in
                guard let name = dict["name"] as? String else { return nil }
                let roleStr = dict["role"] as? String
                let role = roleStr.flatMap { GameRole(rawValue: $0) }
                let isDead = dict["isDead"] as? Bool ?? false
                var player = Player(name: name)
                player.role = role
                player.isDead = isDead
                return player
            }
        }
    }

    private func playVibration() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
    }
    
    func startTimer() {
        remainingTime = timerDuration
        isTimerRunning = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.remainingTime > 0 && self.isTimerRunning {
                self.remainingTime -= 1
                
                // Son 30 saniye kaldığında titreşim
                if self.remainingTime == 30 {
                    self.playVibration()
                }
                
                // Süre bittiğinde titreşim
                if self.remainingTime == 0 {
                    self.playVibration()
                    timer.invalidate()
                    self.isTimerRunning = false
                }
            } else {
                timer.invalidate()
                self.isTimerRunning = false
            }
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
    }
    
    func resetTimer() {
        remainingTime = timerDuration
        isTimerRunning = false
    }
    
    var hasDistributedRoles: Bool {
        players.contains { $0.role != nil }
    }
    
    func addPlayer(name: String) {
        let player = Player(name: name)
        players.append(player)
    }
    
    func removePlayer(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
    }
    
    func distributeRoles() {
        var availableRoles: [GameRole] = []
        
        // Rol dağılımına göre rolleri oluştur
        for (role, count) in roleDistribution {
            for _ in 0..<count {
                availableRoles.append(role)
            }
        }
        
        // Rolleri karıştır
        availableRoles.shuffle()
        
        // Her oyuncuya rol ata
        for i in 0..<min(players.count, availableRoles.count) {
            players[i].role = availableRoles[i]
        }
    }
    
    func resetRoles() {
        for i in 0..<players.count {
            players[i].role = nil
        }
    }
}

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }
}

// Ekran boyutları için yardımcı extension
extension UIScreen {
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    static var isSmallDevice: Bool {
        UIScreen.screenHeight < 700 // iPhone SE gibi küçük cihazlar için
    }
}

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var newPlayerName = ""
    @State private var showingRoleSheet = false
    @State private var showingDistributionSheet = false
    @State private var showingRedistributeAlert = false
    @State private var showingDeleteAlert = false
    @State private var playerToDelete: Player? = nil
    @State private var showingDeleteAllAlert = false
    @State private var showingSettingsSheet = false
    @State private var showingHowToPlaySheet = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Ortaçağ temalı arka plan gradyanı
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.2, blue: 0.1),
                            Color(red: 0.2, green: 0.1, blue: 0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    // Süslü arka plan deseni
                    Image(systemName: "seal.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white.opacity(0.03))
                        .frame(width: geometry.size.width * 0.4)
                        .rotationEffect(.degrees(45))
                        .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.2)
                    
                    VStack(spacing: geometry.size.height * 0.02) {
                        Text(Translations.text(for: "title", language: viewModel.selectedLanguage))
                            .font(.custom("Copperplate", size: 36))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                            .padding(.top, geometry.size.height * 0.05)
                            .padding(.bottom, geometry.size.height * 0.04)
                            .shadow(color: .black.opacity(0.5), radius: 2)
                        
                        // Oyuncu ekleme alanı
                        HStack {
                            TextField(Translations.text(for: "player_name", language: viewModel.selectedLanguage), text: $newPlayerName)
                                .textFieldStyle(MedievalTextFieldStyle())
                                .font(.custom("Georgia", size: UIScreen.isSmallDevice ? 14 : 16))
                                .frame(height: geometry.size.height * 0.06)
                            
                            Button(action: {
                                if !newPlayerName.isEmpty {
                                    viewModel.addPlayer(name: newPlayerName)
                                    newPlayerName = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: geometry.size.width * 0.1))
                                    .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                            }
                        }
                        .padding(.horizontal, geometry.size.width * 0.04)
                        
                        // Oyuncu listesi
                        ScrollView {
                            LazyVStack(spacing: geometry.size.height * 0.015) {
                                ForEach(viewModel.players) { player in
                                    PlayerRow(player: player)
                                        .environmentObject(viewModel)
                                        .transition(.scale.combined(with: .opacity))
                                        .onTapGesture {
                                            if let index = viewModel.players.firstIndex(where: { $0.id == player.id }) {
                                                viewModel.players[index].isDead.toggle()
                                            }
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    if let index = viewModel.players.firstIndex(where: { $0.id == player.id }) {
                                                        viewModel.players.remove(at: index)
                                                    }
                                                }
                                            } label: {
                                                Label("Sil", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, geometry.size.width * 0.04)
                        }
                        
                        // Butonlar
                        HStack(spacing: geometry.size.width * 0.04) {
                            Button(action: {
                                withAnimation {
                                    if viewModel.hasDistributedRoles {
                                        showingRedistributeAlert = true
                                    } else {
                                        viewModel.distributeRoles()
                                        showingRoleSheet = true
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "scroll.fill")
                                    Text(viewModel.hasDistributedRoles ? 
                                        Translations.text(for: "redistribute_roles", language: viewModel.selectedLanguage) : 
                                        Translations.text(for: "distribute_roles", language: viewModel.selectedLanguage))
                                        .font(.custom("Georgia", size: 16))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(red: 0.8, green: 0.7, blue: 0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 0.9, green: 0.8, blue: 0.4), lineWidth: 1)
                                        )
                                )
                                .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.1))
                                .shadow(color: Color.black.opacity(0.3), radius: 5)
                            }
                            .disabled(viewModel.players.isEmpty)

                            Button(action: {
                                withAnimation {
                                    if viewModel.hasDistributedRoles {
                                        viewModel.resetRoles()
                                    } else {
                                        showingDeleteAllAlert = true
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: viewModel.hasDistributedRoles ? "xmark.seal.fill" : "trash.fill")
                                    Text(viewModel.hasDistributedRoles ? 
                                        Translations.text(for: "reset", language: viewModel.selectedLanguage) : 
                                        Translations.text(for: "delete_all", language: viewModel.selectedLanguage))
                                        .font(.custom("Georgia", size: 16))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(red: 0.5, green: 0.2, blue: 0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 0.6, green: 0.3, blue: 0.3), lineWidth: 1)
                                        )
                                )
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.3), radius: 5)
                            }
                            .disabled(viewModel.players.isEmpty)
                        }
                        .padding(.horizontal, geometry.size.width * 0.04)
                        .padding(.bottom, geometry.size.height * 0.02)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSettingsSheet = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                    }
                }
                
                if viewModel.isTimerEnabled {
                    ToolbarItem(placement: .principal) {
                        Button(action: {
                            if viewModel.isTimerRunning {
                                viewModel.stopTimer()
                            } else {
                                viewModel.startTimer()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: viewModel.isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                                Text("\(viewModel.remainingTime/60):\(String(format: "%02d", viewModel.remainingTime%60))")
                            }
                            .font(.custom("Georgia", size: 18))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingDistributionSheet = true }) {
                        Image(systemName: "scroll")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                    }
                }
            }
            .sheet(isPresented: $showingRoleSheet) {
                RoleListView(players: viewModel.players)
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showingDistributionSheet) {
                RoleDistributionView(distribution: $viewModel.roleDistribution)
                    .environmentObject(viewModel)
            }
            .alert(Translations.text(for: "redistribute_roles", language: viewModel.selectedLanguage), isPresented: $showingRedistributeAlert) {
                Button(Translations.text(for: "cancel", language: viewModel.selectedLanguage), role: .cancel) {}
                Button(Translations.text(for: "redistribute_roles", language: viewModel.selectedLanguage), role: .destructive) {
                    withAnimation {
                        viewModel.distributeRoles()
                        showingRoleSheet = true
                    }
                }
            } message: {
                Text(Translations.text(for: "redistribute_warning", language: viewModel.selectedLanguage))
            }
            .alert(Translations.text(for: "delete_player", language: viewModel.selectedLanguage), isPresented: $showingDeleteAlert, presenting: playerToDelete) { player in
                Button(Translations.text(for: "cancel", language: viewModel.selectedLanguage), role: .cancel) {}
                Button(Translations.text(for: "delete", language: viewModel.selectedLanguage), role: .destructive) {
                    withAnimation {
                        if let index = viewModel.players.firstIndex(where: { $0.id == player.id }) {
                            viewModel.players.remove(at: index)
                        }
                    }
                }
            } message: { player in
                Text("\(player.name) \(Translations.text(for: "delete_player_warning", language: viewModel.selectedLanguage))")
            }
            .alert(Translations.text(for: "delete_all", language: viewModel.selectedLanguage), isPresented: $showingDeleteAllAlert) {
                Button(Translations.text(for: "cancel", language: viewModel.selectedLanguage), role: .cancel) {}
                Button(Translations.text(for: "delete", language: viewModel.selectedLanguage), role: .destructive) {
                    withAnimation {
                        viewModel.players.removeAll()
                    }
                }
            } message: {
                Text(Translations.text(for: "delete_all_warning", language: viewModel.selectedLanguage))
            }
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView()
                    .environmentObject(viewModel)
            }
        }
    }
}

struct MedievalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 0.95, green: 0.9, blue: 0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0.8, green: 0.7, blue: 0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.1))
    }
}

struct PlayerRow: View {
    let player: Player
    @EnvironmentObject var viewModel: GameViewModel
    
    var roleText: String {
        if let role = player.role {
            return role.localizedName(language: viewModel.selectedLanguage, customRoleName: viewModel.customRoleName)
        }
        return ""
    }
    
    var roleDescriptionText: String {
        if let role = player.role {
            return role.localizedDescription(language: viewModel.selectedLanguage, customRoleDescription: viewModel.customRoleDescription)
        }
        return ""
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading, spacing: geometry.size.height * 0.05) {
                    Text(player.name)
                        .font(.custom("Georgia", size: UIScreen.isSmallDevice ? 16 : 18))
                        .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                        .strikethrough(player.isDead)
                    
                    if let role = player.role {
                        Text(roleDescriptionText)
                            .font(.custom("Georgia", size: UIScreen.isSmallDevice ? 12 : 14))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                            .lineLimit(2)
                            .opacity(player.isDead ? 0.5 : 1)
                    }
                }
                
                Spacer()
                
                if let role = player.role {
                    Text(roleText)
                        .font(.custom("Georgia", size: UIScreen.isSmallDevice ? 14 : 16))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(player.isDead ? Color.gray : role.backgroundColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.8, green: 0.7, blue: 0.3), lineWidth: 1)
                                )
                        )
                }
            }
            .padding(.horizontal, geometry.size.width * 0.04)
            .padding(.vertical, geometry.size.height * 0.1)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(player.isDead ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.3, green: 0.2, blue: 0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 0.8, green: 0.7, blue: 0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 10)
            )
            .contentShape(Rectangle())
        }
        .frame(height: UIScreen.screenHeight * 0.12)
    }
}

struct RoleListView: View {
    let players: [Player]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.3, green: 0.2, blue: 0.1)
                    .ignoresSafeArea()
                
                Image(systemName: "seal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white.opacity(0.03))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(45))
                    .position(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.2)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(players) { player in
                            if let role = player.role {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(player.name)
                                        .font(.custom("Georgia", size: 22))
                                        .bold()
                                        .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                                    
                                    HStack {
                                        Text(role.localizedName(language: viewModel.selectedLanguage, customRoleName: viewModel.customRoleName))
                                            .font(.custom("Georgia", size: 20))
                                        
                                        Spacer()
                                        
                                        Text(role.localizedDescription(language: viewModel.selectedLanguage, customRoleDescription: viewModel.customRoleDescription))
                                            .font(.custom("Georgia", size: 16))
                                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                                            .multilineTextAlignment(.trailing)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(role.backgroundColor.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(red: 0.8, green: 0.7, blue: 0.3), lineWidth: 1)
                                        )
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(Translations.text(for: "roles", language: viewModel.selectedLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Translations.text(for: "close", language: viewModel.selectedLanguage)) {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                }
            }
        }
    }
}

struct RoleDistributionView: View {
    @Binding var distribution: [GameRole: Int]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: GameViewModel
    @State private var showingCustomRoleSheet = false
    @State private var newRoleName = ""
    @State private var newRoleDescription = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.3, green: 0.2, blue: 0.1)
                    .ignoresSafeArea()
                
                Image(systemName: "seal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white.opacity(0.03))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(45))
                    .position(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.2)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(GameRole.allCases) { role in
                            if role != .custom || (role == .custom && viewModel.customRoleName != nil) {
                                HStack {
                                    HStack {
                                        Text(role.localizedName(language: viewModel.selectedLanguage, customRoleName: viewModel.customRoleName))
                                            .font(.custom("Georgia", size: 18))
                                            .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                                        
                                        Text(role.localizedDescription(language: viewModel.selectedLanguage, customRoleDescription: viewModel.customRoleDescription))
                                            .font(.custom("Georgia", size: 14))
                                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Button(action: {
                                            if let current = distribution[role], current > 0 {
                                                distribution[role] = current - 1
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                                                .font(.title2)
                                        }
                                        
                                        Text("\(distribution[role] ?? 0)")
                                            .font(.custom("Georgia", size: 20))
                                            .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                                            .frame(width: 40)
                                        
                                        Button(action: {
                                            let current = distribution[role] ?? 0
                                            if current < 10 {
                                                distribution[role] = current + 1
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                                                .font(.title2)
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(role.backgroundColor.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 0.8, green: 0.7, blue: 0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        Button(action: {
                            showingCustomRoleSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text(Translations.text(for: "add_custom_role", language: viewModel.selectedLanguage))
                                    .font(.custom("Georgia", size: 18))
                            }
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 0.8, green: 0.7, blue: 0.3), lineWidth: 1)
                            )
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle(Translations.text(for: "role_distribution", language: viewModel.selectedLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Translations.text(for: "done", language: viewModel.selectedLanguage)) {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                }
            }
            .sheet(isPresented: $showingCustomRoleSheet) {
                NavigationView {
                    ZStack {
                        Color(red: 0.3, green: 0.2, blue: 0.1)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 20) {
                            TextField(Translations.text(for: "custom_role_name", language: viewModel.selectedLanguage), text: $newRoleName)
                                .textFieldStyle(MedievalTextFieldStyle())
                                .padding()
                            
                            TextField(Translations.text(for: "custom_role_description", language: viewModel.selectedLanguage), text: $newRoleDescription)
                                .textFieldStyle(MedievalTextFieldStyle())
                                .padding()
                        }
                        .padding()
                    }
                    .navigationTitle(Translations.text(for: "add_custom_role", language: viewModel.selectedLanguage))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(Translations.text(for: "add", language: viewModel.selectedLanguage)) {
                                if !newRoleName.isEmpty {
                                    viewModel.customRoleName = newRoleName
                                    viewModel.customRoleDescription = newRoleDescription
                                    distribution[.custom] = 0
                                    showingCustomRoleSheet = false
                                }
                            }
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(Translations.text(for: "cancel", language: viewModel.selectedLanguage)) {
                                showingCustomRoleSheet = false
                            }
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                        }
                    }
                }
            }
        }
    }
}

// Nasıl Oynanır görünümü
struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.3, green: 0.2, blue: 0.1)
                    .ignoresSafeArea()
                
                Image(systemName: "seal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white.opacity(0.03))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(45))
                    .position(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.2)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(Translations.text(for: "app_description", language: viewModel.selectedLanguage))
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                            .padding(.bottom)
                        
                        Text(Translations.text(for: "game_description", language: viewModel.selectedLanguage))
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                    }
                    .padding()
                }
            }
            .navigationTitle(Translations.text(for: "how_to_play", language: viewModel.selectedLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Translations.text(for: "close", language: viewModel.selectedLanguage)) {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                }
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: GameViewModel
    @State private var showingHowToPlaySheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.3, green: 0.2, blue: 0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    List {
                        Section(header: Text(Translations.text(for: "language", language: viewModel.selectedLanguage))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                            .font(.custom("Georgia", size: 18))) {
                            ForEach(Language.allCases, id: \.self) { language in
                                Button(action: {
                                    viewModel.selectedLanguage = language
                                }) {
                                    HStack {
                                        Text(language.flagEmoji)
                                            .font(.title2)
                                        Text(language.rawValue)
                                            .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                                        Spacer()
                                        if viewModel.selectedLanguage == language {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                                        }
                                    }
                                }
                                .listRowBackground(Color(red: 0.3, green: 0.2, blue: 0.1))
                            }
                        }
                        
                        Section(header: Text(Translations.text(for: "timer_settings", language: viewModel.selectedLanguage))
                            .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                            .font(.custom("Georgia", size: 18))) {
                            
                            Toggle(isOn: $viewModel.isTimerEnabled) {
                                Text(Translations.text(for: "timer_enabled", language: viewModel.selectedLanguage))
                                    .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                            }
                            .listRowBackground(Color(red: 0.3, green: 0.2, blue: 0.1))
                            .tint(Color(red: 0.8, green: 0.7, blue: 0.3))
                            
                            if viewModel.isTimerEnabled {
                                Picker("", selection: $viewModel.timerDuration) {
                                    ForEach([60, 120, 180, 240, 300], id: \.self) { seconds in
                                        if seconds < 60 {
                                            Text("\(seconds) \(Translations.text(for: "seconds", language: viewModel.selectedLanguage))")
                                        } else {
                                            Text("\(seconds/60) \(Translations.text(for: "minutes", language: viewModel.selectedLanguage))")
                                        }
                                    }
                                }
                                .pickerStyle(.menu)
                                .listRowBackground(Color(red: 0.3, green: 0.2, blue: 0.1))
                                .accentColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                            }
                        }
                        
                        Section {
                            Button(action: {
                                showingHowToPlaySheet = true
                            }) {
                                HStack {
                                    Image(systemName: "questionmark.circle.fill")
                                        .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                                    Text(Translations.text(for: "how_to_play", language: viewModel.selectedLanguage))
                                        .foregroundColor(Color(red: 0.95, green: 0.9, blue: 0.8))
                                }
                            }
                            .listRowBackground(Color(red: 0.3, green: 0.2, blue: 0.1))
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle(Translations.text(for: "settings", language: viewModel.selectedLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Translations.text(for: "done", language: viewModel.selectedLanguage)) {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.8, green: 0.7, blue: 0.3))
                }
            }
        }
        .sheet(isPresented: $showingHowToPlaySheet) {
            HowToPlayView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    ContentView()
}
