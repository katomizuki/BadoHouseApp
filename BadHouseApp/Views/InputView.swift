import Foundation
import UIKit

protocol InputDelegate :AnyObject{
    func inputView(inputView:CustomInputAccessoryView,message:String)
}

class CustomInputAccessoryView:UIView {

    weak var delegate:InputDelegate?
    
    let messageInputTextView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        //スクロールを回避する。
        tv.isScrollEnabled = false
        tv.layer.cornerRadius = 15
        tv.layer.masksToBounds = true
        return tv
    }()
    
    private let sendButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("送信", for: .normal)
        button.setTitleColor(Utility.AppColor.OriginalBlue, for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeholder:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Aa"
        return label
    }()
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        layer.shadowOpacity = 0.25
        layer.shadowOffset = .init(width:0,height: -8)
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.lightGray.cgColor
        
        backgroundColor = Utility.AppColor.OriginalBlue
        autoresizingMask = .flexibleHeight
        
        addSubview(messageInputTextView)
        addSubview(sendButton)
        addSubview(placeholder)
        
        sendButton.anchor(right: rightAnchor,
                          paddingRight: 24,
                          centerY:messageInputTextView.centerYAnchor)
        messageInputTextView.anchor(top:topAnchor,
                                    bottom:safeAreaLayoutGuide.bottomAnchor,
                                    left: leftAnchor,
                                    right:rightAnchor,
                                    paddingTop: 12,
                                    paddingBottom: 12,
                                    paddingRight: 20,
                                    paddingLeft: 20)
        
        placeholder.anchor(left:messageInputTextView.leftAnchor,
                           paddingLeft: 4,centerY: messageInputTextView.centerYAnchor)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    @objc func sendMessage() {
        print(#function)
        guard let text = messageInputTextView.text else { return }
        self.delegate?.inputView(inputView: self, message: text)
    }
    
    @objc func textDidChange() {
        placeholder.isHidden = !self.messageInputTextView.isHidden
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



