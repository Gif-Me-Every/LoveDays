import SwiftUI

struct Memory: Identifiable, Codable, Hashable {
    var id = UUID()
    var filename: String
    var caption: String = ""
    var date: Date = Date()
}

struct LoveNote: Identifiable, Codable, Hashable {
    var id = UUID()
    var text: String
    var date: Date = Date()
}

struct AppState: Codable {
    var startDate: Date? = nil
    var name1 = ""
    var name2 = ""
    var memories: [Memory] = []
    var notes: [LoveNote] = []
}

final class LoveStore: ObservableObject {
    @Published var state: AppState { didSet { save() } }

    static let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static let file = dir.appendingPathComponent("state.json")

    init() {
        if let data = try? Data(contentsOf: Self.file),
           let s = try? JSONDecoder().decode(AppState.self, from: data) {
            state = s
        } else {
            state = AppState()
        }
    }

    func save() {
        if let d = try? JSONEncoder().encode(state) { try? d.write(to: Self.file) }
    }

    func addPhoto(_ data: Data) {
        guard let img = UIImage(data: data), let jpg = img.jpegData(compressionQuality: 0.8) else { return }
        let name = UUID().uuidString + ".jpg"
        try? jpg.write(to: Self.dir.appendingPathComponent(name))
        state.memories.insert(Memory(filename: name), at: 0)
    }

    func image(for m: Memory) -> UIImage? {
        UIImage(contentsOfFile: Self.dir.appendingPathComponent(m.filename).path)
    }

    func delete(id: UUID) {
        if let m = state.memories.first(where: { $0.id == id }) {
            try? FileManager.default.removeItem(at: Self.dir.appendingPathComponent(m.filename))
            state.memories.removeAll { $0.id == id }
        }
    }
}

struct Together {
    let start: Date
    private let cal = Calendar.current
    init(start: Date) { self.start = start }

    private var s: Date { cal.startOfDay(for: start) }
    private var today: Date { cal.startOfDay(for: Date()) }

    var days: Int { max(0, cal.dateComponents([.day], from: s, to: today).day ?? 0) }
    var ymd: DateComponents { cal.dateComponents([.year, .month, .day], from: s, to: max(s, today)) }
    var years: Int { ymd.year ?? 0 }
    var months: Int { ymd.month ?? 0 }
    var dayPart: Int { ymd.day ?? 0 }
    var totalMonths: Int { years * 12 + months }
    var weeks: Int { days / 7 }
    var hours: Int { days * 24 }

    var lastMonthsary: Date { cal.date(byAdding: .month, value: totalMonths, to: s) ?? s }
    var nextMonthsary: Date { cal.date(byAdding: .month, value: totalMonths + 1, to: s) ?? s }
    var nextNumber: Int { totalMonths + 1 }
    var nextLabel: String {
        nextNumber % 12 == 0 ? "\(nextNumber / 12)-year anniversary 🎉" : "\(nextNumber)-month anniversary"
    }
    var daysUntilNext: Int { cal.dateComponents([.day], from: today, to: nextMonthsary).day ?? 0 }
    var progressToNext: Double {
        let total = Double(cal.dateComponents([.day], from: lastMonthsary, to: nextMonthsary).day ?? 30)
        let done = Double(cal.dateComponents([.day], from: lastMonthsary, to: today).day ?? 0)
        return total > 0 ? min(1, max(0, done / total)) : 0
    }

    func date(afterDays n: Int) -> Date { cal.date(byAdding: .day, value: n, to: s) ?? s }
    func dayNumber(on date: Date) -> Int {
        max(0, cal.dateComponents([.day], from: s, to: cal.startOfDay(for: date)).day ?? 0)
    }
    func daysFromToday(to date: Date) -> Int {
        cal.dateComponents([.day], from: today, to: cal.startOfDay(for: date)).day ?? 0
    }
}

let loveQuotes = [
    "You're my favorite notification. 💌",
    "Every day with you is my new favorite day.",
    "Home is wherever you are. 🏡",
    "I love you more than yesterday, less than tomorrow.",
    "You're the best thing that ever happened to me. 💕",
    "My heart is yours, always.",
    "Life is better with you in it. ✨",
    "You make ordinary days feel magical.",
    "Thank you for being you. 🌹",
    "Forever isn't long enough with you. ♾️",
    "You're my person. 🫶",
    "Still falling for you every single day."
]

var quoteOfTheDay: String {
    let d = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
    return loveQuotes[d % loveQuotes.count]
}
