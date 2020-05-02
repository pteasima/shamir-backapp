import Foundation
import SwiftUI
import ShamirKit
import ComposableArchitecture

struct DistributeView: View {
  let store: Store<DistributeState, DistributeAction>
  struct ViewState: Equatable {
    var isMaskEnabled: Bool
    var secretText: String
    var isPasteDisabled: Bool
    var threshold: Int
    var isInputSectionDisabled: Bool
    var isGenerateDisabled: Bool
    var generateButtonText: String
    var generateButtonColor: Color
    var generatedShares: SharesContainer?
  }
  
  var body: some View {
    func content(with viewStore: ViewStore<ViewState, DistributeAction>) -> some View {
      func inputSection() -> some View {
        func textInputView() -> some View {
          Group {
            HStack {
              Text("Enter your secret")
              Spacer()
              Button(action: { viewStore.send(.pasteFromClipboardTapped) }) {
                Image(systemName: "doc.on.clipboard.fill")
                  .font(.button)
              }
              .disabled(viewStore.isPasteDisabled)
            }
            TextField("Secret", text: viewStore.binding(get: \.secretText, send: DistributeAction.secretTextChanged))
              .disableAutocorrection(true)
              .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
              Spacer()
              Toggle(isOn: viewStore.binding(get: \.isMaskEnabled, send: DistributeAction.isMaskEnabledChanged)) {
                HStack {
                  Spacer()
                  Text("Mask")
                }
              }
            }
          }
        }
        
        func sliders() -> some View {
          func slider(title: String) -> some View {
            HStack(spacing: 20) {
              Text(title)
              Slider(value: viewStore.binding(get: { Double($0.threshold) }, send: DistributeAction.thresholdChanged), in: 1...20)
              Text(verbatim: String(describing: viewStore.threshold))
                .font(Font.title)
            }
          }
          
          return VStack(spacing: 0) {
            slider(title: "Threshold:")
            HStack { Spacer(); Text("of") }
            slider(title: "Number of Shares:")
          }
        }
        
        func generateSharesButton() -> some View {
          Button(action: { viewStore.send(.generateButtonTapped) }) {
            Text(viewStore.generateButtonText)
              .padding()
          }
          .background(viewStore.generateButtonColor)
          .cornerRadius(8)
          .foregroundColor(Color.white)
          .font(Font.title.bold())
          .disabled(viewStore.isGenerateDisabled)
        }
        
        return Section {
          VStack {
            Group {
              textInputView()
              sliders()
            }
            .disabled(viewStore.isInputSectionDisabled)
            generateSharesButton()
          }
          .padding([.top, .bottom])
        }
      }
      //thats a lot of stores and viewstores, might warrant its own View at some point
      func generatedSharesSection(store: Store<SharesContainer, DistributeAction>) -> some View {
        func content(with viewStore: ViewStore<SharesContainer, DistributeAction>) -> some View {
          func header() -> some View {
            HStack {
              VStack(alignment: .leading) {
                HStack{
                  Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                  Text("Generated \(viewStore.state.shares.count) shares.")
                }
                .font(.title)
                
                Text("Modulus: 2") + Text(verbatim: "\(viewStore.bitWidth)").font(Font.footnote).baselineOffset(6) + Text(" - 1")
              }
              Spacer()
              Group {
                Button(action: {}) {  Image(systemName: "doc.on.clipboard") }
                Text("/")
                Button(action: {}) {  Image(systemName: "square.and.arrow.up.on.square") }
              }
              .font(.button)
            }
          }
          return Section {
            header()
            ForEachStore(store.scope(state: { IdentifiedArray($0.fullShares, id: \.x) }, action: DistributeAction.shareRow), content: DistributeShareRowView.init(store:))
          }
        }
        return WithViewStore(store, content: content)
      }
      return NavigationView {
        Form {
          inputSection()
          IfLetStore(self.store.scope(state: \.generatedShares), then: generatedSharesSection)
        }
        .buttonStyle(BorderlessButtonStyle())
        .navigationBarTitle("Distribute a Secret")
      }
      .onAppear { viewStore.send(.`init`) }
      .tabItem {
        Text("Distribute")
      }
      
    }
    return WithViewStore(self.store.scope(state: \.view), content: content)
  }
}

extension DistributeState {
  var view: DistributeView.ViewState {
    let isGenerateDisabled = status == .collectingInput && secretText.isEmpty
    return .init(
      isMaskEnabled: isMaskEnabled,
      secretText: isMaskEnabled ? String(repeating: "*", count: secretText.count) : secretText,
      isPasteDisabled: pasteboardString?.isEmpty ?? true,
      threshold: threshold,
      isInputSectionDisabled: status != .collectingInput,
      isGenerateDisabled: isGenerateDisabled,
      generateButtonText: {
        switch status {
        case .collectingInput:
          return "Generate Shares"
        case .showingResults:
          return "Modify Input"
        }
    }(),
      generateButtonColor: {
        guard !isGenerateDisabled else { return .gray }
        switch status {
        case .collectingInput:
          return .green
        case .showingResults:
          return .red
        }
    }(),
      generatedShares: generatedShares
    )
  }
}
