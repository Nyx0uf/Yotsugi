import UIKit

private let headerSectionHeight: CGFloat = 32

final class SettingsVC: UITableViewController {
	// MARK: - Private properties
	// MPD Server name
	private var tfHostname: UITextField!
	// MPD Server hostname
	private var tfPort: UITextField!
	// WEB Server hostname
	private var tfUsername: UITextField!
	// WEB Server port
	private var tfPassword: UITextField!
	// Indicate that the keyboard is visible, flag
	private var keyboardVisible = false

	// MARK: - Initializers
	init() {
		super.init(style: .insetGrouped)
	}

	required init?(coder aDecoder: NSCoder) { fatalError("no coder") }

	// MARK: - UIViewController
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Settings"

		let closeButton = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(closeAction(_:)))
		navigationItem.leftBarButtonItem = closeButton

		tfHostname = UITextField()
		tfHostname.translatesAutoresizingMaskIntoConstraints = false
		tfHostname.textAlignment = .left
		tfHostname.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		tfHostname.placeholder = "hostname.tld"

		tfPort = UITextField()
		tfPort.translatesAutoresizingMaskIntoConstraints = false
		tfPort.textAlignment = .left
		tfPort.text = "9950"
		tfPort.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		tfPort.keyboardType = .decimalPad

		tfUsername = UITextField()
		tfUsername.translatesAutoresizingMaskIntoConstraints = false
		tfUsername.textAlignment = .right
		tfUsername.autocapitalizationType = .none
		tfUsername.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

		tfPassword = UITextField()
		tfPassword.translatesAutoresizingMaskIntoConstraints = false
		tfPassword.textAlignment = .right
		tfPassword.isSecureTextEntry = true
		tfPassword.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

		tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

		// Keyboard appearance notifications
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateFields()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if isMovingFromParent {
			registerSettings()
		}
	}

	// MARK: - Buttons actions
	@objc private func closeAction(_ sender: Any?) {
		view.endEditing(true)

		registerSettings()
		
		dismiss(animated: true, completion: nil)

		// lol ugly: force UIPresentationController delegate call, forgot why.
		if let p = navigationController?.presentationController {
			p.delegate?.presentationControllerDidDismiss?(p)
		}
	}

	// MARK: - Notifications
	@objc private func keyboardDidShowNotification(_ aNotification: Notification) {
		if keyboardVisible {
			return
		}

		guard let info = aNotification.userInfo else {
			return
		}

		guard let value = info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue? else {
			return
		}

		let keyboardFrame = view.convert(value.cgRectValue, from: nil)
		tableView.frame = CGRect(tableView.frame.origin, tableView.frame.width, tableView.frame.height - keyboardFrame.height)
		keyboardVisible = true
	}

	@objc private func keyboardDidHideNotification(_ aNotification: Notification) {
		if keyboardVisible == false {
			return
		}

		guard let info = aNotification.userInfo else {
			return
		}

		guard let value = info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue? else {
			return
		}

		let keyboardFrame = view.convert(value.cgRectValue, from: nil)
		tableView.frame = CGRect(tableView.frame.origin, tableView.frame.width, tableView.frame.height + keyboardFrame.height)
		keyboardVisible = false
	}

	// MARK: - Private
	private func registerSettings() {
		// port
		var port = UInt16(9950)
		if let strPort = tfPort.text, let uiport = UInt16(strPort) {
			port = uiport
		}

		// hostname
		let hostname = sanitizeHostname(hostname: tfHostname.text ?? "", port: port)

		// username (optional)
		var username = ""
		if let strUsername = tfUsername.text, strUsername.count > 0 {
			username = strUsername
		}

		// password (optional)
		var password = ""
		if let strPassword = tfPassword.text, strPassword.count > 0 {
			password = strPassword
		}

		AppDefaults.hostname = hostname
		AppDefaults.port = port
		AppDefaults.username = username
		AppDefaults.password = password
	}

	private func sanitizeHostname(hostname: String, port: UInt16) -> String {
		// Ensure http/https suffix
		var validHostname: String
		if hostname.hasPrefix("http://") || hostname.hasPrefix("https://") {
			validHostname = hostname
		} else {
			if port == 443 || port == 8443 {
				validHostname = "https://" + hostname
			} else {
				validHostname = "http://" + hostname
			}
		}

		// Strip trailling slash
		if let last = validHostname.last, last == "/" {
			validHostname.removeLast()
		}

		return validHostname
	}

	private func updateFields() {
		tfHostname.text = AppDefaults.hostname
		tfPort.text = String(AppDefaults.port)
		tfUsername.text = AppDefaults.username
		tfPassword.text = AppDefaults.password
	}
}

// MARK: - UITableViewDataSource
extension SettingsVC {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0:
				return 2
			case 1:
				return 2
			default:
				return 0
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "\(indexPath.section):\(indexPath.row)"
		var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)

			if indexPath.section == 0 {
				if indexPath.row == 0 {
					cell?.textLabel?.text = "Hostname"
					cell?.selectionStyle = .none
					cell?.addSubview(tfHostname)
					tfHostname.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
				} else if indexPath.row == 1 {
					cell?.textLabel?.text = "Port"
					cell?.selectionStyle = .none
					cell?.addSubview(tfPort)
					tfPort.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
				}
			} else {
				if indexPath.row == 0 {
					cell?.textLabel?.text = "Username"
					cell?.selectionStyle = .none
					cell?.addSubview(tfUsername)
					tfUsername.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
				} else if indexPath.row == 1 {
					cell?.textLabel?.text = "Password"
					cell?.selectionStyle = .none
					cell?.addSubview(tfPassword)
					tfPassword.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
				}
			}
		}

		cell?.backgroundColor = .secondarySystemGroupedBackground
		cell?.textLabel?.textColor = .secondaryLabel

		if indexPath.section == 0 {
			if indexPath.row == 0 {
				tfHostname.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
			} else if indexPath.row == 1 {
				tfPort.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
			}
		} else {
			if indexPath.row == 0 {
				tfUsername.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
			} else if indexPath.row == 1 {
				tfPassword.frame = CGRect(UIScreen.main.bounds.width - 144 - 16, 0, 144, 44)
			}
		}

		return cell!
	}
}

// MARK: - UITableViewDelegate
extension SettingsVC {
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "SERVER"
		} else if section == 1 {
			return "HTTP BASIC AUTH (OPTIONAL)"
		} else {
			return ""
		}
	}
}

// MARK: - UITextFieldDelegate
extension SettingsVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField === tfHostname {
			tfPort.becomeFirstResponder()
		} else if textField === tfPort {
			tfUsername.becomeFirstResponder()
		} else if textField === tfUsername {
			tfPassword.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		return true
	}
}
