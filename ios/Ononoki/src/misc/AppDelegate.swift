import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	// Main window
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		AppDefaults.registerDefaults()

		UITextField.appearance().tintColor = UIColor(rgb: 0x49AFAC)
		UIBarButtonItem.appearance().tintColor = UIColor(rgb: 0x49AFAC)

		let nav = UINavigationController(rootViewController: NoteListVC())
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = nav
		window?.makeKeyAndVisible()
		return true
	}
}
