//
//  ContentView.swift
//  VolunteerManager
//
//  Created by NADIR ELZOUKI on 11/23/24.
//

import SwiftUI

// تعريف Struct للمتطوع
struct Volunteer {
    let name: String
    let phoneNumber: String
    let email: String
    let age: Int
}

// تعريف أخطاء رقم الجوال
enum PhoneNumberError: Error {
    case invalidLength
    case nonNumeric
}

// وظيفة للتحقق من رقم الجوال
func validatePhoneNumber(_ number: String) throws {
    guard number.count == 10 else {
        throw PhoneNumberError.invalidLength
    }
    guard number.allSatisfy({ $0.isNumber }) else {
        throw PhoneNumberError.nonNumeric
    }
}

// إضافة وصف للمتطوع باستخدام Protocol
extension Volunteer: CustomStringConvertible {
    var description: String {
        return """
        Volunteer Info:
        Name: \(name)
        Phone: \(phoneNumber)
        Email: \(email)
        Age: \(age)
        """
    }
}

// واجهة التطبيق
struct ContentView: View {
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var resultMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Volunteer Manager")
                .font(.title)
                .padding()
            
            // إدخال البيانات
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Phone Number (10 digits)", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
            
            TextField("Age", text: $age)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)
            
            // زر إضافة متطوع
            Button(action: {
                addVolunteer(name: name, phoneNumber: phoneNumber, email: email, age: age)
            }) {
                Text("Add Volunteer")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // عرض النتيجة
            Text(resultMessage)
                .foregroundColor(.red)
                .padding()
        }
        .padding()
    }
    
    // وظيفة لإضافة متطوع
    func addVolunteer(name: String, phoneNumber: String, email: String, age: String) {
        guard let ageInt = Int(age) else {
            resultMessage = "Error: Age must be a valid number."
            return
        }
        
        do {
            try validatePhoneNumber(phoneNumber)
            let newVolunteer = Volunteer(name: name, phoneNumber: phoneNumber, email: email, age: ageInt)
            resultMessage = "Volunteer added successfully!\n\(newVolunteer.description)"
        } catch PhoneNumberError.invalidLength {
            resultMessage = "Error: Phone number must be exactly 10 digits."
        } catch PhoneNumberError.nonNumeric {
            resultMessage = "Error: Phone number must contain only numbers."
        } catch {
            resultMessage = "Unknown error occurred."
        }
    }
}

// معاينة التطبيق
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
