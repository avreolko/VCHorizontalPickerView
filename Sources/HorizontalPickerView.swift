//
//  HorizontalPickerView.swift
//  EasyFit
//
//  Created by Valentin Cherepyanko on 01.03.2020.
//  Copyright © 2020 Valentin Cherepyanko. All rights reserved.
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

    private var titles: [String] = []

    private let widthFormula: (CGFloat) -> CGFloat = { $0 * 1.2 + 20 }

    public func set<T: CustomStringConvertible>(items: [T]) {
        self.titles = items.map { $0.description }
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
        return self.titles.count
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

        let maxSize = self.titles
            .map { $0.description }
            .map { (title) -> CGSize in
                let label = UILabel()
                label.text = title
                return label.intrinsicContentSize
            }
            .sorted { $0.width > $1.width }
            .first

        return self.itemWidth ?? self.widthFormula(maxSize?.width ?? 30)
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: .zero)
        let angle: CGFloat = 90 * (.pi/180)
        label.transform = CGAffineTransform(rotationAngle: angle)
        label.text = self.titles[row].description
        label.textAlignment = .center
        return label
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickedIndexChangeHandler?(row)
        self.pickedValueChangeHandler?(self.titles[row])
    }
}

private extension HorizontalPickerView {
    func setup() {
        self.addSubview(self.pickerView)

        let angle: CGFloat = -90 * (.pi/180)
        self.pickerView.transform = CGAffineTransform(rotationAngle: angle)
    }
}
