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
    @State var index: Int = 0
    
    @State var userIsSubscribed: Bool = false
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
                        if !self.userIsSubscribed {
                            VStack(spacing: 8) {
                                
                                StoreSelectionCell(cellTitle: "Monthly Plan", cost: 3.99, isSelected: didSelectMonth)
                                    .onTapGesture {
                                        self.didSelectMonth = true
                                        self.didSelectYear = false
                                        self.didSelectLife = false
                                        self.index = 0
                                    }
                                    .padding(.horizontal, 8)
                                StoreSelectionCell(cellTitle: "Annual Plan", cost: 34.99, isSelected: didSelectYear)
                                    .padding(.horizontal, 8)
                                    .onTapGesture {
                                        self.didSelectMonth = false
                                        self.didSelectYear = true
                                        self.didSelectLife = false
                                        self.index = 1
                                    }
                                StoreSelectionCell(cellTitle: "Lifetime Plan", cost: 109.99, isSelected: didSelectLife)
                                    .padding(.horizontal, 8)
                                    .onTapGesture {
                                        self.didSelectMonth = false
                                        self.didSelectYear = false
                                        self.didSelectLife = true
                                        self.index = 2
                                    }
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
                            FeatureCell(imageName: "bookmark", imageColor: Color(.dynamicPurple), featureTitle: "Unlimited Bookmark Folders", featureDescription: "Break free from limitations and unleash your creativity with unlimited folder creation in Caster Compendium! Perfect for avid players looking to craft and organize countless decks with ease.")
                            FeatureCell(imageName: "paintbrush", imageColor: Color(.dynamicLime), featureTitle: "App Icon Customization", featureDescription: "Unleash your personal style with Caster Compendium's customizable icons! Dive into a diverse selection and make the app truly yours.")
                            FeatureCell(imageName: "doc.text", imageColor: Color(.dynamicOrange), featureTitle: "Ascend into the Real World", featureDescription: "Unleash the full potential of your decks beyond Caster Compendium. Seamlessly export them in JSON format and integrate them anywhere you desire!")
                            FeatureCell(imageName: "atom", imageColor: Color(.dynamicRed), featureTitle: "Experimental Features", featureDescription: "Unlock exclusive early access with Caster Compendium! By joining, you secure a front-row seat to our future enhancements. Await the release of innovative features like Dark Mode, Push Notifications, CSV Exports, Intelligent Bookmarking, and many others. It's a promise of what's to come, all for our dedicated members!")
                            if self.userIsSubscribed {
                                LineSeparator()
                                    .padding(.top)
                                Button(action: {
                                    self.restorePurchases()
                                }, label: {
                                    Text("Restore Purchases")
                                })
                            }
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
                if !self.userIsSubscribed {
                    VStack {
                        Button(action: {
                            self.purchase()
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
        .onAppear {
            //self.fetchOfferings()
            self.getUserSubscriptionState()
        }
    }
}

#Preview {
    UpsellView()
}
