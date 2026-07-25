//
//  DishDetails.swift
//  LittleLemonIos
//

import CoreData
import SwiftUI

struct DishDetails: View {
    let dish: Dish

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: dish.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.llCloud
                }
                .frame(height: 260)
                .frame(maxWidth: .infinity)
                .clipped()

                VStack(alignment: .leading, spacing: 14) {
                    if let category = dish.category, !category.isEmpty {
                        Text(category.uppercased())
                            .font(.llCaption)
                            .kerning(1.5)
                            .foregroundStyle(Color.llGreen)
                    }

                    Text(dish.title ?? "")
                        .font(.llSubDisplay)
                        .foregroundStyle(Color.llCharcoal)

                    Text("$\(dish.price ?? "")")
                        .font(.llHighlight)
                        .foregroundStyle(Color.llGreen)

                    Text(dish.details ?? "")
                        .font(.llLead)
                        .foregroundStyle(Color.llCharcoal.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
            }
        }
        .background(.white)
        .navigationTitle(dish.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
