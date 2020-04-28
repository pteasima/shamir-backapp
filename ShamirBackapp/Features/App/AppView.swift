//
//  ContentView.swift
//  ShamirBackapp
//
//  Created by Petr Šíma on 08/04/2020.
//  Copyright © 2020 Petr Šíma. All rights reserved.
//

import SwiftUI
import ComposableArchitecture



struct AppView: View {
  let store: Store<AppState, AppAction>
  var body: some View {
    TabView {
      DistributeView(store: store.scope(state: \.distribute, action: AppAction.distribute))
        Text("Assemble")
          .tabItem {
            Text("Assemble")
      }
    }
    .onAppear { }
    
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: .init(initialState: AppState(), reducer: appReducer, environment: AppEnvironment()))
  }
}
