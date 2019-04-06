//
//  FeedbackSDKViewController.swift
//  Alamofire
//
//  Created by Aravind Kumar on 04/04/19.
//

import UIKit
import GrowingTextView
import JGProgressHUD

@available(iOS 9.0, *)
class FeedbackSDKViewController: UIViewController
{
    
    var dataArray  =  NSArray()
    @IBOutlet weak var tbView: UITableView!
    private var textView: GrowingTextView!
    private var textViewBottomConstraint: NSLayoutConstraint!
    private var inputToolbar: UIView!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet weak var closeBt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

        self.addInformationOverView()
        self.getAllMesseage()
        
        // Do any additional setup after loading the view.
    }
    func addInformationOverView()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.addTextView()
        self.tbView.dataSource = self;
        self.tbView.delegate = self;
        
        var resourcesBundle : Bundle? = nil;
        let containingBundle = Bundle(for: FeedbackSDKViewController.self)
        let resourcesBundleURL =  containingBundle.url(forResource: "FeedbackSDKResources", withExtension: "bundle");
        if let bb  : URL = resourcesBundleURL
        {
            resourcesBundle =  Bundle(url: bb)
        }
        
         self.tbView.register(InfoTableViewCell.self, forCellReuseIdentifier: "info")
        let closeImage : UIImage =  UIImage(named: "close_black", in: resourcesBundle, compatibleWith: nil)!
        self.closeBt.setImage(closeImage, for: .normal)
        let send_button : UIImage =  UIImage(named: "send_button", in: resourcesBundle, compatibleWith: nil)!
        self.sendBtn.setImage(send_button, for: .normal)
        
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
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        print("print1")
        self.tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 320, right: 0)
        self.scrollToBottom()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("print2")
        self.tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.dataArray.count > 1
            {
                let indexPath = IndexPath(row: self.dataArray.count-1, section: 0)
                self.tbView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func sendAction(_ sender: Any)
    {
        if self.textView.text.isEmpty
        {
            let alert = UIAlertController(title: "Error!", message: "Please enter feedback", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            //Service impliment with network manager
            
            let param:[String:String] = ["app_id":FeedbackSDKManager.sdkInstance.sdk_app_id,"secret_key":FeedbackSDKManager.sdkInstance.sdk_secret_key,"device_id": FeedbackSDKManager.sdkInstance.uniqId,"device_type":"ios","sendMessage":"1","reply_message":self.textView.text];
            
                let network = NetworkManager.shared
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = StringContent.loadingMessage
            hud.isUserInteractionEnabled =  false;
            hud.show(in: self.view)
            
                network.callServerWithRequest(urlString: StringContent.REPLY_API, type: "POST", param: param, completion: { (json:[String:Any], err:Error?) in
                    if err != nil
                    {
                    }
                    DispatchQueue.main.async {
                        if let status:NSInteger = json["status"] as? NSInteger
                        {
                            if status == 200
                            {
                                if let  data : NSArray =  json["data"] as? NSArray
                                {
                                    print(data);
                                    
                                    self.dataArray =  data.reversed() as NSArray
                                    self.tbView.reloadData()
                                    self.scrollToBottom()
                                    self.textView.text =  ""
                                }
                            }else
                            {
                            }
                        }
                    }
                    hud.dismiss()
                }
            )
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    @objc private func keyboardWillChangeFrame(_ notification: Notification)
    {
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
    func getAllMesseage()  {
        //Service impliment with network manager
        
        let param:[String:String] = ["app_id":FeedbackSDKManager.sdkInstance.sdk_app_id,"secret_key":FeedbackSDKManager.sdkInstance.sdk_secret_key,"device_id": FeedbackSDKManager.sdkInstance.uniqId,"device_type":"ios","sendMessage":"0","reply_message":""];
        
        let network = NetworkManager.shared
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = StringContent.loadingMessage
        hud.isUserInteractionEnabled =  false;
        hud.show(in: self.view)
        network.callServerWithRequest(urlString: StringContent.REPLY_API, type: "POST", param: param, completion: { (json:[String:Any], err:Error?) in
            if err != nil
            {
            }
            DispatchQueue.main.async {
                if let status:NSInteger = json["status"] as? NSInteger
                {
                    if status == 200
                    {
                        if let  data : NSArray =  json["data"] as? NSArray
                        {
                            print(data);
                            self.dataArray =  data.reversed() as NSArray
                            
                            self.tbView.reloadData()
                            self.scrollToBottom()
                            self.textView.text =  ""
                        }
                    }else
                    {
                    }
                }
            }
            hud.dismiss()
        })
        
       
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
@available(iOS 9.0, *)
extension FeedbackSDKViewController : UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var height : CGFloat = 50.0;
        let msgInfo : NSDictionary =  self.dataArray.object(at: indexPath.row) as! NSDictionary
        if let post_description : String = msgInfo["message"] as! String
        {
        height = heightForView(text: post_description, font: UIFont.systemFont(ofSize: 15) , width: self.view.frame.size.width - 50)
            height = height + 50;
        }
        return height;
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let msgInfo : NSDictionary =  self.dataArray.object(at: indexPath.row) as! NSDictionary
        let msg : String = msgInfo["message"] as! String;
        let created_on : String = msgInfo["created_on"] as! String;

       let cell : InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! InfoTableViewCell
        if let mainView =  cell.contentView.viewWithTag(11)
        {
            let labelTitle  : UILabel = mainView.viewWithTag(1) as! UILabel;
            let labelDesp  : UILabel = mainView.viewWithTag(2) as! UILabel;
            labelDesp.text = created_on
            labelTitle.text = msg
            var height : CGFloat = 20.0;
            height = heightForView(text: msg, font: UIFont.systemFont(ofSize: 15) , width: self.view.frame.size.width - 50) + 5.0
            
             mainView.frame =  CGRect(x: 40, y: 5, width: cell.contentView.frame.size.width - 50, height: height + 40)
             labelTitle.frame =  CGRect(x: 5, y: 10, width: mainView.frame.size.width - 10, height: height);
             labelDesp.frame = CGRect(x: 5, y: mainView.frame.size.height - 20 , width: mainView.frame.size.width - 10, height: 15);
            
        }else
        {
            var height : CGFloat = 20.0;
            height = heightForView(text: msg, font: UIFont.systemFont(ofSize: 15) , width: self.view.frame.size.width - 50) + 5.0

            let mainView : UIView = UIView(frame: CGRect(x: 40, y: 5, width: cell.contentView.frame.size.width - 50, height: height + 40 ))
            mainView.backgroundColor =  UIColor.init(red: 205.0/255.0, green: 151.0/255.0, blue: 222.0/255.0, alpha: 1.0)
            mainView.clipsToBounds = true;
            mainView.layer.cornerRadius  = 5.0;
            mainView.tag = 11;
            let labelTitle : UILabel = UILabel(frame: CGRect(x: 5, y: 10, width: mainView.frame.size.width - 10, height: height));
            labelTitle.tag =  1;
            labelTitle.font =  UIFont.systemFont(ofSize: 15);
            labelTitle.textAlignment = .left;
            labelTitle.numberOfLines = 1000000;
            
            let labelDesp : UILabel = UILabel(frame: CGRect(x: 5, y: mainView.frame.size.height - 20 , width: mainView.frame.size.width - 10, height: 15));
            labelDesp.tag =  2;
            labelDesp.font =  UIFont.systemFont(ofSize: 10);
            labelDesp.textAlignment = .right;
            mainView.addSubview(labelDesp);
            mainView.addSubview(labelTitle);
            
            labelDesp.text = created_on
            labelTitle.text = msg
            labelTitle.backgroundColor =  UIColor.clear;
            labelTitle.backgroundColor =  UIColor.clear;

            labelTitle.textColor = UIColor.white
            labelDesp.textColor = UIColor.white

            cell.contentView.addSubview(mainView);
        }
        //let cell : FeedbackMeTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "FeedbackMeTableViewCell") ?? nil)! as! FeedbackMeTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
}

