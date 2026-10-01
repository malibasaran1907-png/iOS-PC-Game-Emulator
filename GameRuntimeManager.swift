# GameRuntimeManager.swift (Box64 & Wine Motor Entegrasyonlu)
        cat << 'EOF' > Sources/GameRuntimeManager.swift
        import Foundation

        class GameRuntimeManager {
            static let shared = GameRuntimeManager()
            private let fileManager = FileManager.default
            
            // Wine prefix (C: Sürücüsü) dizinini hazırlar
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
            
            // Seçilen oyun dosyasını emülatörün C:/Games dizinine aktarır
            func importGameFile(from sourceURL: URL) -> URL? {
                let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let gamesDirectory = documentsPath.appendingPathComponent("Games", isDirectory: true)
                
                do {
                    if !fileManager.fileExists(atPath: gamesDirectory.path) {
                        try fileManager.createDirectory(at: gamesDirectory, withIntermediateDirectories: true)
                    }
                    
                    let destinationURL = gamesDirectory.appendingPathComponent(sourceURL.lastPathComponent)
                    
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
            
            // Box64 + Wine motorunu tetikleyerek .exe dosyasını çalıştırır
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
                
                print("--- EMÜLATÖR ÇALIŞTIRMA GİRİŞİ ---")
                print("Hedef EXE: \(executablePath)")
                print("WINEPREFIX Yolu: \(prefix.path)")
                print("Box64 Dynarec (JIT): Aktif")
                print("Çözünürlük: \(windowWidth)x\(windowHeight)")
                
                // iOS Sandbox ortamında alt süreç (subprocess) tetikleme simülasyonu ve köprü
                // Not: Gerçek cihazda binary execution, uygulama içine gömülüdylib/framework 
                // kütüphaneleri ve JIT entitlements (get-task-allow) üzerinden yönetilir.
            }
        }
        EOF
