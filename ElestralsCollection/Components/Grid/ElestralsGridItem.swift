import SwiftUI

struct ElestralsGridItem: View {

    @State var elestral: Elestral
    @EnvironmentObject var data: ElestralData
    
    var body: some View {
        Button(action: {
            elestral.isOwned.toggle()
            self.updateOwned(for: elestral)
        }, label: {
            ZStack {
                Rectangle()
                    .fill(Gradient(colors: [.white, elestral.backgroundColor]))
                    .cornerRadius(30)
                    .aspectRatio(1, contentMode: .fit)
                VStack {
                    Spacer()
                    ZStack {
                        Image(elestral.sprite)
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 0.0)
                        if !elestral.isOwned {
                            Color.gray
                                .blendMode(.color)
                        }
                    }
                    Text(elestral.name)
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

struct ElestralsGridItem_Previews: PreviewProvider {
    static var previews: some View {
        ElestralsGridItem(elestral: Elestral(name: "Teratlas", element: .earth, isOwned: false))
    }
}

struct appPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ElestralData())
    }
}
