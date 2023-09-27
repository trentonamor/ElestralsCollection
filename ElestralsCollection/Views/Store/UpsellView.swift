//
//  UpsellView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/27/23.
//

import SwiftUI

struct UpsellView: View {
    @State var didSelectMonth: Bool = true
    @State var didSelectYear: Bool = false
    @State var didSelectLife: Bool = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack {
                        Text("Caster Pro")
                            .foregroundStyle(.white)
                            .font(.system(size: 72))
                            .bold()
                            .italic()
                            .padding()
                        VStack(spacing: 8) {
                            StoreSelectionCell(cellTitle: "Monthly Plan", cost: 3.99, isSelected: didSelectMonth)
                                .onTapGesture {
                                    self.didSelectMonth = true
                                    self.didSelectYear = false
                                    self.didSelectLife = false
                                }
                                .padding(.horizontal, 8)
                            StoreSelectionCell(cellTitle: "Annual Plan", cost: 34.99, isSelected: didSelectYear)
                                .padding(.horizontal, 8)
                                .onTapGesture {
                                    self.didSelectMonth = false
                                    self.didSelectYear = true
                                    self.didSelectLife = false
                                }
                            StoreSelectionCell(cellTitle: "Lifetime Plan", cost: 109.99, isSelected: didSelectLife)
                                .padding(.horizontal, 8)
                                .onTapGesture {
                                    self.didSelectMonth = false
                                    self.didSelectYear = false
                                    self.didSelectLife = true
                                }
                        }
                        VStack {
                            Text("Caster Pro Includes:")
                                .foregroundStyle(.white)
                            if self.didSelectYear {
                                FeatureCell(imageName: "tag.slash", imageColor: Color(.dynamicPink), featureTitle: "Discounted Price", featureDescription: "Selecting the annual plan saves 26% off of the monthly subscription!")
                            } else if self.didSelectLife {
                                FeatureCell(imageName: "tag.slash", imageColor: Color(.dynamicPink), featureTitle: "Discounted Price", featureDescription: "Selecting the lifetime plan pays for itself in just over 3 years! (3.14 years to be exact - we did the math 😏)")
                            }
                            FeatureCell(imageName: "bookmark", imageColor: Color(.dynamicPurple), featureTitle: "Unlimited Bookmark Folders", featureDescription: "Instead of being limited to only 2 folders, you will be able to create as many folders as you want - Great for players wanting to build many decks!")
                            FeatureCell(imageName: "paintbrush", imageColor: Color(.dynamicLime), featureTitle: "App Icon Customization", featureDescription: "Customize Caster Compendium's to best suit your liking! Choose from an array of icons.")
                            FeatureCell(imageName: "doc.text", imageColor: Color(.dynamicOrange), featureTitle: "Ascend into the Real World", featureDescription: "You're no longer bound within the limits of Caster Compendium. Export your decks as JSON and use them wherever you see fit!")
                            FeatureCell(imageName: "atom", imageColor: Color(.dynamicRed), featureTitle: "Experimental Features", featureDescription: "Be the first to experience all the new features of Caster Compendium when they release. Some features to come include: Dark Mode, Push Notifications, Export to CSV, Smart Bookmark Creation, and more!")
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.vertical, 0)
                }
                .padding(.vertical, 0)
                .background(content: {
                    ZStack {
                        // Solid color background
                        Color(.dynamicNavy).edgesIgnoringSafeArea(.all)
                        
                        // Image with gradient mask
                        Image("WaterBackground")
                            .resizable()
                            .mask(
                                LinearGradient(gradient: Gradient(colors: [Color.white, Color.clear]),
                                               startPoint: .top,
                                               endPoint: .center)
                            )
                    }
                    .edgesIgnoringSafeArea(.all)
                    .padding(.vertical, 0)
                })
                
                VStack {
                    Button(action: {
                        print("Going to Store")
                    }, label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                }
                .padding(.vertical, 0)
                .background(Color(.dynamicNavy))
            }
        }
    }
}

#Preview {
    UpsellView()
}
