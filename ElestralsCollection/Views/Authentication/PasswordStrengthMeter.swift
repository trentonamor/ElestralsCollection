//
//  PasswordStrengthMeter.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/9/23.
//

import SwiftUI

struct PasswordStrengthMeter: View {
    var passwordStrength: PasswordStrength
    var foregroundColor: Color {
        switch passwordStrength {
        case .weak:
            return .red
        case .fair:
            return .orange
        case .good:
            return .blue
        case .veryStrong:
            return .green
        }
    }
    
    var strengthText: String {
        switch passwordStrength {
        case .weak:
            return "Weak"
        case .fair:
            return "Fair"
        case .good:
            return "Good"
        case .veryStrong:
            return "Very Strong"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Password Strength:")
                    .font(.headline)
                Text(strengthText)
                    .font(.headline)
                    .foregroundColor(foregroundColor)
            }
            HStack {
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(passwordStrength.rawValue >= PasswordStrength.weak.rawValue ? foregroundColor : .gray)
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(passwordStrength.rawValue >= PasswordStrength.fair.rawValue ? foregroundColor : .gray)
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(passwordStrength.rawValue >= PasswordStrength.good.rawValue ? foregroundColor : .gray)
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(passwordStrength.rawValue >= PasswordStrength.veryStrong.rawValue ? foregroundColor : .gray)
            }
            .cornerRadius(5)
        }
    }
}

struct PasswordStrengthMeter_Previews: PreviewProvider {
    static var previews: some View {
        PasswordStrengthMeter(passwordStrength: .veryStrong)
    }
}
