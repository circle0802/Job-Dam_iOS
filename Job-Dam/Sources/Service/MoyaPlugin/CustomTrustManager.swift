import Foundation
import Alamofire

class CustomServerTrustManager : ServerTrustManager {
    override func serverTrustEvaluator(forHost host: String) throws -> (any ServerTrustEvaluating)? {
        return DisabledTrustEvaluator()
    }
    
    public init() {
        super.init(evaluators: [:])
    }
}
