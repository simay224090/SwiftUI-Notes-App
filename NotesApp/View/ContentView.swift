import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = NoteViewModel()
    @State private var newTitle: String = ""
    @State private var newContent: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    ForEach(viewModel.notes) { note in
                        
                        // 🔴 DEĞİŞTİ → Not görünümü kart gibi yapıldı
                        VStack(alignment: .leading, spacing: 6) {
                            Text(note.title)
                                .font(.headline)
                            
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(note.date, style: .date)
                                .font(.caption)
                        }
                        .padding() // 🔴 DEĞİŞTİ
                        .background( // 🔴 DEĞİŞTİ
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 1.0, green: 0.98, blue: 0.9))
                                .shadow(radius: 3)
                        )
                        .padding(.vertical, 4) // 🔴 DEĞİŞTİ
                    }
                    .onDelete(perform: viewModel.deleteNote)
                }
                
                // 🔴 DEĞİŞTİ → Not ekleme alanı daha düzenli
                VStack(spacing: 12) {
                    TextField("Title", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                    
                    // 🔴 DEĞİŞTİ → TextField yerine TextEditor (çok satır)
                    TextEditor(text: $newContent)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    Button("Ekle") {
                        if !newTitle.isEmpty || !newContent.isEmpty {
                            let note = Note(
                                id: UUID(),
                                title: newTitle,
                                content: newContent,
                                date: Date()
                            )
                            viewModel.addNote(note)
                            newTitle = ""
                            newContent = ""
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Notes")
        }
    }
}

#Preview {
    ContentView()
}

