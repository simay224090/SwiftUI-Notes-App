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
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }

    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
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
