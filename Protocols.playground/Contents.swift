//: Playground - noun: a place where people can play

import UIKit

/****************/
/*   Protocol   */
/****************/

/*
 协议定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。类、结构体
 或枚举都可以采纳协议，并为协议定义的这些要求提供具体实现。某个类型能够满足某个协议的要求，就可以说
 该类型“符合”这个协议。
 除了采纳协议的类型必须实现的要求外，还可以对协议进行扩展，通过扩展来实现一部分要求或者实现一些附加
 功能，这样采纳协议的类型就能够使用这些功能。
 */


/*
 1. 协议的语法
 
 protocol SomeProtocol {
    // 这里是协议的定义部分
 }
 
 要让自定义类型采纳某个协议，在定义类型时，需要在类型名称后加上协议名称，中间以冒号( : )分隔。采纳 多个协议时，各协议之间用逗号( , )分隔:
 struct SomeStructure: FirstProtocol, AnotherProtocol { 
    // 这里是结构体的定义部分
 }
 
 拥有父类的类在采纳协议时，应该将父类名放在协议名之前，以逗号分隔:
 class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol { 
    // 这里是类的定义部分
 }
 
 */




/*
 2. 属性要求
 
 
 协议可以要求采纳协议的类型提供特定名称和类型的实例属性或类型属性。
 协议不指定属性是存储型属性还是计算型属性，它只指定属性的名称和类型。
 此外，协议还指定属性是可读的还是可读可写的。
 如果协议要求属性是可读可写的，那么该属性不能是常量属性或只读的计算型属性。
 如果协议只要求属性是可读的，那么该属性不仅可以是可读的，如果代码需要的话，还可以是可写的。
 协议总是用 var 关键字来声明变量属性，在类型声明后加上 { set get } 来表示属性是可读可写的，可读属 性则用 { get } 来表示:
 */
 protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
 }


 /*
 在协议中定义类型属性时，总是使用 static 关键字作为前缀。
 */
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}


/*
 结构体和枚举 遵循类型属性协议时，实现协议时，只能使用关键字 static
 类 遵循类型属性协议时，实现协议时，可以使用关键字 static 但不能被子类重载， 
                            也可以使用 class，可以被子类重载
 */
// 例子
protocol FullyNameType {
     static var funllyName : String { get }
}

struct PersonSturc: FullyNameType {
    static var funllyName: String = "struct only use static key"
}

enum PersonEnum: FullyNameType {
    static var funllyName: String = "struct only use static key"
}

class PersonStatic: FullyNameType {
    static var funllyName: String {
        return "static key"
    }
}

class PersonClass: FullyNameType {
    class var funllyName: String {
        return "class key"
    }
}

class PersonSubClass: PersonClass {
    override class var funllyName: String {
        return "class key"
    }
}


class PersonSubClassStatic: PersonStatic {
//    override static var funllyName: String {
//        return "static key"
//    }
}


protocol FullyName {
    var fullyName: String { get }
}
// 一个更复杂的类，尊徐FullyName协议
class Starship: FullyName {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullyName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }

}





/*
 3. 对方法的要求
 
 协议可以要求采纳协议的类型实现某些指定的实例方法或类方法。
 这些方法作为协议的一部分，像普通方法一样放在协议的定义中，但是不需要大括号和方法体。
 可以在协议中定义具有可变参数的方法，和普通方法的定义方式相同。
 但是，不支持为协议中的方法的参数提供默认值。
 
 
 正如属性要求中所述，在协议中定义类方法的时候，总是使用 static 关键字作为前缀。
 当类类型采纳协议 时，除了 static 关键字(不能重载)，还可以使用 class 关键字(可重载)作为前缀
 
 protocol SomeProtocol {
    static func someTypeMethod()
 }
 */

protocol RandomNumberGenerator {
    func random() ->Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And another one: \(generator.random())")




/*
    4 Mutating 方法要求
 
 有时需要在方法中改变方法所属的实例。例如，在值类型(即结构体和枚举)的实例方法中，将 mutating 关键 字作为方法的前缀，写在 func 关键字之前，表示可以在该方法中修改它所属的实例以及实例的任意属性的值。
 
 如果你在协议中定义了一个实例方法，该方法会改变采纳该协议的类型的实例，那么在定义协议时需要在方法前 加mutating 关键字。这使得结构体和枚举能够采纳此协议并满足此方法要求。
 
 注意
 实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写
 mutating 关键字
 */

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwith: Togglable {
    case Off, On
    
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        default:
            self = .Off
        }
    }
}

var lightSwitch = OnOffSwith.Off
lightSwitch.toggle()



/*
 5. 对构造器的要求
 
 协议可以要求采纳协议的类型实现指定的构造器。你可以像编写普通构造器那样，在协议的定义里写下构造器的声明，但不需要写花括号和构造器的实体:
 protocol SomeProtocol {
    init(someParameter: Int)
 }
 
 
 构造器要求在类中的实现
 你可以在采纳协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器。无论哪种情况，你都必须 为构造器实现标上 required 修饰符:
 class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // 这里是构造器的实现部分
    }
 }
 
 使用 required 修饰符可以确保所有子类也必须提供此构造器实现，从而也能符合协议。
 
 
 注意
 如果类已经被标记为 final ，那么不需要在协议构造器的实现中使用 required 修饰符，因为 final 类不 能有子类
 
 
 如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标 注required 和 override 修饰符:
 */

protocol SomeClassProtocol {
    init()
}
class SomeSuperClass {
    init() {
        // 这里是构造器的实现部分 
    }
}
    
class SomeSubClass: SomeSuperClass, SomeClassProtocol {
    // 因为采纳协议，需要加上 required
    // 因为继承自父类，需要加上 override
    required override init() {
            // 这里是构造器的实现部分 
    }
}

/* 可失败构造器要求
 
 采纳协议的类型可以通过可失败构造器( init? )或非可失败构造器( init )来满足协议中定义的可失败构造器要求。
 协议中定义的非可失败构造器要求可以通过非可失败构造器( init )或隐式解包可失败构造器( init! )来满足。
 
 */






/*  协议作为类型使用
 
 尽管协议本身并未实现任何功能，但是协议可以被当做一个成熟的类型来使用。
 协议可以像其他普通类型一样使用，使用场景如下:
 • 作为函数、方法或构造器中的参数类型或返回值类型 
 • 作为常量、变量或属性的类型
 • 作为数组、字典或其他容器中的元素类型
 
 
 注意
 协议是一种类型，因此协议类型的名称应与其他类型(例如 Int ， Double ， String )的写法相同，使用大写 字母开头的驼峰式写法，例如(FullyNamed 和 RandomNumberGenerator)。
 */


// 例
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}




/* 委托（代理）模式
 
 委托是一种设计模式，它允许类或结构体将一些需要它们负责的功能委托给其他类型的实例。
 委托模式的实现很简单:定义协议来封装那些需要被委托的功能，这样就能确保采纳协议的类型能提供这些功能。
 委托模式可以用来响应特定的动作，或者接收外部数据源提供的数据，而无需关心外部数据源的类型。
 
 */
protocol DiceGame {
    var dice: Dice { get }
    func play()
}


protocol DiceGameDelegate {
    func gameDidStart(game: DiceGame)
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(game: DiceGame)
}


class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    
    init() {
        board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] =  +08
        board[06] = +11
        board[09] = +09
        board[10] = +02
        board[14] = -10
        board[19] = -11
        board[22] = -02
        board[24] = -08
    }
    
    var delegate: DiceGameDelegate?
    
    func play() {
        square = 0
        delegate?.gameDidStart(game: self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(game: self, didStartNewTurnWithDiceRoll: diceRoll)
            switch  square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(game: self)
    }
    
}



class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    
    func gameDidStart(game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()




/* 通过扩展添加协议一致性
 
 即便无法修改源代码，依然可以通过扩展令已有类型采纳并符合协议。
 扩展可以为已有类型添加属性、方法、下标以及构造器，因此可以符合协议中的相应要求。
 
 注意
 通过扩展令已有类型采纳并符合协议时，该类型的所有实例也会随之获得协议中定义的各项功能。
 */
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}


/* 通过扩展采纳协议
 
 当一个类型已经符合了某个协议中的所有要求，却还没有声明采纳该协议时，可以通过空扩展体的扩展来采纳该协议:
 
 注意
 即使满足了协议的所有要求，类型也不会自动采纳协议，必须显式地采纳协议。
 */
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)


/* 协议类型的集合
 协议类型可以在数组或者字典这样的集合中使用，
 */
let things: [TextRepresentable] = [Hamster(name: "Text"), simonTheHamster]
for thing in things {
    print(thing.textualDescription)
}




/* 协议的继承
 
 协议能够继承一个或多个其他协议，可以在继承的协议的基础上增加新的要求。
 协议的继承语法与类的继承相似，多个被继承的协议间用逗号分隔:
 protocol InheritingProtocol: SomeProtocol, AnotherProtocol { 
    // 这里是协议的定义部分
 }
 
 */

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextRepresentable: String { get }
}
// 任何采纳 PrettyTextRepresentable 协议的类型在满足该协议的同时，也必须满足 TextRepresentable 协议的要求


extension SnakesAndLadders: PrettyTextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
    
    var prettyTextRepresentable: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○"
            }
        }
        return output
    }
}

print(game.prettyTextRepresentable)



/* 类类型专属协议
 
 你可以在协议的继承列表中，通过添加 class 关键字来限制协议只能被类类型采纳，而结构体或枚举不能采纳 该协议。
 class 关键字必须第一个出现在协议的继承列表中，在其他继承的协议之前:
 
 protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol { 
    // 这里是类类型专属协议的定义部分
 }
 
 协议 SomeClassOnlyProtocol 只能被类类型采纳。如果尝试让结构体或枚举类型采纳该协议，则 会导致编译错误。
 
 
 注意 当协议定义的要求需要采纳协议的类型必须是引用语义而非值语义时，应该采用类类型专属协议。
 */






/* 协议的合成
 
 有时候需要同时采纳多个协议，你可以将多个协议采用 SomeProtocol & AnotherProtocol 这样的格式进行组
 合，称为 协议合成(protocol composition)。
 
 你可以罗列任意多个你想要采纳的协议，以与符号( & )分隔。
 
 注意
 协议合成并不会生成新的、永久的协议类型，而是将多个协议中的要求合成到一个只在局部作用域有效的临时协议中。
 
 */

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

// celebrator 的类型是 Named & Aged，这意味着它不关心参数的具体类型，只要参数遵循这两个协议即可
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you are \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)



/* 检查协议的一致性
 
 你可以使用类型转换中描述的 is 和 as 操作符来检查协议一致性，即是否符合某协议，并且可以转换到指定的协议类型。
 
 检查和转换到某个协议类型在语法上和类型的检查和转换完全相同:
 • is 用来检查实例是否符合某个协议，若符合则返回 true ，否则返回 false 。
 • as? 返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回 nil 。
 • as! 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
 */

protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double {
        return pi * radius * radius
    }
    
    init(radius: Double) {
        self.radius = radius
    }
}

class Country: HasArea {
    var area: Double
    
    init(area: Double) {
        self.area = area
    }
}

class Animal {
    var legs: Int
    init(legs: Int) {
        self.legs = legs
    }
}


let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
     print("Area is \(objectWithArea.area)")
    } else {
        print("Something that does not have an area")
    }
}



/*  可选协议的要求
 
 协议可以定义可选要求，采纳协议的类型可以选择是否实现这些要求。
 在协议中使用 optional 关键字作为前缀来定义可选要求。
 使用可选要求时(例如，可选的方法或者属性)，它们的类型会自动变成可选的。
 比如，一个 类型为 (Int) ->String  的方法会变成 ((Int) ->String)? 。
 需要注意的是整个函数类型是可选的，而不是函 数的返回值。
 
 
 协议中的可选要求可通过可选链式调用来使用，因为采纳协议的类型可能没有实现这些可选要求。
 类似 someOptionalMethod?(someArgument) 这样，你可以在可选方法名称后加上 ? 来调用可选方法
 

 
 注意
 可选的协议要求只能用在标记 @objc 特性的协议中。 该特性表示协议将暴露给 Objective-C 代码.
 即使你不打算和 Objective-C 有什么交互，如果你想要指定可选的协议要求，那么还是要为协议加上 @objc 特性.
 
 还需要注意的是，标记 @objc 特性的协议只能被继承自 Objective-C 类的类或者 @objc 类采纳，其他类以及结构体和枚举均不能采纳这种协议。
 */

@objc protocol CounterDataSource {
    @objc optional func incrementForCount(count: Int) ->Int
    @objc optional var fixedIncrement: Int { get }
}

/*
 注意
 严格来讲，CounterDataSource 协议中的方法和属性都是可选的，因此采纳协议的类可以不实现这些要求，尽 管技术上允许这样做，不过最好不要这样写
 */

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    
    func incremetn() {
        if let amount = dataSource?.incrementForCount?(count: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 0...4 {
    counter.incremetn()
    print(counter.count)
}




class TowardsZeroSource: NSObject, CounterDataSource {
    
    func incrementForCount(count: Int) -> Int {
        if count == 0  {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}


counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.incremetn()
    print(counter.count)
}






/* 协议的扩展
 协议可以通过扩展来为采纳协议的类型提供属性、方法以及下标的实现。
 通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个采纳协议的类型中都重复同样的实现，也无需使用全局函数。
 
 */

extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

let generator1 = LinearCongruentialGenerator()

print("Here is a random number: \(generator1.random())")
print("And here is a random Boolean: \(generator1.randomBool())")

/*
 可以通过协议扩展来为协议要求的属性、方法以及下标提供默认的实现。
 如果采纳协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。
 
 注意
 通过协议扩展为协议要求提供的默认实现和可选的协议要求不同。
 虽然在这两种情况下，采纳协议的类型都无需自己实现这些要求，但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用。
 */

extension PrettyTextRepresentable {
    var prettyTextualDescription: String {
        return textualDescription;
    }
}


/* 为协议扩展添加限制条件
 
 在扩展协议的时候，可以指定一些限制条件，只有采纳协议的类型满足这些限制条件时，才能获得协议扩展提供 的默认实现。这些限制条件写在协议名之后，使用 where 子句来描述，
 
 
 注意
 如果多个协议扩展都为同一个协议要求提供了默认实现，而采纳协议的类型又同时满足这些协议扩展的限制条件，那么将会使用限制条件最多的那个协议扩展提供的默认实现。
 
 */

extension Collection where Iterator.Element: TextRepresentable {
    var textualDescription: String {
        let itmesAsText = self.map {$0.textualDescription}
        
        return "[" + itmesAsText.joined(separator: ",") + "]"
    }
}


let muarryTheHamster = Hamster(name: "Murray")
let morganTheHamster = Hamster(name: "Morgan")
let mauriceTheHamster = Hamster(name: "Maurice")
let hamsters = [muarryTheHamster, morganTheHamster, mauriceTheHamster]

print(hamsters.textualDescription)













