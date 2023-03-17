import UIKit

extension UIColor {
	public convenience init(rgb: Int32, alpha: CGFloat) {
		let red = ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255
		let green = ((CGFloat)((rgb & 0x00FF00) >> 8)) / 255
		let blue = ((CGFloat)(rgb & 0x0000FF)) / 255

		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}

	public convenience init(rgb: Int32) {
		self.init(rgb: rgb, alpha: 1)
	}
}
