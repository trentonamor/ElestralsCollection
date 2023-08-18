import SwiftUI

struct ElestralsGridItem: View {

    @ObservedObject var data: ElestralCard
    
    var body: some View {
        Button(action: {
            // Handle button action here
        }, label: {
            ZStack {
                Rectangle()
                    .fill(Gradient(colors: [.white, data.getBackgroundColor()]))
                    .cornerRadius(30)
                    .aspectRatio(1, contentMode: .fit)
                VStack {
                    Spacer()
                    ZStack {
                        Image(data.getSprite())
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 0.0)
                        if data.numberOwned == 0 {
                            Color.gray
                                .blendMode(.color)
                        }
                    }
                    Text(data.name)
                        .font(.footnote)
                        .bold()
                        .padding(.top, 0.0)
                        .padding([.bottom, .horizontal])
                        .foregroundColor(.black)
                }
                .aspectRatio(1, contentMode: .fill)
            }
        })
    }
}
