import Foundation
import SwiftUI
import ShamirKit

struct EncodeView: View {
  @ObservedObject var store: Store
  
  var body: some View {
    NavigationView {
      Form {
        inputSection()
        store.generatedShares.map(generatedSharesSection)
      }
      .navigationBarTitle("Encode")
    }
    .tabItem {
        Text("Encode")
    }
  }
  
  func inputSection() -> some View {
    func textInputView() -> some View {
      Group {
        HStack {
          Text("Enter your secret")
          Spacer()
          Button(action: { self.store.pasteFromClipboard() }) {
            Image(systemName: "doc.on.clipboard.fill")
              .font(.button)
          }
          .disabled(store.isPasteDisabled)
        }
        TextField("Secret", text: $store.displayedSecretText)
          .disableAutocorrection(true)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        HStack {
          Spacer()
          Toggle(isOn: $store.isMaskEnabled) {
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
          Slider(value: $store.sliderThreshold, in: 1...20)
          Text(verbatim: String(describing: store.threshold))
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
      Button(action: { self.store.generateButtonTapped() }) {
        Text(store.generateButtonText)
          .padding()
      }
      .background(store.generateButtonColor)
      .cornerRadius(8)
      .foregroundColor(Color.white)
      .font(Font.title.bold())
      .disabled(store.isGenerateDisabled)
    }
    
    return Section {
      VStack {
        Group {
          textInputView()
          sliders()
        }
        .disabled(store.isInputSectionDisabled)
        generateSharesButton()
      }
      .padding([.top, .bottom])
    }
  }
  
  func generatedSharesSection(shares sharesContainer: Shares) -> some View {
    func header() -> some View {
      HStack {
        VStack(alignment: .leading) {
          HStack{
            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
            Text("Generated \(sharesContainer.shares.count) shares.")
          }
          .font(.title)
          
          Text("Modulus: 2") + Text(verbatim: "\(sharesContainer.mersennePrimePower)").font(Font.footnote).baselineOffset(6) + Text(" - 1")
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
      ForEach(sharesContainer.shares, id: \.x) { share in
        HStack {
          Text(String(describing: share))
          Spacer()
          Group {
            Button(action: {}) {  Image(systemName: "doc.on.clipboard") }
            Text("/")
            Button(action: {}) {  Image(systemName: "square.and.arrow.up") }
          }
          .font(.smallButton)
        }
      }
    }
  }
  
}
