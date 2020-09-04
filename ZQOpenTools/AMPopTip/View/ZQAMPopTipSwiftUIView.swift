//
//  ZQAMPopTipSwiftUIView.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/9/3.
//  Copyright © 2020 Darren. All rights reserved.
//

#if canImport(SwiftUI) && canImport(Combine)
import SwiftUI

@available(iOS 13.0, *)
struct ZQAMPopTipSwiftUIView: SwiftUI.View {
  
  var items = [Item(string: "First"),
               Item(string: "Second"),
               Item(string: "Third"),
               Item(string: "Fourth"),
               Item(string: "Fifth")]
  
    var body: some SwiftUI.View {
    ScrollView {
      Text("Custom SwiftUI view")
      ForEach(items) { item in
        HStack {
          Image(systemName: "person.circle")
          Text(item.string)
          Spacer()
        }
        .foregroundColor(.secondary)
      }
    }
  }
}

class Item: Identifiable {
  let id = UUID()
  
  var string: String
  
  init(string: String) {
    self.string = string
  }
}

@available(iOS 13.0, *)
struct ZQAMPopTipSwiftUIView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
    ZQAMPopTipSwiftUIView()
  }
}
#endif
