//
//  AppConstants.swift
//  InterexyTest
//
//  Created by Алексей Смоляк on 14.01.23.
//

import Foundation
import DeviceKit

final class AppConstants {
    
    /*
     */
    
    static let apiKey = "d3c3437f617c8a82a58d56a75ab29833"
    
    /*
     */
    
    static var SizeFactor: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 1.3
        }
        
        return ((Device.current.diagonal == Device.iPhoneX.diagonal || Device.current.diagonal == Device.iPhoneXS.diagonal || Device.current.diagonal == Device.iPhoneXSMax.diagonal || Device.current.diagonal == Device.iPhoneXR.diagonal || Device.current.diagonal == Device.iPhone11.diagonal || Device.current.diagonal == Device.iPhone11Pro.diagonal || Device.current.diagonal == Device.iPhone11ProMax.diagonal) || Device.current.diagonal == Device.iPhoneSE2.diagonal || Device.current.diagonal == Device.iPhone12Mini.diagonal || Device.current.diagonal == Device.iPhone12.diagonal || Device.current.diagonal == Device.iPhone12Pro.diagonal || Device.current.diagonal == Device.iPhone12ProMax.diagonal || Device.current.diagonal == Device.iPhone13Mini.diagonal || Device.current.diagonal == Device.iPhone13.diagonal || Device.current.diagonal == Device.iPhone13Pro.diagonal || Device.current.diagonal == Device.iPhone13ProMax.diagonal ? UIScreen.main.bounds.width / 375 : UIScreen.main.bounds.height / 667)
    }
}
