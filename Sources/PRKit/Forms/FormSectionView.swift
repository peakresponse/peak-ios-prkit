//
//  FormSectionVIew.swift
//  PRKit
//
//  Created by Francis Li on 11/13/26.
//

import UIKit

open class FormSectionView: UIStackView {
    open weak var formGridView: FormGridView!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        axis = .vertical
        alignment = .fill

        let formGridView = FormGridView()
        addArrangedSubview(formGridView)
        self.formGridView = formGridView
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func updateLayout() {
        formGridView.updateLayout()
    }
}
