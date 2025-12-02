
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                HStack {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                    
                    Spacer()
                    
                    Image(systemName: "person.crop.circle")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.gray)
                    
                    Button("Edit Profile") { }
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text("Jack Nguyen")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("hn365@cornell.edu")
                        .foregroundColor(.black)
                    
                    Text("123-456-7890")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 4)
                
                HStack {
                    Text("My Schedule")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(spacing: 40) {
                    Text("S"); Text("M"); Text("T"); Text("W"); Text("R"); Text("F"); Text("S")
                }
                .font(.headline)
                .padding(.top, 5)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                        )
                        .frame(height: 250)
                    
                    Text("You have no classes added")
                        .foregroundColor(Color.white)
                }
                .padding(.horizontal)
                
                NavigationLink {
                    ClassSearchView()
                } label: {
                    Text("Add Classes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                

                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
