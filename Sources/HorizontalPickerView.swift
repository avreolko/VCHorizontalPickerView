//
//  HorizontalPickerView.swift
//  VCHorizontalPickerView
//
//  Created by Valentin Cherepyanko on 01.03.2020.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public final class HorizontalPickerView: UIView {

    public var pickedIndexChangeHandler: ((Int) -> Void)?
    public var pickedValueChangeHandler: ((String) -> Void)?

    // for calculated width overriding
    public var itemWidth: CGFloat?

    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    private var longestTitle = ""
    private var items: [String] = []

    private let widthFormula: (CGFloat) -> CGFloat = { $0 * 1.2 + 20 }

    public func set(items: [String]) {
        self.longestTitle = items.sorted { $0.count > $1.count }.first ?? ""
        self.items = items
        self.pickerView.reloadAllComponents()
    }

    public func pickItem(at index: Int) {
        self.pickerView.selectRow(index, inComponent: 0, animated: false)
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        self.pickerView.frame = frame
    }
}

extension HorizontalPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - delegate methods
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.items.count
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

        let calculateMaxWidth: () -> CGFloat = {
            let label = UILabel()
            label.text = self.longestTitle
            return label.intrinsicContentSize.width
        }

        return self.itemWidth ?? self.widthFormula(calculateMaxWidth())
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: .zero)
        let angle: CGFloat = 90 * (.pi/180)
        label.transform = CGAffineTransform(rotationAngle: angle)
        label.text = self.items[row]
        label.textAlignment = .center
        return label
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickedIndexChangeHandler?(row)
        self.pickedValueChangeHandler?(self.items[row])
    }
}

private extension HorizontalPickerView {
    func setup() {
        self.addSubview(self.pickerView)

        let angle: CGFloat = -90 * (.pi/180)
        self.pickerView.transform = CGAffineTransform(rotationAngle: angle)
    }
}
