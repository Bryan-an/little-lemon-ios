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
    @State private var selectedCategory: String?

    private let categories = ["Starters", "Mains", "Desserts"]

    var body: some View {
        VStack(spacing: 0) {
            BrandBar()

            ScrollView {
                VStack(spacing: 0) {
                    hero

                    deliverySection
                }
            }
            .background(.white)
        }
        .background(Color.llCloud)
        .onAppear {
            getMenuData()
        }
    }

    // MARK: - Hero

    private var hero: some View {
        HeroBanner {
            searchField
                .padding(.top, 20)
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.llCharcoal)

            TextField("Search menu", text: $searchText)
                .font(.llBody)
                .foregroundStyle(Color.llCharcoal)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.llCloud, in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Menu list

    private var deliverySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ORDER FOR DELIVERY!")
                .font(.llSectionTitle)
                .kerning(0.5)
                .foregroundStyle(Color.llCharcoal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryPill(
                            title: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
            }

            Divider()

            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                if dishes.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(dishes, id: \.self) { dish in
                            NavigationLink(destination: DishDetails(dish: dish)) {
                                DishRow(dish: dish)
                            }
                            .buttonStyle(.plain)

                            Divider()
                        }
                    }
                }
            }
        }
        .padding(20)
    }

    private var emptyState: some View {
        VStack(spacing: 6) {
            Text("Nothing on the menu matches that.")
                .font(.llLead)
                .foregroundStyle(Color.llCharcoal)

            Text("Try another dish name or clear the filters.")
                .font(.llBody)
                .foregroundStyle(Color.llCharcoal.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    // MARK: - Fetching

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
        var predicates: [NSPredicate] = []

        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }

        if let selectedCategory {
            predicates.append(NSPredicate(format: "category ==[cd] %@", selectedCategory))
        }

        if predicates.isEmpty {
            return NSPredicate(value: true)
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    func getMenuData() {
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
                        // Clear here rather than when the request starts. The
                        // screen refetches every time it appears, so two requests
                        // can overlap; clearing up front would let both wipe an
                        // empty store and then each insert a full menu, doubling
                        // every row. Clearing next to the insert keeps the pair
                        // atomic, so the last response wins.
                        PersistenceController.shared.clear()

                        for menuItem in fullMenu.menu {
                            let dish = Dish(context: viewContext)
                            dish.title = menuItem.title
                            dish.image = menuItem.image
                            dish.price = menuItem.price
                            dish.details = menuItem.description
                            dish.category = menuItem.category
                        }

                        try? viewContext.save()
                    }
                }
            }
        }

        task.resume()
    }
}

// MARK: - Row

struct DishRow: View {
    let dish: Dish

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(dish.title ?? "")
                    .font(.llCardTitle)
                    .foregroundStyle(Color.llCharcoal)

                Text(dish.details ?? "")
                    .font(.llBody)
                    .foregroundStyle(Color.llCharcoal.opacity(0.75))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text("$\(dish.price ?? "")")
                    .font(.llHighlight)
                    .foregroundStyle(Color.llGreen)
            }

            Spacer(minLength: 0)

            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.llCloud
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}
