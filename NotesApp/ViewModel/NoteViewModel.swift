//
//  NoteViewModel.swift
//  NotesApp
//
//  Created by Simay Çalışkan on 10.02.2026.
//
import Foundation
import Combine
import SwiftUI




class NoteViewModel: ObservableObject {
    
    @Published var notes: [Note] = []
    
    private let saveKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    
    
    func addNote(title: String, content: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        // ❌ ikisi de boşsa ekleme
        if trimmedTitle.isEmpty && trimmedContent.isEmpty {
            return
        }

        let note = Note(
            id: UUID(),
            title: trimmedTitle,
            content: trimmedContent,
            date: Date(),
            colorHex: Color.purple.hashValue.description
            
        )

        notes.append(note)
        saveNotes()
    }

    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    
    func updateNote(id: UUID, title: String, content: String, colorHex: String? = nil) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedTitle.isEmpty && trimmedContent.isEmpty {
            return
        }

        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes[index].title = trimmedTitle
            notes[index].content = trimmedContent

            if let colorHex = colorHex {
                notes[index].colorHex = colorHex
            }

            saveNotes()
        }
    }



    
    private func saveNotes() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notes) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    
    
    private func loadNotes() {
        if let savedNotes = UserDefaults.standard.data(forKey: saveKey) {
            let decoder = JSONDecoder()
            if let decodedNotes = try? decoder.decode([Note].self, from: savedNotes) {
                notes = decodedNotes
            }
        }
    }
    
    
    
    
}

