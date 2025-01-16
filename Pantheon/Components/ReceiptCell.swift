import SwiftUI
import DesignSystem

struct ReceiptCell: View {
    @Environment(\.designSystemFonts) fileprivate var dsFonts
    @Environment(\.designSystemColors) fileprivate var dsColors
    @Environment(\.designSystemIcons) fileprivate var dsIcons
    @Environment(\.designSystemSpacing) fileprivate var dsSpacing
    @Environment(\.designSystemSizing) fileprivate var dsSizing
    @Environment(\.designSystemIllustrations) private var dsIllustrations
    
    let receipt: DepositReceipt
    
    var body: some View {
        HStack {
            Image(ds: dsIllustrations.receipt)
                .resizable()
                .frame(width: dsSizing.size5XL, height: dsSizing.size5XL)
            
            VStack(alignment: .leading) {
                Text(receipt.store)
                    .font(.ds(dsFonts.header2Heading))
                    .foregroundStyle(dsColors.textDefault)
                
                Text("\(purchaseDate: receipt.date)")
                    .font(.ds(dsFonts.bodySmall))
                    .foregroundStyle(dsColors.textSubtle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .trailing) {
                Text(receipt.state.tagTitle)
                    .font(.ds(dsFonts.captionBold))
                    .padding(.horizontal, dsSpacing.spaceXS)
                    .padding(.vertical, dsSpacing.space2XS)
                    .background(receipt.state.tagBackgroundColor(with: dsColors))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                Text("\(amount: receipt.amount)")
            }
        }
        .padding(dsSpacing.spaceXS)
    }
}
