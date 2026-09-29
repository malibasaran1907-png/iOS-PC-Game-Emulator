import Foundation

class GameRuntimeManager {
    static let shared = GameRuntimeManager()
    
    private let fileManager = FileManager.default
    
    // Çalışma ortamı dizinlerini hazırlar (C: Sürücüsü simülasyonu için kök dizin)
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
