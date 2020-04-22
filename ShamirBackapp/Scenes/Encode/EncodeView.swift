import Foundation
import SwiftUI

struct EncodeView: View {
  @ObservedObject var store: Store
  
  var body: some View {
    NavigationView {
      List {
        Section {
          VStack {
            textInputView()
            slider(title: "Threshold:")
            HStack { Spacer(); Text("of") }
            slider(title: "Number of Shares:")
            generateSharesButton()
          }
          .padding([.top, .bottom])
        }
        Section {
          ForEach(0..<3) {
            Text(String(describing: $0))
          }
        }
      }
      .listStyle(GroupedListStyle())
        .buttonStyle(BorderlessButtonStyle())//override the List-style for all subviews
        .tabItem {
          Text("Encode")
      }
      .navigationBarTitle("Encode")
    }
  }
  
  func textInputView() -> some View {
    Group {
      HStack {
        Text("Enter your secret")
        Spacer()
        Button(action: { self.store.pasteFromClipboard() }) {
          Image(systemName: "doc.on.clipboard")
        }
        .disabled(store.isPasteDisabled)
      }
      TextField("Secret", text: $store.displayedText)
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
  
  func slider(title: String) -> some View {
    HStack(spacing: 20) {
      Text(title)
      Slider(value: $store.sliderThreshold, in: 1...20)
      Text(verbatim: String(describing: store.threshold))
        .font(Font.title)
    }
  }
  
  func generateSharesButton() -> some View {
    Button(action: { self.store.generateShares() }) {
      Text("Generate Shares")
      .padding()
    }
    .background(store.isGenerateSharesDisabled ? Color.gray : .green)
    .cornerRadius(8)
    .foregroundColor(Color.white)
    .font(Font.title.bold())
    .disabled(store.isGenerateSharesDisabled)
  }
}

