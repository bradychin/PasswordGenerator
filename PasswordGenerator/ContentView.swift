//
//  ContentView.swift
//  PasswordGenerator
//
//  Created by Brady Chin on 2026.05.21.
//

import SwiftUI

struct ContentView: View {
    @State private var useLetters = true
    @State private var useNumbers = true
    @State private var useSpecialChars = false
    @State private var length = 11
    @State private var password = ""
    @State private var copied = false

    private let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let numbers = "0123456789"
    private let specialChars = "!@#$%^&*()-_=+[]{}|;:,.<>?"
    
    private let maxLength = 20
    private let minLength = 6
    
    var canGenerate: Bool {
        useLetters || useNumbers || useSpecialChars
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Character Types") {
                    Toggle("Letters (A–Z, a–z)", isOn: $useLetters)
                    Toggle("Numbers (0–9)", isOn: $useNumbers)
                    Toggle("Special Characters (!@#…)", isOn: $useSpecialChars)
                }

                Section("Length") {
                    HStack {
                        Text("\(length) characters")
                        Spacer()
                        Stepper("", value: $length, in: minLength...maxLength)
                            .labelsHidden()
                    }
                    Slider(value: Binding(
                        get: { Double(length) },
                        set: { length = Int($0) }
                    ), in: Double(minLength)...Double(maxLength), step: 1)
                }

                Section("Generated Password") {
                    if password.isEmpty {
                        Text("Tap Generate to create a password")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(password)
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button {
                            UIPasteboard.general.string = password
                            copied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                copied = false
                            }
                        } label: {
                            Label(copied ? "Copied!" : "Copy to Clipboard",
                                  systemImage: copied ? "checkmark" : "doc.on.doc")
                        }
                    }
                }

                Section {
                    Button {
                        password = generatePassword()
                        copied = false
                    } label: {
                        Text("Generate Password")
                            .frame(maxWidth: .infinity)
                            .bold()
                    }
                    .disabled(!canGenerate)
                }
            }
            .navigationTitle("Password Generator")
        }
    }

    private func generatePassword() -> String {
        var charset = ""
        if useLetters { charset += letters }
        if useNumbers { charset += numbers }
        if useSpecialChars { charset += specialChars }

        guard !charset.isEmpty else { return "" }

        return String((0..<length).compactMap { _ in charset.randomElement() })
    }
}

#Preview {
    ContentView()
}
