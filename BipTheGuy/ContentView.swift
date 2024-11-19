//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Jannis Bauer on 10.11.24.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    animateImage = false // will immediately shrink using .scaleEffect to 90% of size
                    withAnimation (.spring(response: 0.3, dampingFraction: 0.3)) {
                        animateImage = true // will go from 90% size to 100% size but using the .spring animation
                    }
                }
            
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                Task {
                    if let newImage = try? await selectedPhoto?.loadTransferable(type: Image.self) {
                        bipImage = newImage
                    } else {
                        print("Failed to set new image")
                    }
                }
            }
        }
        .padding()
    }
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer")
            
        }
    }
}

#Preview {
    ContentView()
}
