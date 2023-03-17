import Foundation
import Alamofire

fileprivate func getUrl() -> String? {
	return "\(AppDefaults.hostname):\(AppDefaults.port)"
}

func getNotes(callback: @escaping (([Note]) -> Void)) {
	guard let url = getUrl() else {
		DispatchQueue.main.async {
			callback([])
		}
		return
	}

	AF.request("\(url)/api/notes", method: .get).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
		//debugPrint(response.value)
		let itemObject = response.value as? [[String : Any]]
		var notes = [Note]()
		guard let x = itemObject else {
			DispatchQueue.main.async {
				callback(notes)
			}
			return
		}
		for d in x {
			let note = Note(id: d["id"] as! Int, title: d["title"] as! String, content: d["content"] as! String, creationDate: d["creation_date"] as! UInt64, updateDate: d["update_date"] as! UInt64)
			notes.append(note)
		}
		DispatchQueue.main.async {
			callback(notes)
		}
	}
}

func deleteNote(note: Note, callback: @escaping (() -> Void)) {
	guard let url = getUrl() else {
		return
	}

	AF.request("\(url)/api/notes/delete/\(note.id)", method: .delete).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
		if response.response?.statusCode == 200 {
			DispatchQueue.main.async {
				callback()
			}
		}
	}
}
