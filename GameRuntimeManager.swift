import Foundation

class GameRuntimeManager {
    static let shared = GameRuntimeManager()
    
    private let fileManager = FileManager.default
    
    // Çalışma ortamı dizinlerini hazırlar
    func initializeWinePrefix() -> URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let winePrefix = documentsPath.appendingPathComponent(".wine", isDirectory: true)
        
        if !fileManager.fileExists(atPath: winePrefix.path) {
            do {
                try fileManager.createDirectory(at: winePrefix, withIntermediateDirectories: true, attributes: nil)
                print("Wine prefix başarıyla oluşturuldu: \(winePrefix.path)")
            } catch {
                print("Wine prefix oluşturulamadı: \(error.localizedDescription)")
            }
        }
        return winePrefix
    }
    
    // Telefonun dosya yöneticisinden seçilen oyunu uygulama dizinine kopyalar
    func importGameFile(from sourceURL: URL) -> URL? {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let gamesDirectory = documentsPath.appendingPathComponent("Games", isDirectory: true)
        
        do {
            if !fileManager.fileExists(atPath: gamesDirectory.path) {
                try fileManager.createDirectory(at: gamesDirectory, withIntermediateDirectories: true)
            }
            
            let destinationURL = gamesDirectory.appendingPathComponent(sourceURL.lastPathComponent)
            
            // Güvenlik kapsamındaki (Security-scoped) kaynağa erişimi başlat
            guard sourceURL.startAccessingSecurityScopedResource() else { return nil }
            defer { sourceURL.stopAccessingSecurityScopedResource() }
            
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            print("Oyun başarıyla içe aktarıldı: \(destinationURL.path)")
            return destinationURL
        } catch {
            print("Oyun içe aktarılamadı: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Belirtilen .exe dosyasını Box64 ve Wine ortamı ile tetikler
    func launchGame(executablePath: String, windowWidth: Int, windowHeight: Int) {
        let prefix = initializeWinePrefix()
        
        let environment: [String: String] = [
            "WINEPREFIX": prefix.path,
            "BOX64_LOG": "1",
            "WINEDEBUG": "-all",
            "MESA_GLSL_VERSION_OVERRIDE": "460"
        ]
        
        print("Oyun başlatılıyor: \(executablePath)")
        print("Hedef Çözünürlük: \(windowWidth)x\(windowHeight)")
    }
}
