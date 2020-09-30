//
//  MultipleSectionCharactersViewController.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import UIKit
import SwiftUI

class MultipleSectionCharactersViewController: UIViewController {
    
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let segmentedControl = UISegmentedControl(
        items: Universe.allCases.map { $0.title }
    )
    
    private var sectionedCharactes = Universe.ff7r.sectionedStubs {
        didSet {
            updateCollectionView(oldSectionItems: oldValue, newSectionItems: sectionedCharactes)
        }
    }
    
    private func updateCollectionView(oldSectionItems: [SectionCharacters], newSectionItems: [SectionCharacters]) {
        var sectionsToInsert = IndexSet()
        var sectionsToRemove = IndexSet()
        var indexPathsToRemove = [IndexPath]()
        var indexPathsToInsert = [IndexPath]()
        
        let sectionDiff = newSectionItems.difference(from: oldSectionItems)
        sectionDiff.forEach { (change) in
            switch change {
            case let .remove(offset, _, _):
                sectionsToRemove.insert(offset)
            case let .insert(offset, _, _):
                sectionsToInsert.insert(offset)
            }
        }
        
        (0..<newSectionItems.count).forEach { (index) in
            let newSection = newSectionItems[index]
            if let oldSectionIndex = oldSectionItems.firstIndex(where: { $0 == newSection }) {
                let oldSection = oldSectionItems[oldSectionIndex]
                let diff = newSection.characters.difference(from: oldSection.characters)
                diff.forEach { (change) in
                    switch change {
                    case let .remove(offset, _, _):
                        indexPathsToRemove.append(IndexPath(item: offset, section: oldSectionIndex))
                    case let .insert(offset, _, _):
                        indexPathsToInsert.append(IndexPath(item: offset, section: index))
                    }
                }
            }
        }
        
        collectionView.performBatchUpdates {
            self.collectionView.deleteSections(sectionsToRemove)
            self.collectionView.deleteItems(at: indexPathsToRemove)
            self.collectionView.insertSections(sectionsToInsert)
            self.collectionView.insertItems(at: indexPathsToInsert)
        } completion: { (_) in
            let headerIndexPaths = self.collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
            headerIndexPaths.forEach { (indexPath) in
                let headerView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! HeaderView
                let section = self.sectionedCharactes[indexPath.section]
                headerView.configure(text: "\(section.category) (\(section.characters.count))".uppercased())
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSegmentedControl()
        setupCollectionView()
        setupLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "shuffle"), style: .plain, target: self, action: #selector(shuffleTapped))
    }
    
    @objc private func shuffleTapped() {
        self.sectionedCharactes = self.sectionedCharactes.shuffled().map {
            SectionCharacters(category: $0.category, characters: $0.characters.shuffled())
        }
    }
    
    private func setupSegmentedControl() {
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let padding: CGFloat = 8
        flowLayout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        sectionedCharactes = sender.selectedUniverse.sectionedStubs
    }
}

extension MultipleSectionCharactersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionedCharactes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionedCharactes[section].characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CharacterCell
        let character = sectionedCharactes[indexPath.section].characters[indexPath.item]
        cell.setup(character: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        let section = sectionedCharactes[indexPath.section]
        headerView.configure(text: "\(section.category) (\(section.characters.count))".uppercased())
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerView = HeaderView()
        let section = sectionedCharactes[section]
        headerView.configure(text: "\(section.category) (\(section.characters.count))".uppercased())

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) //
    }
    
}

struct MultipleSectionCharactersViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: MultipleSectionCharactersViewController())
    }
    
}


struct MultipleSectionViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        MultipleSectionCharactersViewControllerRepresentable()
            .edgesIgnoringSafeArea(.vertical)
            .environment(\.colorScheme, ColorScheme.dark)
//                    .environment(\.sizeCategory, ContentSizeCategory.extraExtraExtraLarge)
        
    }
}


