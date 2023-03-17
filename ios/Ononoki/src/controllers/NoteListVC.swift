import UIKit

final class NoteListVC: UITableViewController {
	private let cellIdentifier = "fr.whine.ononoki.cell.note"
	private var notes = [Note]()

	// MARK: - UIViewController
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

		// Add button
		let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNoteAction(_:)))
		// Settings button
		let settingsButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(showSettingsAction(_:)))
		navigationItem.rightBarButtonItem = addButton
		navigationItem.leftBarButtonItem = settingsButton
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		loadNotes()
	}

	// MARK: - Private
	private func loadNotes() {
		getNotes() { n in
			self.notes.removeAll()
			self.notes.append(contentsOf: n)
			self.updateNavigationTitle()
			self.tableView.reloadData()
		}
	}

	private func updateNavigationTitle() {
		self.navigationItem.title = "\(notes.count) note\(notes.count == 1 ? "" : "s")"
	}

	// MARK: - IBActions
	@objc private func addNoteAction(_ sender: Any) {

	}

	@objc private func showSettingsAction(_ sender: Any) {
		let settingsVC = SettingsVC()
		let nvc = UINavigationController(rootViewController: settingsVC)
		nvc.presentationController?.delegate = self
		nvc.modalTransitionStyle = .flipHorizontal
		UIApplication.shared.delegate?.window??.rootViewController?.present(nvc, animated: true, completion: nil)
	}
}

extension NoteListVC {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		cell.accessoryType = .disclosureIndicator

		let note = notes[indexPath.row]
		cell.textLabel?.text = note.title

		return cell
	}
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension NoteListVC: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
	}

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return self.modalStyleForController(controller)
	}

	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return self.modalStyleForController(controller)
	}

	private func modalStyleForController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
		guard let nvc = controller.presentedViewController as? UINavigationController else {
			return .automatic
		}
		guard let tvc = nvc.topViewController else { return .automatic }

		if tvc.isKind(of: SettingsVC.self) {
			return .fullScreen
		} else {
			return .automatic
		}
	}
}
