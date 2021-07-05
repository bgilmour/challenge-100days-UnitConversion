//
//  ContentView.swift
//  UnitConversion
//
//  Created by Bruce Gilmour on 2021-07-04.
//

import SwiftUI

struct ContentView: View {
    @State private var conversionType = 0
    @State private var inputValue = ""
    @State private var inputUnit = 0
    @State private var outputUnit = 0

    let conversionTypes = [
        ConversionType(
            name: "Length",
            units: [
                Unit(name: "meter"),
                Unit(name: "kilometer", multiplier: 1000),
                Unit(name: "foot", multiplier: 0.3048),
                Unit(name: "yard", multiplier: 0.9144),
                Unit(name: "mile", multiplier: 1609.34)
            ]
        ),
        ConversionType(
            name: "Temperature",
            units: [
                Unit(name: "Celsius"),
                Unit(name: "Fahrenheit", multiplier: 5 / 9, offset: 32),
                Unit(name: "Kelvin", multiplier: 1.0, offset: 273.15)
            ]
        ),
        ConversionType(
            name: "Time",
            units: [
                Unit(name: "second"),
                Unit(name: "minute", multiplier: 60),
                Unit(name: "hour", multiplier: 60 * 60),
                Unit(name: "day", multiplier: 24 * 60 * 60),
                Unit(name: "week", multiplier: 7 * 24 * 60 * 60)
            ]
        )
    ]

    var body: some View {
        NavigationView {
            Form {
                selectConversionType

                inputValueAndUnit

                outputValueAndUnit
            }
            .navigationBarTitle("Unit Conversion")
        }
    }

    var selectConversionType: some View {
        Section {
            Picker("Conversion type", selection: $conversionType) {
                ForEach(0 ..< conversionTypes.count) {
                    Text(conversionTypes[$0].name)
                }
            }
            .onChange(of: conversionType) { _ in
                inputUnit = 0
                outputUnit = 0
            }
        }
    }

    var inputValueAndUnit: some View {
        Section(header: Text("From")) {
            TextField("Enter value", text: $inputValue)
                .keyboardType(.decimalPad)
            Picker("Input units", selection: $inputUnit) {
                ForEach(0 ..< conversionTypes[conversionType].units.count) {
                    Text(conversionTypes[conversionType].units[$0].name)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .id(conversionType)
        }
    }

    var outputValueAndUnit: some View {
        Section(header: Text("To")) {
            Text("\(convertedValue, specifier: "%5g")")
            Picker("Output units", selection: $outputUnit) {
                ForEach(0 ..< conversionTypes[conversionType].units.count) {
                    Text(conversionTypes[conversionType].units[$0].name)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .id(conversionType)
        }
    }

    var convertedValue: Double {
        let input = Double(inputValue) ?? 0.0
        guard inputUnit < conversionTypes[conversionType].units.count else {
            return input
        }
        guard outputUnit < conversionTypes[conversionType].units.count else {
            return input
        }
        let unitIn = conversionTypes[conversionType].units[inputUnit]
        let unitOut = conversionTypes[conversionType].units[outputUnit]
        let siValue = (input - unitIn.offset) * unitIn.multiplier
        return (siValue / unitOut.multiplier) + unitOut.offset
    }
}

struct ConversionType {
    var name: String
    var units: [Unit]
}

struct Unit {
    var name: String
    var multiplier: Double = 1.0
    var offset: Double = 0.0
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
