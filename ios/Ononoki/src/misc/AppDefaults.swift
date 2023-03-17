import UIKit

struct AppDefaults {
	fileprivate static var shared: UserDefaults = {
		return UserDefaults(suiteName: "group.fr.whine.ononoki.group.settings")!
	}()

	private struct Key {
		static let firstRunDate = "firstRunDate"
		static let hostname = "hostname"
		static let port = "port"
		static let username = "username"
		static let password = "password"
	}

	static let isFirstRun: Bool = {
		if AppDefaults.shared.object(forKey: Key.firstRunDate) != nil {
			return false
		}
		firstRunDate = Date()
		return true
	}()

	static var hostname: String {
		get {
			return string(for: Key.hostname)!
		}
		set {
			setString(for: Key.hostname, newValue)
		}
	}

	static var port: UInt16 {
		get {
			return UInt16(int(for: Key.port))
		}
		set {
			setInt(for: Key.port, Int(newValue))
		}
	}

	static var username: String {
		get {
			return string(for: Key.username)!
		}
		set {
			setString(for: Key.username, newValue)
		}
	}

	static var password: String {
		get {
			return string(for: Key.password)!
		}
		set {
			setString(for: Key.password, newValue)
		}
	}

	static func registerDefaults() {
		let defaultsValues: [String: Any] = [
			Key.hostname: "",
			Key.port: 9950,
			Key.username: "",
			Key.password: "",
		]

		AppDefaults.shared.register(defaults: defaultsValues)
	}
}

private extension AppDefaults {
	static var firstRunDate: Date? {
		get {
			return date(for: Key.firstRunDate)
		}
		set {
			setDate(for: Key.firstRunDate, newValue)
		}
	}

	static func bool(for key: String) -> Bool {
		return AppDefaults.shared.bool(forKey: key)
	}

	static func setBool(for key: String, _ flag: Bool) {
		AppDefaults.shared.set(flag, forKey: key)
	}

	static func cgfloat(for key: String) -> CGFloat {
		return CGFloat(AppDefaults.shared.double(forKey: key))
	}

	static func setCGFloat(for key: String, _ x: CGFloat) {
		AppDefaults.shared.set(Double(x), forKey: key)
	}

	static func data(for key: String) -> Data? {
		return AppDefaults.shared.data(forKey: key)
	}

	static func setData(for key: String, _ data: Data?) {
		AppDefaults.shared.set(data, forKey: key)
	}

	static func date(for key: String) -> Date? {
		return AppDefaults.shared.object(forKey: key) as? Date
	}

	static func setDate(for key: String, _ date: Date?) {
		AppDefaults.shared.set(date, forKey: key)
	}

	static func int(for key: String) -> Int {
		return AppDefaults.shared.integer(forKey: key)
	}

	static func setInt(for key: String, _ x: Int) {
		AppDefaults.shared.set(x, forKey: key)
	}

	static func string(for key: String) -> String? {
		return AppDefaults.shared.string(forKey: key)
	}

	static func setString(for key: String, _ value: String?) {
		AppDefaults.shared.set(value, forKey: key)
	}
}
