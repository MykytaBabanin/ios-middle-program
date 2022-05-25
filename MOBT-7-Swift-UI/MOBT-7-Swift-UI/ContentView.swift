//
//  ContentView.swift
//  MOBT-7-SwiftUI
//
//  Created by Mykyta Babanin on 06.05.2022.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let title: String
    let image: String
}

struct ContentView: View {
    
    @State private var firstSectionItems: [Item] = (0..<2).map {
        Item(title: "Item #\($0)",
             image: "\($0)") }
    @State private var secondSectionItems: [Item] = (2..<5).map { Item(title: "Item #\($0)",
                                                                       image: "\($0)") }
    @State private var editMode = EditMode.inactive
    static var count = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(firstSectionItems) { item in
                        HStack {
                            ItemRow(item: item)
                        }
                    } .onDelete(perform: onDelete(offsets:))
                        .onMove(perform: onMove(source:destination:))
                }
                
                Section {
                    ForEach(secondSectionItems) { item in
                        HStack {
                            ItemRow(item: item)
                        }
                    } .onDelete(perform: onDelete(offsets:))
                        .onMove(perform: onMove(source:destination:))
                }
                
            } .navigationBarTitle("List")
                .navigationBarItems(leading: EditButton(), trailing: addButton)
                .environment(\.editMode, $editMode)
        }
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        firstSectionItems.remove(atOffsets: offsets)
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        firstSectionItems.move(fromOffsets: source, toOffset: destination)
    }
    
    func onAdd() {
        firstSectionItems.append(Item(title: "Item #\(Self.count)", image: "\(Self.count)"))
        Self.count += 1
    }
}

struct ItemRow: View {
    @State private var itemId = ""
    @State private var itemTitle = ""
    let item: Item
    
    var body: some View {
        TextField(item.title, text: $itemId)
        TextField(item.title, text: $itemTitle)
        Image(item.image)
            .onTapGesture {
                print(item.image)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
