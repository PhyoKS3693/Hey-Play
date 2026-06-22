//
//  CustomFlowLayout.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit

// MARK: - HorizontalTwoRowLayout

/// A custom UICollectionViewFlowLayout that displays the first cell as a large landscape card (full height)
/// and subsequent cells as smaller portrait cards arranged in 2 rows, scrolling horizontally.
class HorizontalTwoRowLayout: UICollectionViewFlowLayout {

    // A cache to store the calculated layout attributes for each item.
    private var cache = [UICollectionViewLayoutAttributes]()

    // The content width of the collection view.
    private var contentWidth: CGFloat = 0

    // The content height of the collection view.
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 240 // Default fixed height
        }
        // Use a fixed height for consistency
        return max(collectionView.bounds.height, 240)
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

        // Calculate available width (screen width minus container padding)
        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right

        // Define cell dimensions to fit screen
        let spacing: CGFloat = minimumInteritemSpacing

        // Large card fills the FULL collection height (no insets)
        let largeCardHeight = collectionView.bounds.height
        let largeCardWidth = availableWidth * 0.55

        // Calculate small card dimensions based on remaining space
        // Remaining width for small cards (account for spacing between large and small cards)
        let remainingWidth = availableWidth - largeCardWidth - minimumLineSpacing

        // Small cards: 2 columns of small cards visible
        let smallCardWidth = (remainingWidth - minimumLineSpacing) / 2
        let smallCardHeight = (largeCardHeight - spacing) / 2

        var xOffset: CGFloat = sectionInset.left

        // Calculate attributes for the first cell (large landscape card)
        if collectionView.numberOfItems(inSection: 0) > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            // First item fills full height from y=0
            let frame = CGRect(x: xOffset, y: 0, width: largeCardWidth, height: largeCardHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            xOffset += largeCardWidth + minimumLineSpacing
        }

        // Calculate attributes for remaining cells (small portrait cards in 2 rows)
        var currentRow = 0
        for item in 1 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            // Determine y position based on row
            let y: CGFloat
            if currentRow == 0 {
                y = 0
            } else {
                y = smallCardHeight + spacing
            }

            let frame = CGRect(x: xOffset, y: y, width: smallCardWidth, height: smallCardHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)

            // Toggle between rows
            if currentRow == 0 {
                currentRow = 1
            } else {
                currentRow = 0
                xOffset += smallCardWidth + minimumLineSpacing
            }
        }

        // Update the total content width
        contentWidth = xOffset + sectionInset.right
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

    /// Override to invalidate layout when bounds change
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.width != collectionView.bounds.width || newBounds.height != collectionView.bounds.height
    }

    /// Clear cache when invalidating
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentWidth = 0
    }
}
