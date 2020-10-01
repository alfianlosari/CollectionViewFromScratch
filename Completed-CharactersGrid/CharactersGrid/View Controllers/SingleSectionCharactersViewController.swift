//
//  SingleSectionCharacterViewController.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//


import UIKit
import SwiftUI

class SingleSectionCharactersViewControler: UIViewController {
    
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let segmentedControl = UISegmentedControl(
        items: Universe.allCases.map { $0.title }
    )
    
    private var characters = Universe.ff7r.stubs {
        didSet {
            updateCollectionView(oldItems: oldValue, newItems: characters)
        }
    }
    
    private func updateCollectionView(oldItems: [Character], newItems: [Character]) {
        collectionView.performBatchUpdates {
            let diff = newItems.difference(from: oldItems)
            
            diff.forEach { [weak self] (change) in
                switch change {
                case let .remove(offset, _, _):
                    self?.collectionView.deleteItems(at: [IndexPath(item: offset, section: 0)])
                case let .insert(offset, _, _):
                    self?.collectionView.insertItems(at: [IndexPath(item: offset, section: 0)])
                }
            }
        } completion: { (_) in
            let headerIndexPaths = self.collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
            headerIndexPaths.forEach { (indexPath) in
                let headerView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! HeaderView
                headerView.configure(text: "\(self.characters.count) character(s)")
            }
            self.collectionView.collectionViewLayout.invalidateLayout()
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
        characters.shuffle()
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
        characters = sender.selectedUniverse.stubs
    }
}

extension SingleSectionCharactersViewControler: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CharacterCell
        cell.setup(character: characters[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        headerView.configure(text: "\(characters.count) Character(s)")
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = HeaderView()
        headerView.configure(text: "\(characters.count) Character(s)")

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }

}

struct SingleSectionCharactersViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: SingleSectionCharactersViewControler())
    }
    
}

struct ViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        SingleSectionCharactersViewControllerRepresentable()
            .edgesIgnoringSafeArea(.vertical)
//            .environment(\.sizeCategory, ContentSizeCategory.accessibilityExtraExtraExtraLarge)
        
    }
}
