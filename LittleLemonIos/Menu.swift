//
//  Menu.swift
//  LittleLemonIos
//

import CoreData
import Foundation
import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var searchText = ""

    var body: some View {
        VStack {
            Text("Little Lemon")
                .font(.largeTitle.bold())

            Text("Chicago")
                .font(.title2)

            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .font(.body)
                .padding(.vertical, 8)

            TextField("Search menu", text: $searchText)
                .textFieldStyle(.roundedBorder)

            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes, id: \.self) { dish in
                        NavigationLink(destination: DishDetails(dish: dish)) {
                            HStack {
                                Text("\(dish.title ?? "") - $\(dish.price ?? "")")

                                Spacer()

                                AsyncImage(url: URL(string: dish.image ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            getMenuData()
        }
    }

    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare)
            )
        ]
    }

    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }

    func getMenuData() {
        PersistenceController.shared.clear()

        let serverURLString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: serverURLString)!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()

                if let fullMenu = try? decoder.decode(MenuList.self, from: data) {
                    // viewContext is confined to the main queue, so the Core Data
                    // work has to hop onto that queue rather than run here on the
                    // URLSession delegate thread.
                    viewContext.perform {
                        for menuItem in fullMenu.menu {
                            let dish = Dish(context: viewContext)
                            dish.title = menuItem.title
                            dish.image = menuItem.image
                            dish.price = menuItem.price
                        }

                        try? viewContext.save()
                    }
                }
            }
        }

        task.resume()
    }
}

#Preview {
    Menu()
}
