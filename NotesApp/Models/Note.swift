//
//  Note.swift
//  NotesApp
//
//  Created by Simay Çalışkan on 10.02.2026.
//
import Foundation

struct Note: Identifiable,Codable,Equatable {
    
    let id: UUID
    var title: String
    var content: String
    var date: Date
}
