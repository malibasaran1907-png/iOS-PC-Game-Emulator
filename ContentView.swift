import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("iOS PC Oyun Emülatörü")
                .font(.title)
                .bold()
            
            Text("Box64 + Wine Çekirdeği Hazır")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                let manager = GameRuntimeManager.shared
                _ = manager.initializeWinePrefix()
                manager.launchGame(executablePath: "C:/Games/sample.exe", windowWidth: 1280, windowHeight: 720)
            }) {
                Text("Test Ortamını Başlat")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
