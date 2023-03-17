import Foundation

final class Note: Identifiable, Hashable {
	let id: Int
	var title: String
	var content: String
	let creationDate: UInt64
	let updateDate: UInt64

	init(id: Int, title: String, content: String, creationDate: UInt64, updateDate: UInt64) {
		self.id = id
		self.title = title
		self.content = content
		self.creationDate = creationDate
		self.updateDate = updateDate
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

func ==(rhs: Note, lhs: Note) -> Bool {
	return rhs.id == lhs.id
}
