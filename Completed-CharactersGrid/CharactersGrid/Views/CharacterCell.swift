//
//  CharacterCell.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import UIKit
import SwiftUI

class CharacterCell: UICollectionViewCell {
    
    private var imageView = RoundedImageView()
    private var textLabel = UILabel()
    private var vStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        let padding: CGFloat = 8
        let noOfItems = traitCollection.horizontalSizeClass == .compact ? 4 : 8
        let itemWidth = floor((UIScreen.main.bounds.width - (padding * 2)) / CGFloat(noOfItems))
        
        return super.systemLayoutSizeFitting(.init(width: itemWidth, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func setup(character: Character) {
        textLabel.text = character.name
        imageView.image = UIImage(named: character.imageName)
    }
    
    private func setupLayout() {
        imageView.contentMode = .scaleAspectFit
        
        textLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.textAlignment = .center
        
        let padding: CGFloat = 8
        
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = padding
        vStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(textLabel)
        
        let imageHeightAnchor = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        imageHeightAnchor.priority = .init(999)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            imageView.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            imageHeightAnchor
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported, please register class")
    }
    
}

struct CharacterCellRepresentable: UIViewRepresentable {
    
    let character: Character
    
    func updateUIView(_ uiView: CharacterCell, context: Context) {}
    
    func makeUIView(context: Context) -> CharacterCell {
        let cell = CharacterCell()
        cell.setup(character: character)
        return cell
    }
}

fileprivate class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = max(bounds.width, bounds.height) / 2
    }
}

struct CharacterCell_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CharacterCellRepresentable(character: Universe.ff7r.stubs[0])
                .frame(width: 120, height: 150)
            
            
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [.init(.flexible()), .init(.flexible()), .init(.flexible())]) {
                        ForEach(Universe.ff7r.stubs) { character in
                            CharacterCellRepresentable(character: character)
                                .frame(width: 120, height: 150)
                        }
                    }
                    .navigationTitle(Universe.ff7r.title)
                }
                
            }
            
        }
        
        
    }
}
