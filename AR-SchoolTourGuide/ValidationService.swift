//
//  ValidationService.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 7/2/22.
//

import Foundation

struct ValidationService {
    
    func validateStartPoint(start: String?) throws->String {
        print("------------")
        print(start)
        print("------------")

        guard let start = start else {throw ValidationError.invalidValue}
        guard start != "Optional(\"Select Starting Point\")" || start != nil else { throw ValidationError.noSelection }
        return start
    }
    
    func validateDestinationPoint(dest: String?) throws->String? {
        guard let dest = dest else {throw ValidationError.invalidValue}
        guard dest != "Select Destination" else { throw ValidationError.noSelection }
        return dest
        
    }
}

enum ValidationError: LocalizedError {
    case invalidValue
    case noSelection
    
    var errorDescription: String? {
        switch self {
        case .invalidValue:
            return "You have entered an invalid value."
        case .noSelection:
            return "You did not select a location."
        }
    }
}
