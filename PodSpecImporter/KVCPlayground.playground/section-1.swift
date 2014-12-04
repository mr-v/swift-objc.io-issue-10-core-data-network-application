
let pods = [["name": "huhu"], ["name": "best pod ever"],["name": "podditypodddat"]]

let names = pods.map { $0["name"] }
names

import CoreData
class Pod: NSManagedObject {

}

let text: String = NSStringFromClass(Pod)
text
