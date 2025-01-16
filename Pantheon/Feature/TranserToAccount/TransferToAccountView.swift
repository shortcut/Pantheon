
import SwiftUI

struct TransferToAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var repository: ReceiptRepository
    var body: some View {
        VStack(spacing: 16) {
            Text(repository.receipts[0].store)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.textBlue)
                .padding(.top, 24)

            VStack(alignment: .leading, spacing: 8) {
                Text("Til overføring")
                    .foregroundStyle(.textBlue)
                Text(repository.receipts[0].amount, format: .currency(code: "NOK"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primaryBackground)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke()
                            .fill(.lightBorder)
                    )
                    .shadow(color: .lightBorder.opacity(0.4), radius: 10)
            }
            .padding(.top, 32)

            HStack(spacing: 16) {
                Image(.sbanken)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sbanken ASA")
                        .fontWeight(.light)
                        .foregroundStyle(.textBlue)
                    Text("Kort som ender med 1234")
                        .font(.caption)
                        .foregroundStyle(.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {

                } label: {
                    Text("Endre")
                        .fontWeight(.bold)
                }

            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke()
                            .fill(.lightBorder)
                    )
                    .shadow(color: .lightBorder.opacity(0.4), radius: 10)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .safeAreaInset(edge: .bottom) {
            Button {
                dismiss()
            } label: {
                Text("Bekreft")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.surfaceText)
                    .background(.primaryBackground)
                    .cornerRadius(8)
            }
            .padding(24)
        }
    }
}

#Preview {
    TransferToAccountView()
}
