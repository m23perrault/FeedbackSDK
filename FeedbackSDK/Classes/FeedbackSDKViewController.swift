//
//  FeedbackSDKViewController.swift
//  Alamofire
//
//  Created by Aravind Kumar on 04/04/19.
//

import UIKit
import GrowingTextView

@available(iOS 9.0, *)
class FeedbackSDKViewController: UIViewController {
    private var textView: GrowingTextView!
    private var textViewBottomConstraint: NSLayoutConstraint!
    private var inputToolbar: UIView!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet weak var closeBt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        
        self.addTextView()

        // Do any additional setup after loading the view.
        self.getImagePath()
    }
    func getImagePath()
    {
        var resourcesBundle : Bundle? = nil;
        let containingBundle = Bundle(for: FeedbackSDKViewController.self)
        let resourcesBundleURL =  containingBundle.url(forResource: "FeedbackSDKResources", withExtension: "bundle");
        if let bb  : URL = resourcesBundleURL
        {
            resourcesBundle =  Bundle(url: bb)
        }
        
        
        let closeImage : UIImage =  UIImage(named: "closeBlue", in: resourcesBundle, compatibleWith: nil)! ;
        self.closeBt.setImage(closeImage, for: .normal)
        print(closeImage);
        let send_button : UIImage =  UIImage(named: "send_button", in: resourcesBundle, compatibleWith: nil)! ;
        self.sendBtn.setImage(send_button, for: .normal)
        print(closeImage);
        
    }
    
    @available(iOS 9.0, *)
    func addTextView()
    {
        // *** Create Toolbar
        inputToolbar = UIView()
        inputToolbar.backgroundColor = UIColor.white
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputToolbar)
        
        // *** Create GrowingTextView ***
        textView = GrowingTextView()
        textView.delegate = self
        textView.layer.cornerRadius = 4.0
        textView.maxLength = 250
        textView.maxHeight = 100
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholder = "Say something..."
        textView.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
        textView.placeholderColor = UIColor.gray
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        inputToolbar.addSubview(textView)
        
        inputToolbar.addSubview(self.sendBtn)
        
        self.sendBtn.translatesAutoresizingMaskIntoConstraints = true;
        
        self.sendBtn.frame =  CGRect.init(x: self.view.frame.size.width - 49 , y: 0, width: 49, height: 49);
        
        sendBtn.backgroundColor = UIColor.clear
        
        
        // *** Autolayout ***
        let topConstraint = textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            inputToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topConstraint
            ])
        
        
        
        
        if #available(iOS 11, *) {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: -51),
                textViewBottomConstraint
                ])
        } else {
            if #available(iOS 9.0, *) {
                textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.bottomAnchor, constant: -51)
                NSLayoutConstraint.activate([
                    textView.leadingAnchor.constraint(equalTo: inputToolbar.leadingAnchor, constant: 8),
                    textView.trailingAnchor.constraint(equalTo: inputToolbar.trailingAnchor, constant: -51),
                    textViewBottomConstraint
                    ])
            } else {
                // Fallback on earlier versions
            }
        }
        

    }
    @objc private func keyboardWillChangeFrame(_ notification: Notification)
    {
      
        
        print("aravind")
        if let userInfo = notification.userInfo {
        
        if let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
        
            
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = -keyboardHeight - 8
            view.layoutIfNeeded()
        }
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        print("print1")
        //self.tbView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 320, right: 0)
        //self .scrollToBottom()
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("print2")
     //   self.tbView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 80, right: 0)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
}
@available(iOS 9.0, *)
extension FeedbackSDKViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
