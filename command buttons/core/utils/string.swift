//
//  string.swift
//  command buttons
//
//  Created by Luuk Meier on 24/11/2021.
//

import Foundation

extension String {

    func camelCaseToWords() -> String {

        return unicodeScalars.reduce("") {

            if CharacterSet.uppercaseLetters.contains($1) {

                return ($0 + " " + String($1))
            }
            else {

                return $0 + String($1)
            }
        }
    }
}
