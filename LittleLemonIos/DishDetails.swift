//
//  DishDetails.swift
//  LittleLemonIos
//

import CoreData
import SwiftUI

struct DishDetails: View {
    let dish: Dish

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 240)

            Text(dish.title ?? "")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("$\(dish.price ?? "")")
                .font(.title2)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle(dish.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
