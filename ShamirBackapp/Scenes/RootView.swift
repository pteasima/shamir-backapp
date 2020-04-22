//
//  ContentView.swift
//  ShamirBackapp
//
//  Created by Petr Šíma on 08/04/2020.
//  Copyright © 2020 Petr Šíma. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var store = Store()
    var body: some View {
      TabView {
        EncodeView(store: store)
        Text("Decode")
          .tabItem {
            Text("Decode")
        }
      }
      .onAppear { self.store.onStart() }
      
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
