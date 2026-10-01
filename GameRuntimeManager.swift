import Foundation

class GameRuntimeManager {
    static let shared = GameRuntimeManager()
    
    private let fileManager = FileManager.default
    
    // Çalışma ortamı dizinlerini ve Wine prefix (C: Sürücüsü) kökünü hazırlar
    func initializeWinePrefix() -> URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let winePrefix = documentsPath.appendingPathComponent(".wine", isDirectory: true)
        
        if !fileManager.fileExists(atPath: winePrefix.path) {
            do {
                try fileManager.createDirectory(at: winePrefix, withIntermediateDirectories: true, attributes: nil)
                print("Wine prefix (C: Sürücüsü) başarıyla oluşturuldu: \(winePrefix.path)")
            } catch {
                print("Wine prefix oluşturulamadı: \(error.localizedDescription)")
            }
        }
        return winePrefix
    }
    
    // Telefonun dosya yöneticisinden seçilen oyun dosyasını (Örn: Sonic Origins .exe) uygulama dizinine kopyalar
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
            print("Oyun başarıyla C:/Games dizinine aktarıldı: \(destinationURL.path)")
            return destinationURL
        } catch {
            print("Oyun aktarma hatası: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Box64 + Wine motorunu ve JIT parametrelerini tetikleyerek Sonic Origins vb. oyunları başlatır
    func launchGame(executablePath: String, windowWidth: Int, windowHeight: Int) {
        let prefix = initializeWinePrefix()
        
        // Box64 ve Wine için kritik ortam değişkenleri (Environment Variables)
        let environment: [String: String] = [
            "WINEPREFIX": prefix.path,
            "WINEARCH": "win64",
            "BOX64_LOG": "1",
            "BOX64_DYNAREC": "1", // JIT Dinamik Derleyici (Performans için şart)
            "WINEDEBUG": "-all",
            "MESA_GLSL_VERSION_OVERRIDE": "460"
        ]
        
        print("==========================================")
        print("🚀 OYUN BAŞLATILIYOR: Sonic Origins / Hedef EXE")
        print("📁 Dosya Yolu: \(executablePath)")
        print("💻 WINEPREFIX Kökü: \(prefix.path)")
        print("⚙️ Box64 Dynarec (JIT): Aktif")
        print("📺 Grafik Çözünürlüğü: \(windowWidth)x\(windowHeight)")
        print("Environment Tanımları: \(environment.keys.joined(separator: ", "))")
        print("==========================================")
        
        // Gerçek iOS çalıştırma aşamasında, burada Box64 kütüphane yükleyicisi 
        // ve Wine wineloader süreci tetiklenir.
    }
}
