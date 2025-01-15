//
//  HomeView.swift
//  GasMate
//
//  Created by Kashev Jaswal on 6/6/24.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var isLoading = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(
                coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: viewModel.gasStations
            ) { station in
                MapAnnotation(coordinate: station.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(station.priceSummary)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    TextField("Search for a location", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Button(action: {
                        performSearch()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 50)
                
                // Loading indicator
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding(.top, 20) 
                }
                
                Spacer()
            }
            
            .alert(isPresented: $viewModel.showLocationServicesAlert) {
                Alert(
                    title: Text("Location Services Disabled"),
                    message: Text("Please enter a city or zip code to find nearby gas stations."),
                    primaryButton: .default(Text("OK"), action: {
                        viewModel.promptForLocation()
                    }),
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $viewModel.showLocationPrompt) {
                VStack {
                    TextField("Enter city or zip code", text: $viewModel.userEnteredLocation)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        isLoading = true
                        viewModel.searchLocation {
                            isLoading = false
                        }
                        viewModel.showLocationPrompt = false
                    }) {
                        Text("Search")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
            }
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
        }
    }
    
    // Helper function to perform search and dismiss the keyboard
    private func performSearch() {
        isLoading = true
        viewModel.searchLocation {
            isLoading = false
            dismissKeyboard()
        }
    }
    
    // Function to dismiss the keyboard
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
