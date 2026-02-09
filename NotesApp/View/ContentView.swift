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
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(note.date, style: .date)
                                .font(.caption)
                        }
                    }
                    .onDelete(perform: viewModel.deleteNote)
                }
                
                VStack {
                    TextField("Title", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Content", text: $newContent)
                        .textFieldStyle(.roundedBorder)
                    
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
