//
//  Kiwi.swift
//  Kiwi
//
//  Created by pzh on 2023/3/21.
//

import UIKit

open class Kiwi {
    
    public enum KiwiEnvironment {
        case DEV       /// 测试服
        case PRE       /// 预发布
        case RELEASE   /// 正式服
    }
    
    public static let kw:Kiwi = Kiwi();
    
    //MARK: 测试环境
    public var dev_url = ""
    
    //MARK: 预发布
    public var pre_url = ""
    
    //MARK: 正式环境
    public var release_url = ""
    
    //MARK: 当前url
    var url = ""
    
    //MARK: 开发环境
    public var environment:KiwiEnvironment = .RELEASE {
        
        didSet {
            
            switch environment {
            case .DEV:
                url = dev_url
                break
            case .PRE:
                url = pre_url
                break
            case .RELEASE:
                url = release_url
                break
                
            }
            
        }
        
    }
    
    //MARK: 空响应始终有效的HTTP状态码
    public var emptyResCodes:Set<Int> = [200,204,205];
    
    //MARK: 请求超时时间
    public var timeoutIntervalForRequest:TimeInterval  = 30
    
    //MARK: 响应超时时间
    public var timeoutIntervalForResource:TimeInterval = 30

    //MARK: 公共请求头
    public var headers:[String:String]?
    
}

//MARK: 统一错误处理
public protocol KiwiErrorProtocol {
   func kiwi(occurredError msg:Message) -> Bool;
}

extension NSObject
{
    //MARK: Instance Func
    public func kiwi(performer:MessageClosure?, responser:MessageClosure? = nil, headers:[String:String]? = nil ) -> Message {
        
        let message = Message(performer, responser);
        if let _headers = headers {
            message.headers = _headers
        }
        return message;
    }
    
    //MARK: Class Func
    public static func kiwi(performer:MessageClosure?, responser:MessageClosure? = nil, headers:[String:String]? = nil ) -> Message {
        
        let message = Message(performer, responser);
        if let _headers = headers {
            message.headers = _headers
        }
        return message;
    }
    
}
