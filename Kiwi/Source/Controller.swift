//
//  Controller.swift
//  Kiwi
//
//  Created by pzh on 2023/3/22.
//

import UIKit

open class Controller {
    
    public static func HTTP(method:Request.RequestMethod = .GET, _ msg:Message, _ url:String)
    {
        msg.path = url;
        API.HTTP(method:method, msg: msg, url:url);
    }

}
