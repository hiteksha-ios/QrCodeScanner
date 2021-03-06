
import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {
 
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loader: NVActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() -> Void {
        Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loader.type = .circleStrokeSpin
    }
    
    func startLoader() -> Void {
        print("Loader Start")
        loader.startAnimating()
    }
    
    func stopLoader() -> Void {
        loader.stopAnimating()
        self.removeFromSuperview()
    }
    

}
