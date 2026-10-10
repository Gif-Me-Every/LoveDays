import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: LoveStore

    var body: some View {
        if store.state.startDate == nil {
            SetupView()
        } else {
            TabView {
                HomeView().tabItem { Label("Us", systemImage: "heart.fill") }
                GalleryView().tabItem { Label("Memories", systemImage: "photo.on.rectangle.angled") }
                MilestonesView().tabItem { Label("Milestones", systemImage: "star.fill") }
                NotesView().tabItem { Label("Notes", systemImage: "envelope.fill") }
            }
            .tint(.pink)
        }
    }
}

struct SetupView: View {
    @EnvironmentObject var store: LoveStore
    @State private var name1 = ""
    @State private var name2 = ""
    @State private var date = Date()

    var body: some View {
        ZStack {
            LoveBackground()
            FloatingHearts()
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "heart.fill")
                    .font(.system(size: 80)).foregroundColor(.pink)
                Text("Our Love Story")
                    .font(.system(.largeTitle, design: .rounded).weight(.bold)).foregroundColor(.pink)
                VStack(spacing: 12) {
                    TextField("Your name", text: $name1).textFieldStyle(.roundedBorder)
                    TextField("Their name", text: $name2).textFieldStyle(.roundedBorder)
                    DatePicker("We started dating", selection: $date, in: ...Date(), displayedComponents: .date)
                        .tint(.pink)
                }.loveCard()
                Button {
                    store.state.name1 = name1
                    store.state.name2 = name2
                    store.state.startDate = date
                } label: {
                    Text("Start counting 💕")
                        .font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.pink, in: Capsule())
                }
                Spacer()
            }.padding()
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var store: LoveStore
    @Environment(\.dismiss) var dismiss
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Names") {
                    TextField("Your name", text: $store.state.name1)
                    TextField("Their name", text: $store.state.name2)
                }
                Section("Anniversary") {
                    DatePicker("Started dating", selection: $date, in: ...Date(), displayedComponents: .date)
                }
            }
            .tint(.pink)
            .navigationTitle("Settings")
            .toolbar { Button("Done") { store.state.startDate = date; dismiss() } }
            .onAppear { date = store.state.startDate ?? Date() }
        }
    }
}
