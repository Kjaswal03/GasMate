//
//  ListView.swift
//  GasMate
//
//  Created by Kashev Jaswal on 6/6/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.gasStations) { station in
                NavigationLink(destination: DetailView(gasStation: station).environmentObject(viewModel)) {
                    HStack(alignment: .top) {
                        Image(systemName: "fuelpump.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(station.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(station.priceSummary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(station.address)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.4), radius: 3, x: 0, y: 3)
                }
            }
            .navigationTitle("Nearby Gas Stations")
            .listStyle(PlainListStyle())
            .padding(.horizontal)
            .background(Color(.systemGroupedBackground))
        }
    }
}
