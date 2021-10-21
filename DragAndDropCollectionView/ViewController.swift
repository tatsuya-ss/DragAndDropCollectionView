//
//  ViewController.swift
//  DragAndDropCollectionView
//
//  Created by 坂本龍哉 on 2021/10/20.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var numbers: [Number] = [Number(name: "a", number: 0),
                                     Number(name: "b", number: 1),
                                     Number(name: "c", number: 2),
                                     Number(name: "d", number: 3),
                                     Number(name: "e", number: 4),
                                     Number(name: "f", number: 5), Number(name: "f", number: 5)]
    private var selectedIndexPath: IndexPath = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

}

// MARK: - UICollectionViewDragDelegate
extension ViewController: UICollectionViewDragDelegate {
    // 単数ドラッグ
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        let number = numbers[indexPath.item]
        let object = number.name as NSString
        let itemProvider = NSItemProvider(object: object)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = object
        return [dragItem]
    }
    
    //     複数ドラッグ
    func collectionView(_ collectionView: UICollectionView,
                        itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath,
                        point: CGPoint) -> [UIDragItem] {
        let number = numbers[indexPath.item]
        let object = number.name as NSString
        let itemProvider = NSItemProvider(object: object)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
}

// MARK: - UICollectionViewDropDelegate
extension ViewController: UICollectionViewDropDelegate {
    
    // ドロップをどのように処理するか知らせる
    // 移動するたびに呼ばれる
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession == nil {
            return UICollectionViewDropProposal(operation: .copy,
                                                intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .move,
                                                intent: .insertAtDestinationIndexPath)
        }
    }
    
    // 提供されたアイテムをどのように処理するかを決定し、データソースを更新する。
    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
              let sourceIndexPath = coordinator.items.first?.sourceIndexPath,
              let dragItem = coordinator.items.first?.dragItem
        else { return }
        selectedIndexPath = destinationIndexPath
        collectionView.performBatchUpdates {
            let sourceItem = numbers.remove(at: sourceIndexPath.item)
            numbers.insert(sourceItem, at: destinationIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
        }
        coordinator.drop(dragItem, toItemAt: destinationIndexPath)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                      for: indexPath) as! CollectionViewCell
        if selectedIndexPath == indexPath {
            cell.changeBackgroundColor()
        }
        cell.configure(number: numbers[indexPath.item])
        return cell
    }
    
}

// MARK: -
extension ViewController {
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.register(CollectionViewCell.nib,
                                forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }

}

