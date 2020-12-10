import UIKit

/// Resizeable Image View that takes a max height and max width
/// Will resize the imageView to best fit for the aspect ratio of the image,
/// With the given space provided.
public class ResizeableImageView: UIImageView {
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - INITIALIZERS:
    
    public override init(image: UIImage?) {
        super.init(image: image)
    }
    
    /// Given the max width and height, resizes the imageView to fit the image.
    ///  - IMPORTANT: This subclass adds a height and width constraint.
    /// - Parameters:
    ///   - image: (UIImage?) The image to add to the imageView.
    ///   - maxWidth: (CGFloat) The max width you would like the imageView to grow to.
    ///   - maxHeight: (CGFloat) The max height you would like the imageView to grow to.
    convenience init(image: UIImage?, maxWidth: CGFloat, maxHeight: CGFloat) {
        self.init(image: image)
        widthConstraint?.constant = maxWidth
        heightConstraint?.constant  = maxHeight
    }
    
    @available (*, unavailable) required internal init?(coder aDecoder: NSCoder) { nil }
    
    // MARK: - VARIABLES:
    
    /// The maximum width that you want this imageView to grow to.
    private var maxWidth: CGFloat {
        get { widthConstraint?.constant ?? 0 }
        set { widthConstraint?.constant = newValue }
    }
    
    /// The maximum height that you want this imageView to grow to.
    private var maxHeight: CGFloat {
        get { heightConstraint?.constant ?? 0 }
        set { heightConstraint?.constant = newValue }
    }
    
    private var maxAspectRatio: CGFloat { maxWidth / maxHeight }
    
    override public var intrinsicContentSize: CGSize {
        guard let classImage = self.image else { return frame.size }
        
        let imageWidth = classImage.size.width
        let imageHeight = classImage.size.height
        let aspectRatio = imageWidth / imageHeight
        
        // Width is greater than height, return max width image and new height.
        if imageWidth > imageHeight {
            let newHeight = maxWidth/aspectRatio
            self.widthConstraint?.constant = maxWidth
            self.heightConstraint?.constant = newHeight
            return CGSize(width: maxWidth, height: newHeight)
        }
        
        // Height is greater than width, return max height and new width.
        if imageHeight > imageWidth {
            // If the aspect ratio is larger than our max ratio, then using max width
            // will be hit before max height.
            if aspectRatio > maxAspectRatio {
                let newHeight = maxWidth/aspectRatio
                self.widthConstraint?.constant = maxWidth
                self.heightConstraint?.constant = newHeight
                return CGSize(width: maxWidth, height: newHeight)
            }
            let newWidth = maxHeight * aspectRatio
            self.widthConstraint?.constant = newWidth
            self.heightConstraint?.constant = maxHeight
            return CGSize(width: newWidth, height: maxHeight)
        }
        
        // Square image, return the lesser of max width and height.
        let squareMinimumValue = min(maxWidth, maxHeight)
        self.widthConstraint?.constant = squareMinimumValue
        self.heightConstraint?.constant = squareMinimumValue
        return CGSize(width: squareMinimumValue, height: squareMinimumValue)
    }
}
