import SwiftUI

struct ReceiptCell: View {
    @Environment(\.designSystemFonts) fileprivate var dsFonts
    @Environment(\.designSystemColors) fileprivate var dsColors
    @Environment(\.designSystemIcons) fileprivate var dsIcons
    @Environment(\.designSystemIllustrations) private var dsIllustrations
    let receipt: DepositReceipt
    
    var body: some View {
        HStack {
            Image(ds: dsIllustrations.receipt)
                .resizable()
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading) {
                Text(receipt.store)
                    .font(.ds(dsFonts.header2Heading))
                    .foregroundStyle(.primaryText)
                
                Text("\(purchaseDate: receipt.date)")
                    .font(.ds(dsFonts.bodySmall))
                    .foregroundStyle(.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .trailing) {
                Text(receipt.state.tagTitle)
                    .font(.ds(dsFonts.captionBold))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(receipt.state.tagBackgroundColor(with: dsColors))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                Text("\(amount: receipt.amount)")
            }
        }
        .padding(8)
//        .overlay(alignment: .topTrailing) {
//            Circle()
//                .fill(tagBackgroundColor)
//                .frame(width: 12)
//        }
    }
}
