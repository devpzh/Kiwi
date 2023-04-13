//
//  ViewController.swift
//  Kiwi
//
//  Created by pzh on 2021/12/30.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Kiwi.kw.dev_url = "https://app.51aidong.com/"
        Kiwi.kw.environment = .DEV
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //MARK: 方式1 不处理请求结果
        //kiwi(performer: TestController.test(msg:)).send()
        
        //MARK: 方式2 处理请求结果
//        kiwi(performer: TestController.test(msg:)) { msg in
//
//            switch msg.status! {
//
//            case .SENDING:
//                break
//
//            case .SUCCEED:
//                break
//
//            case .CANCEL:
//                break
//
//            case .FAILURE:
//                break
//
//            }
//
//        }.send()
        
        //MARK: 方式3
        kiwi(performer: TestController.test(msg:),responser: testResponser(msg:)).send()
    }

    //MARK: 请求结果
    func testResponser(msg:Message) {
        
        switch msg.status! {
            
        case .SENDING:
            break
        
        case .SUCCEED:
            break
            
        case .CANCEL:
            break
            
        case .FAILURE:
            break
            
        }
    }
    
}

class TestController: Controller {
    
    static func test(msg:Message) {
        
        switch msg.status! {
        case .SENDING:
            HTTP(msg, "shuhua/hardwares/0")
            break
        case .SUCCEED:
            break
        case .CANCEL:
            break
        case .FAILURE:
            break
        }
        
    }

}

extension Kiwi:KiwiErrorProtocol {
    
    public func kiwi(occurredError msg: Message) -> Bool {
        
        if let model = msg.map(Model.self) as? Model {
           print("model:\(model.status)")
        }
        return false
    }
    
}

class Model:Decodable {
    let status:Int?
//    let data:SubModel?
}

class SubModel:Model {
    
}
