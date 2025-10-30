//
//  CustomFlowLayout.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit

// MARK: - HorizontalTwoRowLayout

/// A custom UICollectionViewFlowLayout that displays the first cell
/// as full width and full height, while subsequent cells are half-height
/// and arranged in two horizontal rows.
class HorizontalTwoRowLayout: UICollectionViewFlowLayout {

    // A cache to store the calculated layout attributes for each item.
    private var cache = [UICollectionViewLayoutAttributes]()

    // The content width of the collection view.
    private var contentWidth: CGFloat = 0

    // The content height of the collection view.
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }

    // MARK: - Overrides

    /// Overrides `collectionViewContentSize` to return the calculated content size.
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    /// Overrides `prepare()` to pre-calculate all layout attributes.
    override func prepare() {
        // Only perform calculations if the cache is empty.
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }

        // Set the scroll direction to horizontal.
        self.scrollDirection = .horizontal

        // Define constants for spacing and cell dimensions.
        let fullHeightCellWidth: CGFloat = (collectionView.bounds.width / 2) - 8
        let halfHeightCellWidth: CGFloat = ((collectionView.bounds.width - fullHeightCellWidth) - minimumInteritemSpacing) / 2
        
        var xOffset: CGFloat = 0.0

        // Calculate attributes for the first, full-height cell.
        if collectionView.numberOfItems(inSection: 0) > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            let frame = CGRect(x: xOffset, y: 0, width: fullHeightCellWidth, height: contentHeight + 8)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            xOffset += fullHeightCellWidth + minimumLineSpacing
        }
        
        // Calculate attributes for the remaining, half-height cells.
        var yOffset: CGFloat = 0
        for item in 1 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // Determine the y position for the current item based on the row.
            let x: CGFloat
            let y: CGFloat
            
            if yOffset == 0 {
                // First cell in the column (top row).
                x = xOffset
                y = 0
                yOffset = (collectionView.bounds.height / 2) + minimumInteritemSpacing
            } else {
                // Second cell in the column (bottom row).
                x = xOffset
                y = yOffset
                xOffset += (halfHeightCellWidth) + minimumLineSpacing
                yOffset = 0
            }

            let frame = CGRect(x: x, y: y, width: (halfHeightCellWidth - 8), height: (collectionView.bounds.height - minimumLineSpacing) / 2 )
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
        }
        
        // Update the total content width.
        if yOffset == 0 {
            contentWidth = xOffset
        } else {
            contentWidth = xOffset + halfHeightCellWidth + minimumLineSpacing
        }
    }

    /// Overrides `layoutAttributesForElements(in:)` to return attributes within the given rect.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Return a new array with only the attributes that intersect with the given rect.
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    /// Overrides `layoutAttributesForItem(at:)` to provide attributes for a specific item.
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // If the index path is valid, return the cached attributes.
        guard indexPath.item < cache.count else { return nil }
        return cache[indexPath.item]
    }
}
