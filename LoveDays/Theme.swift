import SwiftUI

struct LoveBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(red: 1, green: 0.93, blue: 0.96), Color(red: 1, green: 0.80, blue: 0.88)],
            startPoint: .top, endPoint: .bottom
        ).ignoresSafeArea()
    }
}

extension View {
    func loveCard() -> some View {
        self.padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22))
            .shadow(color: .pink.opacity(0.18), radius: 8, y: 4)
    }
}

struct HeartSpec {
    let x = CGFloat.random(in: 0...1)
    let size = CGFloat.random(in: 12...32)
    let duration = Double.random(in: 7...14)
    let delay = Double.random(in: 0...6)
    let opacity = Double.random(in: 0.15...0.45)
}

struct FloatingHearts: View {
    @State private var animate = false
    private let hearts = (0..<14).map { _ in HeartSpec() }

    var body: some View {
        GeometryReader { geo in
            ForEach(Array(hearts.enumerated()), id: \.offset) { _, h in
                Image(systemName: "heart.fill")
                    .font(.system(size: h.size))
                    .foregroundColor(.pink.opacity(h.opacity))
                    .position(x: h.x * geo.size.width,
                              y: animate ? -40 : geo.size.height + 40)
                    .animation(.linear(duration: h.duration).repeatForever(autoreverses: false).delay(h.delay),
                               value: animate)
            }
        }
        .allowsHitTesting(false)
        .onAppear { animate = true }
    }
}
