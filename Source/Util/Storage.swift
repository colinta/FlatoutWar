////
///  Storage.swift
//

struct Storage<T> {
    typealias Getter = (UserDefaults) -> T?
    typealias Setter = (UserDefaults, T) -> Void
    let getter: Getter
    let setter: Setter

    init(get getter: @escaping Getter, set setter: @escaping Setter) {
        self.getter = getter
        self.setter = setter
    }

    func get() -> T? {
        return getter(UserDefaults.standard)
    }

    func set(_ value: T) {
        setter(UserDefaults.standard, value)
    }
}
