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
            date: Date()
        )

        notes.append(note)
        saveNotes()
    }

    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    
    func updateNote(id: UUID, title: String, content: String) {
        // ❌ İkisi de boşsa güncelleme yapma
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
           content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }

        guard let index = notes.firstIndex(where: { $0.id == id }) else { return }

        notes[index].title = title
        notes[index].content = content
        saveNotes()
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
