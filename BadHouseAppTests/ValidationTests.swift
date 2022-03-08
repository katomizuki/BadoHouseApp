//
//  ValidationTest.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/08.
//

@testable import BadHouseApp
import Quick
import Nimble
import ReSwift

class ValidationTest: QuickSpec {
    override func spec() {
        let badMailAddress1 = " ssss@gmail.com"
        let badMailAddress2 = "sss"
        let badMailAddress3 = ""
        let badMailAddress4 = "mizu@mizu@.com"
        let goodMailAddress = "mizumizu@gmail.com"
        
        let badPassword1 = "dffas"
        let badPassword2 = "fd dfdddd"
        let goodPassword = "badHouse1234"
        
        describe("Mail Address Login") {
            context("when enter Password") {
                it("it false") {
                    expect(self.validateMailAddress(badMailAddress1, atMarkCount: self.makeAtMarkCount(badMailAddress1))).to(equal(false))
                }
                it("it false") {
                    expect(self.validateMailAddress(badMailAddress2, atMarkCount: self.makeAtMarkCount(badMailAddress2))).to(equal(false))
                }
                it("it false") {
                    expect(self.validateMailAddress(badMailAddress3, atMarkCount: self.makeAtMarkCount(badMailAddress3))).to(equal(false))
                }
                it("it false") {
                    expect(self.validateMailAddress(badMailAddress4, atMarkCount: self.makeAtMarkCount(badMailAddress4))).to(equal(false))
                }
                it("it true") {
                    expect(self.validateMailAddress(goodMailAddress, atMarkCount: self.makeAtMarkCount(goodMailAddress))).to(equal(true))
                }
            }
        }
        
        describe("Password Login") {
            context("when enter password") {
                it("it false") {
                    expect(self.validatePassword(badPassword1)).to(equal(false))
                }
                it("it false") {
                    expect(self.validatePassword(badPassword2)).to(equal(false))
                }
                it("it true") {
                    expect(self.validatePassword(goodPassword)).to(equal(true))
                }
            }
        }
    }

    private func validateMailAddress(_ mailAddress: String, atMarkCount: Int) -> Bool {
        return mailAddress.count >= 5 && mailAddress.contains("@") && !mailAddress.contains(" ") && atMarkCount == 1
    }
    
    private func makeAtMarkCount(_ mailAddress: String) -> Int {
        return Array(mailAddress).filter { $0 == "@"}.count
    }
    
    private func validatePassword(_ password: String) -> Bool {
        return password.count >= 6 && !password.contains(" ")
    }
}
