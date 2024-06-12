//
//  ContentView.swift
//  Keyboard
//
//  Created by Maddie on 6/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var caesarCipherKey: Int = UserDefaults.standard.integer(forKey: "caesarCipherKey")
    @State private var encryptedText = ""
    @State private var decryptedText = ""
    @State private var decryptionKey: Int = 0

    var body: some View {
        VStack {
            Text("Cryptographic Keyboard")
                .font(.title)
                .padding()

            Picker("", selection: $selectedTab) {
                Text("Instructions").tag(0)
                Text("Decrypt").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedTab == 0 {
                InstructionsView()
            } else {
                DecryptView(encryptedText: $encryptedText, decryptedText: $decryptedText, decryptionKey: $decryptionKey)
            }
        }
        .padding()
    }
}

struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("How to Add the Cryptographic Keyboard")
                .font(.headline)
                .padding(.bottom, 5)

            Text("""
                1. Open the Settings app on your iPhone or iPad.
                2. Go to General > Keyboard > Keyboards.
                3. Tap "Add New Keyboard...".
                4. Under "Third-Party Keyboards", select "Cryptographic Keyboard".
                5. Once added, tap "Cryptographic Keyboard" and allow full access.
                """)
                .padding(.bottom, 20)
        }
    }
}

struct DecryptView: View {
    @Binding var encryptedText: String
    @Binding var decryptedText: String
    @Binding var decryptionKey: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("Decrypt Encrypted Text")
                .font(.headline)
                .padding(.bottom, 5)

            TextField("Enter encrypted text", text: $encryptedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)

            Text("Select Caesar Cipher Key")
                .font(.subheadline)
                .padding(.bottom, 5)

            Slider(value: Binding(
                get: { Double(decryptionKey) },
                set: { decryptionKey = Int($0) }
            ), in: 0...25, step: 1)
            .padding()

            Text("Selected Key: \(decryptionKey)")
                .font(.body)
                .padding(.bottom, 10)

            Button(action: {
                decryptedText = decrypt(text: encryptedText, key: decryptionKey)
            }) {
                Text("Decrypt")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.bottom, 10)

            Text("Decrypted Text: \(decryptedText)")
                .font(.body)
                .padding(.top, 10)
        }
        .padding()
    }

    func decrypt(text: String, key: Int) -> String {
        let letters = Array("abcdefghijklmnopqrstuvwxyz")
        let uppercaseLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

        let decryptedText = text.map { char -> Character in
            if let index = letters.firstIndex(of: char) {
                let newIndex = (index - key + letters.count) % letters.count
                return letters[newIndex]
            } else if let index = uppercaseLetters.firstIndex(of: char) {
                let newIndex = (index - key + uppercaseLetters.count) % uppercaseLetters.count
                return uppercaseLetters[newIndex]
            }
            return char
        }
        return String(decryptedText)
    }
}

#Preview {
    ContentView()
}

