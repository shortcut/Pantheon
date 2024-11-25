import SwiftUI

struct ReceiptCell: View {
    let receipt: DepositReceipt

    var tagTitle: String {
        switch receipt.state {
        case .isNew:
            return "Ny"
        case .expiresSoon:
            return "Utgår snart"
        case .normal:
            return ""
        case .alreadyUsed:
            return "Brukt"
        }
    }

    var tagBackgroundColor: Color {
        switch receipt.state {
        case .expiresSoon: return .red
        case .isNew: return .green
        case .normal: return .white
        case .alreadyUsed: return .primaryBackground
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                Image("receipt")
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.secondaryText)

                    )

                VStack(alignment: .leading) {
                    Text(receipt.store)
                        .font(.headline)
                        .foregroundStyle(.primaryText)

                    Text(receipt.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack {
                    Text(receipt.amount.formatted(.currency(code: "NOK")))
                        .font(.body)
                        .fontWeight(.semibold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.primaryText)

                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.white)
                    .shadow(color: .shoppingListCellShadow,
                            radius: 8, x: 2, y: 2)
            )
            .padding(.horizontal)

            if receipt.state != .normal {
//                Text(tagTitle)
//                    .font(.caption).bold()
//                    .padding(.horizontal, 4)
//                    .padding(.vertical, 2)
//                    .background(tagBackgroundColor)
//                    .foregroundStyle(.white)
//                    .clipShape(Capsule())
//                    .frame(alignment: .topLeading)
//                    .offset(x: -12)
                Circle()
                    .fill(tagBackgroundColor)
                    .frame(width: 12)
                    .offset(x: -12, y: -4)
            }
        }
    }
}
