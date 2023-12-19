//
//  Request.swift
//  Kiwi
//
//  Created by pzh on 2023/3/21.
//

import UIKit
import Alamofire

public let API = Request.req
open class Request:NSObject {
    
    public enum RequestMethod {
        case GET
        case POST
        case DELETE
        case PUT
        case PATCH
        public var method:HTTPMethod {
            switch self {
            case .GET:
                return .get
            case .POST:
                return .post
            case .DELETE:
                return .delete
            case .PUT:
                return .put
            case .PATCH:
                return .patch
            }
        }
    }
    
    public static let req:Request = Request();
    
    override init() {
        super.init();
        self.configuration();
    }
    
    //MARK: 配置信息
    func configuration()  {
        AF.session.configuration.timeoutIntervalForRequest  = Kiwi.kw.timeoutIntervalForRequest;
        AF.session.configuration.timeoutIntervalForResource = Kiwi.kw.timeoutIntervalForResource;
    }
    
    public var session:Session {
        AF
    }
    
    public func headers(_ msg:Message) -> HTTPHeaders
    {
        var headers = AF.session.configuration.headers;
        
        if let _headers = Kiwi.kw.headers, _headers.isEmpty == false {
            for header in _headers {
                headers.update(name: header.key, value: header.value)
            }
        }
        
        if let _headers = msg.headers, _headers.isEmpty == false  {
            for header in _headers {
                headers.update(name: header.key, value:header.value);
            }
        }
        
        return headers;
    }
    
    public func HTTP(method:RequestMethod = .GET, msg:Message, url:String) {

       let encoding = (Kiwi.kw as? KiwiErrorProtocol)?.kiwi(method:method) ?? URLEncoding.default
       request(method:method.method, msg: msg, url: url,encoding:encoding);
    }
    
    
    //MARK: Request
    private func request(method:HTTPMethod = .get, msg:Message, url:String, encoding:ParameterEncoding = URLEncoding.default ){
        
        AF.request(url,method: method,parameters: msg.input,encoding:encoding,headers: headers(msg)).responseDecodable { response in
            self.response(msg: msg, response: response)
        }
    }
    
    //MARK: 请求结果处理
    public func response(msg:Message, response:DataResponse<BaseRes,AFError>)
    {
        print("Kiwi:\n params:\(String(describing: msg.input)), \n path:\(Kiwi.kw.url + (msg.path ?? ""))  \n response = \(response) \n");
        
       switch response.result
        {
         case .success:
            guard let _ = response.value else
            {
                msg.onStatusChanged(.FAILURE);
                return
            }
           msg.data = response.data;
           
           if let succ = (Kiwi.kw as? KiwiErrorProtocol)?.kiwi(occurredError: msg) {
               succ == true ? msg.onStatusChanged(.FAILURE): msg.onStatusChanged(.SUCCEED);
           }else {
               msg.onStatusChanged(.SUCCEED);
           }
         case .failure:
            msg.error = response.error;
            msg.onStatusChanged(.FAILURE);
           
        }
    }
}

public struct BaseRes:Decodable {
    
}


