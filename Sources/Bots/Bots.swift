
import Vapor

public final class Bots {
    
    let app: Application
    
    init(app: Application) {
        self.app = app
    }
    private var storage: [BotID: any ChatBot] = [:]
    
    public func use(_ bot: ChatBot, as botID: BotID) {
        storage[botID] = bot
    }
    
    @discardableResult
    public func use<B: ChatBot>(_ type: B.Type, as botID: BotID) -> B {
        let bot = B.init(app: app)
        use(bot, as: botID)
        return bot
    }
    
    public func bot<B: ChatBot>(_ id: BotID) -> B? {
        storage[id] as? B
    }
    
    struct Key: StorageKey {
        public typealias Value = Bots
    }
    
}

public protocol ChatBot {
    
    init(app: Application)
}

public struct BotID: Hashable, Codable {
    
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension Application {
    var bots: Bots {
        .init(app: self)
    }
}


