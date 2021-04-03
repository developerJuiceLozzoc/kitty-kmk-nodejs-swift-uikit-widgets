//
//  DragDropVC.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/31/21.
//

import UIKit

class DragDropVC: UIViewController, KMKUseViewModel {
    var imagesvm: ImagesViewModel?
    var votevm: GameSurveyVM? {
        didSet {
            guard let form = votevm?.survey else {return}
            DispatchQueue.main.async {
                self.placeInitialImages(with: form)
            }
            votevm?.listenToVoteChanges()
            votevm?.bind {
                guard let form = self.votevm?.survey else {return}
                DispatchQueue.main.async {
                    self.placeInitialImages(with: form)
                }
               
            }
        }
    }

    @IBOutlet var imgvws: [UIImageView]!
    func placeInitialImages(with state: GameSurvey ){
        for i in 0...2{
            imagesvm?.setIndexedImageView(reference: imgvws[i], index: i, with: URL(string: state.celebs[i].imgurl))

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let dropInteraction = UIDropInteraction(delegate: self)
        view.addInteraction(dropInteraction)
        
        for imageview in imgvws {
            imageview.isUserInteractionEnabled = true
            imageview.addInteraction(UIDragInteraction(delegate: self))
            
        }
        for i in 0...2{
            imgvws[3+i].layer.borderWidth = 1
            imgvws[3+i].layer.borderColor = UIColor.gray.cgColor
            
        }
        // Do any additional setup after loading the view.
    }
    


}
extension DragDropVC: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        print("start drag")
        let imageView = interaction.view as! UIImageView
        guard let image = imageView.image else { return [] }

        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        
        /*
             Returning a non-empty array, as shown here, enables dragging. You
             can disable dragging by instead returning an empty array.
        */
        return [item]
    }

    /*
         Code below here adds visual enhancements but is not required for minimal
         dragging support. If you do not implement this method, the system uses
         the default lift animation.
    */
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        
        print("start drag")
        guard let image = item.localObject as? UIImage else { return nil }
        let imageView = interaction.view as! UIImageView
        // Scale the preview image view frame to the image's size.
        let frame: CGRect
        if image.size.width > image.size.height {
            let multiplier = imageView.frame.width / image.size.width
            frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: image.size.height * multiplier)
        } else {
            let multiplier = imageView.frame.height / image.size.height
            frame = CGRect(x: 0, y: 0, width: image.size.width * multiplier, height: imageView.frame.height)
        }

        // Create a new view to display the image as a drag preview.
        let previewImageView = UIImageView(image: image)
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.frame = frame

        /*
             Provide a custom targeted drag preview that lifts from the center
             of imageView. The center is calculated because it needs to be in
             the coordinate system of imageView. Using imageView.center returns
             a point that is in the coordinate system of imageView's superview,
             which is not what is needed here.
         */
        let center = CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY)
        let target = UIDragPreviewTarget(container: imageView, center: center)
        return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
    }
    
    
}

extension DragDropVC: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        
        let imageView = interaction.view as! UIImageView

        return true

    }
    
    // Update UI, as needed, when touch point of drag session enters view.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        let dropLocation = session.location(in: view)
    }
    
    /**
         Required delegate method: return a drop proposal, indicating how the
         view is to handle the dropped items.
    */
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        
        
        let imageView = interaction.view as! UIImageView

        let operation: UIDropOperation

        if imageView.frame.contains(dropLocation) {
            /*
                 If you add in-app drag-and-drop support for the .move operation,
                 you must write code to coordinate between the drag interaction
                 delegate and the drop interaction delegate.
            */
            operation = .move
        } else {
            // Do not allow dropping outside of the image view.
            operation = .cancel
        }

        return UIDropProposal(operation: operation)
    }
    
    /**
         This delegate method is the only opportunity for accessing and loading
         the data representations offered in the drag item.
    */
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let imageView = interaction.view as! UIImageView

        // Consume drag items (in this example, of type UIImage).
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]

            /*
                 If you do not employ the loadObjects(ofClass:completion:) convenience
                 method of the UIDropSession class, which automatically employs
                 the main thread, explicitly dispatch UI work to the main thread.
                 For example, you can use `DispatchQueue.main.async` method.
            */
            imageView.image = images.first
        }

        // Perform additional UI updates as needed.
        let dropLocation = session.location(in: view)
    }
    
    // Update UI, as needed, when touch point of drag session leaves view.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        let dropLocation = session.location(in: view)
    }
    
    // Update UI and model, as needed, when drop session ends.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        let dropLocation = session.location(in: view)
    }

    // MARK: - Helpers

    
}
