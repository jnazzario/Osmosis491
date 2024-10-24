import SwiftUI
struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var elapsedTime: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background color
                Color(red: 0.1, green: 0.4, blue: 0.35).edgesIgnoringSafeArea(.all)

                VStack {
                    // Top row (Score and Timer)
                    HStack {
                        // Score Counter
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.3529, green: 0.6980, blue: 0.6314))
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05)
                            .padding(.leading, 20)

                        Spacer()

                        // Timer at the top right
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.3529, green: 0.6980, blue: 0.6314))
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05)
                            .overlay(
                                Text(timerString(from: elapsedTime))
                                    .font(.custom("TAN - MON CHERI", size: 16))
                                    .foregroundColor(.black)
                            )
                            .padding(.trailing, 20)
                    }
                    .padding(.top, 30)

                    Spacer()

                    // Display Reserve Piles and Foundations
                    HStack {
                        // Reserve Piles
                        ScrollView(.vertical) {
                            VStack(spacing: 5) {
                                ForEach(0..<viewModel.reservePiles.count, id: \.self) { index in
                                    VStack {
                                        if let topCard = viewModel.reservePiles[index].last {
                                            CardView(card: topCard)
                                                .onTapGesture {
                                                    for foundationIndex in 0..<viewModel.foundations.count {
                                                        viewModel.moveCard(fromReserve: index, toFoundation: foundationIndex)
                                                    }
                                                }
                                        } else {
                                            EmptyPileView()
                                        }
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                        .frame(width: geometry.size.width * 0.2)
                        .padding(.leading, 20)

                        Spacer()

                        // Foundation Piles
                        VStack {
                            Spacer()

                            HStack(spacing: 10) {
                                ForEach(0..<viewModel.foundations.count, id: \.self) { index in
                                    VStack {
                                        if let topCard = viewModel.foundations[index].last {
                                            CardView(card: topCard)
                                        } else {
                                            EmptyPileView()
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .padding()

                            Spacer()
                        }
                    }

                    Spacer()

                    // Bottom row (menu, hint, and undo buttons)
                    HStack(spacing: 45) {
                        // Menu button
                        NavigationLink(destination: ContentView()) {
                            Text("menu")
                                .font(.custom("TAN - MON CHERI", size: 17))
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: geometry.size.width * 0.25)
                                .background(Color(hex: "#5ab2a1"))
                                .cornerRadius(20)
                        }
                        .padding(15)

                        // Hint Button
                        Button(action: {}) {
                            Text("hint")
                                .font(.custom("TAN - MON CHERI", size: 17))
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: geometry.size.width * 0.25)
                                .background(Color(hex: "#5ab2a1"))
                                .cornerRadius(20)
                        }

                        // Undo Button
                        Button(action: {}) {
                            Image(systemName: "arrow.uturn.backward")
                                .foregroundColor(.yellow)
                                .padding()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                .background(Color(hex: "#5ab2a1"))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 20)
                }

            } // ZStack end
        } // GeometryReader end
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                elapsedTime += 1
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    // Helper function to format time
    private func timerString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
