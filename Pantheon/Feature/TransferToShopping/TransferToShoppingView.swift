import SwiftUI

struct TransferToShoppingView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Skann strekkoden ved kassen.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primaryBackground)
                Image(.barcode)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(.primaryText)
                    .frame(height: 100)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white)
                    .shadow(color: .shoppingListCellShadow,
                            radius: 8, x: 2, y: 2)
            )
            .padding(24)
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
            } label: {
                Text("Ferdig")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.primaryBackground)
                    )
                    .padding()
            }

        }
    }
}


#Preview {
    TransferToShoppingView()
}
