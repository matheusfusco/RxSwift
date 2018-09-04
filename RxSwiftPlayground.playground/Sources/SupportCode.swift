import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

public let episodeI = "The Phantom Menace"
public let episodeII = "Attack of the Clones"
public let theCloneWars = "The Clone Wars"
public let episodeIII = "Revenge of the Sith"
public let solo = "Solo"
public let rogueOne = "Rogue One"
public let episodeIV = "A New Hope"
public let episodeV = "The Empire Strikes Back"
public let episodeVI = "Return Of The Jedi"
public let episodeVII = "The Force Awakens"
public let episodeVIII = "The Last Jedi"
public let episodeIX = "Episode IX"

public func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
//    print(label, event.element ?? event.error ?? event)
    print(label, (event.element ?? event.error) ?? event)
}

public enum Quote: Error {
    case neverSaidThat
}

public enum MyError: Error {
    case anError
}

public let itsNotMyFault = "It’s not my fault."
public let doOrDoNot = "Do. Or do not. There is no try."
public let lackOfFaith = "I find your lack of faith disturbing."
public let eyesCanDeceive = "Your eyes can deceive you. Don’t trust them."
public let stayOnTarget = "Stay on target."
public let iAmYourFather = "Luke, I am your father"
public let useTheForce = "Use the Force, Luke."
public let theForceIsStrong = "The Force is strong with this one."
public let mayTheForceBeWithYou = "May the Force be with you."
public let mayThe4thBeWithYou = "May the 4th be with you."



public let landOfDroids = "Land of Droids"
public let wookieWorld = "Wookie World"
public let detours = "Detours"


public let mayTheOdds = "And may the odds be ever in your favor"
public let liveLongAndProsper = "Live long and prosper"
public let mayTheForce = "May the Force be with you"


public let _episodeI = (title: "The Phantom Menace", rating: 55)
public let _episodeII = (title: "Attack of the Clones", rating: 66)
public let _episodeIII = (title: "Revenge of the Sith", rating: 79)
public let _rogueOne = (title: "Rogue One", rating: 85)
public let _episodeIV = (title: "A New Hope", rating: 93)
public let _episodeV = (title: "The Empire Strikes Back", rating: 94)
public let _episodeVI = (title: "Return Of The Jedi", rating: 80)
public let _episodeVII = (title: "The Force Awakens", rating: 93)
public let _episodeVIII = (title: "The Last Jedi", rating: 91)
public let tomatometerRatings = [_episodeI, _episodeII, _episodeIII, _rogueOne, _episodeIV, _episodeV, _episodeVI, _episodeVII, _episodeVIII]

public enum Droid {
    case C3PO, R2D2
}


public let __episodeI = "Episode I - The Phantom Menace"
public let __episodeII = "Episode II - Attack of the Clones"
public let __episodeIII = "Episode III - Revenge of the Sith"
public let __episodeIV = "Episode IV - A New Hope"
public let __episodeV = "Episode V - The Empire Strikes Back"
public let __episodeVI = "Episode VI - Return Of The Jedi"
public let __episodeVII = "Episode VII - The Force Awakens"
public let __episodeVIII = "Episode VIII - The Last Jedi"
public let __episodeIX = "Episode IX"

public let episodes = [__episodeI, __episodeII, __episodeIII, __episodeIV, __episodeV, __episodeVI, __episodeVII, __episodeVIII, __episodeIX]

public extension String {
    
    /// https://stackoverflow.com/a/36949832/616764
    func romanNumeralIntValue() throws -> Int  {
        if range(of: "^(?=[MDCLXVI])M*(C[MD]|D?C{0,3})(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$", options: .regularExpression) == nil  {
            throw NSError(domain: "NotValidRomanNumber", code: -1, userInfo: nil)
        }
        
        var result = 0
        var maxValue = 0
        
        uppercased().reversed().forEach {
            let value: Int
            switch $0 {
            case "M":
                value = 1000
            case "D":
                value = 500
            case "C":
                value = 100
            case "L":
                value = 50
            case "X":
                value = 10
            case "V":
                value = 5
            case "I":
                value = 1
            default:
                value = 0
            }
            
            maxValue = max(value, maxValue)
            result += value == maxValue ? value : -value
        }
        
        return result
    }
}

public struct Jedi {
    
    public var rank: BehaviorSubject<JediRank>
    
    public init(rank: BehaviorSubject<JediRank>) {
        self.rank = rank
    }
}

public enum JediRank: String {
    
    case youngling = "Youngling"
    case padawan = "Padawan"
    case jediKnight = "Jedi Knight"
    case jediMaster = "Jedi Master"
    case jediGrandMaster = "Jedi Grand Master"
}


public let luke = "Luke Skywalker"
public let hanSolo = "Han Solo"
public let leia = "Princess Leia"
public let chewbacca = "Chewbacca"

public let lightsaber = "Lightsaber"
public let dl44 = "DL-44 Blaster"
public let defender = "Defender Sporting Blaster"
public let bowcaster = "Bowcaster"

let formatter = DateComponentsFormatter()

public func stringFrom(_ minutes: Int) -> String {
    let interval = TimeInterval(minutes)
    return formatter.string(from: interval) ?? ""
}

public let runtimes = [
    __episodeI: 136,
    __episodeII: 142,
    theCloneWars: 98,
    __episodeIII: 140,
    solo: 142,
    rogueOne: 142,
    __episodeIV: 121,
    __episodeV: 124,
    __episodeVI: 134,
    __episodeVII: 136,
    __episodeVIII: 152
]
