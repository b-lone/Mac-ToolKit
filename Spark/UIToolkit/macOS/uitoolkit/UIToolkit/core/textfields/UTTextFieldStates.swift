//
//  UTTextFieldValidationState.swift
//  UIToolkit
//
//  Created by James Nestor on 21/05/2021.
//

@objc public enum UTTextFieldValidationState: UInt{
    case noError    
    case error
}

@objc public enum UTTextFieldControlState : UInt{    
    case inactive
    case hover
    case focused
    case disabled
}
