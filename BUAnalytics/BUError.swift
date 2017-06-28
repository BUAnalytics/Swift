//
//  BUError.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Foundation

public enum BUError: Int{
    
    //! Core
    case Unknown = 100
    case Server = 200
    case NotFound = 300
    case Connection = 400
    case Json = 500
    
    //! Users
    case USR_Invalid = 2000
    case USR_NotFound = 2001
    case USR_Disabled = 2002
    case USR_Access = 2003
    
    case USR_InvalidLogin = 2100
    case USR_InvalidUsername = 2101
    case USR_InvalidEmail = 2102
    case USR_InvalidPassword = 2103
    case USR_InvalidAdmin = 2104
    case USR_InvalidStatus = 2105
    case USR_InvalidProjects = 2106
    case USR_InvalidProject = 2107
    
    case USR_IncorrectLogin = 2200
    
    case USR_ExistingUsername = 2300
    case USR_ExistingEmail = 2301
    
    //! Sessions
    case SES_Invalid = 3000
    case SES_Incorrect = 3001
    case SES_Disabled = 3002
    
    //! Projects
    case PRJ_Invalid = 41000
    case PRJ_NotFound = 41001
    case PRJ_Incorrect = 41002
    case PRJ_Access = 41003
    
    case PRJ_InvalidName = 41100
    case PRJ_InvalidVisible = 41101
    case PRJ_InvalidSubtitle = 41102
    case PRJ_InvalidDescription = 41103
    case PRJ_InvalidBody = 41104
    case PRJ_InvalidIcon = 41105
    case PRJ_InvalidImage = 41106
    
    //! Access Keys
    case PRJ_ACK_Invalid = 42000
    case PRJ_ACK_NotFound = 42001
    case PRJ_ACK_Incorrect = 42002
    
    case PRJ_ACK_InvalidName = 42100
    case PRJ_ACK_InvalidStatus = 42101
    
    //! Collections
    case PRJ_COL_Invalid = 43000
    case PRJ_COL_NotFound = 43001
    case PRJ_COL_Access = 43002
    
    case PRJ_COL_InvalidName = 43100
    case PRJ_COL_InvalidBody = 43101
}
