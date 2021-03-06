import Tailor

// MARK: - Array

public extension _ArrayType where Generator.Element == ViewModel {

  mutating func refreshIndexes() {
    enumerate().forEach {
      self[$0.index].index = $0.index
    }
  }
}

// MARK: - Dictionary

/**
 A dictinary extension to work with custom Key type
 */
extension Dictionary where Key: StringLiteralConvertible {

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A generic type if casting succeeds, otherwise it returns nil
   */
  func property<T>(name: ViewModel.Key) -> T? {
    return property(name.string)
  }

  /**
   Access the value associated with the given key.

   - Parameter key: The key associated with the value you want to get
   - Returns: The value associated with the given key
   */
  subscript(key: ViewModel.Key) -> Value? {
    set(value) {
      guard let key = key.string as? Key else { return }
      self[key] = value
    }
    get {
      guard let key = key.string as? Key else { return nil }
      return self[key]
    }
  }
}

// MARK: - Mappable

extension Mappable {

  /**
   - Returns: A key-value dictionary.
   */
  var metaProperties: [String : AnyObject] {
    var properties = [String : AnyObject]()

    for tuple in Mirror(reflecting: self).children {
      guard let key = tuple.label else { continue }

      if let value = tuple.value as? AnyObject {
        properties[key] = value
      } else if let value = Mirror(reflecting: tuple.value).descendant("Some") as? AnyObject {
        properties[key] = value
      } else {
        continue
      }
    }

    return properties
  }
}
