//
//  ContentView.swift
//  UnitConversion
//
//  Created by Bruce Gilmour on 2021-07-04.
//

import SwiftUI

struct ContentView: View {
    @State private var measurement = 0
    @State private var inputValue = ""
    @State private var inputUnit = 0
    @State private var outputUnit = 0

    let measurements = [
        Measurement(
            name: "Length",
            units: [
                Unit(name: "m"),
                Unit(name: "km",  multiplier: 1000),
                Unit(name: "ft",  multiplier: 0.3048),
                Unit(name: "yd",  multiplier: 0.9144),
                Unit(name: "ch",  multiplier: 20.117),
                Unit(name: "fur", multiplier: 201.17),
                Unit(name: "mi",  multiplier: 1609.34)
            ]
        ),
        Measurement(
            name: "Temperature",
            units: [
                Unit(name: "C"),
                Unit(name: "F", multiplier: 5 / 9, offset: 32),
                Unit(name: "K", multiplier: 1.0, offset: 273.15)
            ]
        ),
        Measurement(
            name: "Time",
            units: [
                Unit(name: "s"),
                Unit(name: "min", multiplier: 60),
                Unit(name: "h",   multiplier: 60 * 60),
                Unit(name: "d",   multiplier: 24 * 60 * 60),
                Unit(name: "wk",  multiplier: 7 * 24 * 60 * 60)
            ]
        )
    ]

    var body: some View {
        NavigationView {
            Form {
                selectMeasurement

                inputValueAndUnit

                outputValueAndUnit
            }
            .navigationBarTitle("Unit Conversion")
        }
    }

    var selectMeasurement: some View {
        Section {
            Picker("Measurement", selection: $measurement) {
                ForEach(0 ..< measurements.count) {
                    Text(measurements[$0].name)
                }
            }
            .onChange(of: measurement) { _ in
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
                ForEach(0 ..< measurements[measurement].units.count) {
                    Text(measurements[measurement].units[$0].name)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .id(measurement)
        }
    }

    var outputValueAndUnit: some View {
        Section(header: Text("To")) {
            Text("\(convertedValue, specifier: "%g")")
            Picker("Output units", selection: $outputUnit) {
                ForEach(0 ..< measurements[measurement].units.count) {
                    Text(measurements[measurement].units[$0].name)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .id(measurement)
        }
    }

    var convertedValue: Double {
        let input = Double(inputValue) ?? 0.0
        guard inputUnit < measurements[measurement].units.count else {
            return input
        }
        guard outputUnit < measurements[measurement].units.count else {
            return input
        }
        let unitIn = measurements[measurement].units[inputUnit]
        let unitOut = measurements[measurement].units[outputUnit]
        return unitIn.convert(from: input, with: unitOut)
    }
}

struct Measurement {
    var name: String
    var units: [Unit]
}

struct Unit {
    var name: String
    var multiplier: Double = 1.0
    var offset: Double = 0.0
}

extension Unit {
    func convert(from value: Double, with unit: Unit) -> Double {
        let siValue = (value - self.offset) * self.multiplier
        return (siValue / unit.multiplier) + unit.offset
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
