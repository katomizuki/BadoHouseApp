//
//  LoginPageObject.swift
//  BadHouseAppUITests
//
//  Created by ミズキ on 2022/03/06.
//


import XCTest

class LoginPageObject {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    var emailTextField: XCUIElement {
        return app.textFields["emailTextField"]
    }
    
    var passwordTextField: XCUIElement {
        return app.textFields["passwordTextField"]
    }
}
