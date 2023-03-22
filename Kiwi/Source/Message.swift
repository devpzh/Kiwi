//
//  Message.swift
//  Kiwi
//
//  Created by pzh on 2023/3/22.
//

import UIKit

public typealias MessageClosure = (Message)->();

//MARK: output 通用key
public let kMsgOutPutKey = "kMsgOutPutKey"

open class Message {
    
    public enum MessageStatus {
        case SENDING  ///发送中
        case SUCCEED  ///成功
        case CANCEL   ///取消
        case FAILURE  ///失败
    }
    
    
    //MARK: 请求结果
    public var output:[String:Any] =
    {
        let output = [String:Any]();
        return output;
    }()
    
    
    //MARK: 请求参数
    public var input:[String:Any]?
    
    //MARK: 请求头
    public var headers:[String:String]?
    
    //MARK: 图片参数
    public var images:[UIImage]?
    
    //MARK: 路径
    public var path:String?
    
    //MARK: 请求状态
    public var status:MessageStatus?
    
    //MARK: data
    public var data:Data?
    
    //MARK: error
    public var error:Error?
    
    //MARK: performer
    public var performer:MessageClosure?
    
    //MARK: responser
    public var responser:MessageClosure?
    
    //MARK: init
    public init(_ performer:MessageClosure?, _ responser:MessageClosure?)
    {
        self.performer  = performer;
        self.responser  = responser;
    }
    
    
    @discardableResult
    public func send(params:[String:Any]? = nil, images:[UIImage]? = nil)-> Self
    {
        if params?.isEmpty  == false{
            input = params;
        }
        
        if images?.isEmpty == false {
            self.images = images
        }
    
        onStatusChanged(.SENDING);
        return self
    }
    
    public func onStatusChanged(_ status:MessageStatus)
    {
        if self.status == status {
            return;
        }
        self.status = status;
        self.performer?(self);
        self.responser?(self);
        
        if self.status == .FAILURE {
           _ = (Kiwi.kw as? KiwiErrorProtocol)?.kiwi(occurredError: self)
        }
        
    }
    
    deinit {
        print("message deinit");
    }

}


extension Message {
    
    ///Decodable
    public func map(_ type:Decodable.Type) -> Decodable? {
        
        guard let _data = data else { return nil }
        
        do {
            let model =  try JSONDecoder().decode(type, from: _data);
            return model
        } catch DecodingError.dataCorrupted(let context) {
            print("Kiwi: decode error: \(context)")
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Kiwi: decode error: key'\(key)' not found:", context.debugDescription)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Kiwi: decode error: value '\(value)' not found:", context.debugDescription)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Kiwi: decode error: type '\(type)' miss match:", context.debugDescription)
        } catch {
            print("error: ", error)
        }
        return nil
    }
    
}

extension Data {
    
   public var json:String? {
        return String(data: self, encoding: .utf8)
    }
    
   public var response:[String:Any]? {
        
        let dict = try? JSONSerialization.jsonObject(with: self,options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return dict as? [String:Any]
    }
    
}

