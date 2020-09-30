//
//  HeaderView.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import UIKit
import SwiftUI

class HeaderView: UICollectionReusableView {
    
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    private func setupLayout() {
        textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        
        let padding: CGFloat = 16
        let labelBottomAnchor = textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        labelBottomAnchor.priority = .init(999)
        
        let labelTrailingAnchor = textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        labelTrailingAnchor.priority = .init(999)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            labelBottomAnchor,
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            labelTrailingAnchor
        ])
    }
    
    func configure(text: String) {
        textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported, please register class")
    }
    
}

struct HeaderViewRepresentable: UIViewRepresentable {
    
    let title: String
    
    func updateUIView(_ uiView: HeaderView, context: Context) {}
    
    func makeUIView(context: Context) -> HeaderView {
        let headerView = HeaderView()
        headerView.configure(text: title)
        return headerView
    }
    
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderViewRepresentable(title: "Heroes")
    }
}
