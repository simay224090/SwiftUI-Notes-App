import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = NoteViewModel()
    @State private var newTitle: String = ""
    @State private var newContent: String = ""
    
    @State private var editingNoteID: UUID? = nil
    @State private var editedTitle: String = ""
    @State private var editedContent: String = ""

    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    ForEach(viewModel.notes) { note in
                        HStack {
                            Spacer()
                            ColorPicker("", selection: Binding(
                                get: {
                                    Color(hex: note.colorHex)
                                },
                                set: { newColor in
                                    viewModel.updateNote(
                                        id: note.id,
                                        title: note.title,
                                        content: note.content,
                                        colorHex: newColor.toHex()
                                    )
                                }
                            ))
                            .labelsHidden()
                        }

                        VStack(alignment: .leading, spacing: 6) {

                            if editingNoteID == note.id {
                                // ✏️ EDIT MODU
                                TextField("Title", text: $editedTitle)
                                    .textFieldStyle(.roundedBorder)

                                TextEditor(text: $editedContent)
                                    .frame(height: 80)
                                    .padding(4)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)

                                Button("Kaydet") {
                                    viewModel.updateNote(
                                        id: note.id,
                                        title: editedTitle,
                                        content: editedContent
                                    )
                                    editingNoteID = nil
                                }


                            } else {
                                // 👁 NORMAL MOD
                                Text(note.title)
                                    .font(.headline)

                                Text(note.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text(note.date, style: .date)
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: note.colorHex))
                                .shadow(radius: 3)
                        )
                        .padding(.vertical, 4)

                        // 👉 SAĞA KAYDIR = EDIT
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                editingNoteID = note.id
                                editedTitle = note.title
                                editedContent = note.content
                            }
                            .tint(.blue)
                        }

                        // 👉 SOLA KAYDIR = DELETE
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteNote(note)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }

                    }

                     
                }
                
                // 🔴 DEĞİŞTİ → Not ekleme alanı daha düzenli
                VStack(spacing: 12) {
                    TextField("Title", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                        .font(.headline)
                    
                    // 🔴 DEĞİŞTİ → TextField yerine TextEditor (çok satır)
                    TextEditor(text: $newContent)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                       
                
                    Button {
                        viewModel.addNote(title: newTitle, content: newContent)
                        newTitle = ""
                        newContent = ""
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle")
                            Text("Ekle")
                        }
                        .font(.headline)
                        .foregroundColor(.indigo)
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

