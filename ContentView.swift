import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isImporterPresented = false
    @State private var importedGameName: String = "Henüz oyun seçilmedi"
    @State private var selectedGameURL: URL?
    
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("iOS PC Oyun Emülatörü")
                .font(.title)
                .bold()
            
            // Seçilen oyunun adını gösteren kutu
            VStack(spacing: 8) {
                Text("Aktif Oyun:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(importedGameName)
                    .font(.subheadline)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Dosya Seçme Butonu
            Button(action: {
                isImporterPresented = true
            }) {
                HStack {
                    Image(systemName: "folder.badge.plus")
                    Text("Oyun Dosyası Seç (.exe)")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            // Oyunu Başlatma Butonu (Sadece oyun seçildiyse aktif olur)
            if selectedGameURL != nil {
                Button(action: {
                    if let url = selectedGameURL {
                        GameRuntimeManager.shared.launchGame(
                            executablePath: url.path,
                            windowWidth: 1280,
                            windowHeight: 720
                        )
                    }
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Oyunu Başlat")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(20)
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.item], // Tüm dosya türlerine izin ver (veya .data)
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedURL = try result.get().first else { return }
                if let savedURL = GameRuntimeManager.shared.importGameFile(from: selectedURL) {
                    selectedGameURL = savedURL
                    importedGameName = savedURL.lastPathComponent
                }
            } catch {
                print("Dosya seçme hatası: \(error.localizedDescription)")
            }
        }
    }
}
