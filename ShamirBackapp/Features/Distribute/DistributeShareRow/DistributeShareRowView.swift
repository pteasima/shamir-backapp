import SwiftUI
import ComposableArchitecture

struct DistributeShareRowView: View {
  let store: Store<DistributeShareRowState, DistributeShareRowAction>
  
  var body: some View {
    func content(with viewStore: ViewStore<DistributeShareRowState, DistributeShareRowAction>) -> some View {
      HStack {
        Text(verbatim: "x: \(viewStore.x), y: \(viewStore.y)")
        Spacer()
        Group {
          Button(action: {}) {  Image(systemName: "doc.on.clipboard") }
          Text("/")
          Button(action: {}) {  Image(systemName: "square.and.arrow.up") }
        }
        .font(.smallButton)
      }
    }
    return WithViewStore(self.store, content: content)
  }
}
