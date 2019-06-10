//
//  ACScanViewController.swift
//  ACCS
//
//  Created by wilson on 2019/5/10.
//  Copyright © 2019 com.accs.ios. All rights reserved.
//
import UIKit
import AVFoundation

/// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width

/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height

/// 导航条高度
let kNavigationHeight = UIApplication.shared.statusBarFrame.height

/// 中间扫描框的高度
private let kBoxW : CGFloat = kScreenWidth * 0.5

/// 中间扫描框的中间点的Y
private let kBoxCentY : CGFloat = kScreenHeight * 0.4

//中间扫描框的四个顶点
private let leftTopPoint = CGPoint.init(x: (kScreenWidth - kBoxW)/2, y: (kBoxCentY - (kBoxW/2)))
private let rightTopPoint = CGPoint.init(x: (kScreenWidth + kBoxW)/2, y: (kBoxCentY - (kBoxW/2)))
private let rightBottomPoint = CGPoint.init(x: (kScreenWidth + kBoxW)/2, y: (kBoxCentY + (kBoxW/2)))
private let leftBottomPoint = CGPoint.init(x: (kScreenWidth - kBoxW)/2, y: (kBoxCentY + (kBoxW/2)))

class ACScanViewController: UIViewController {
    
    //声明一个闭包回调函数
    public var qrCodeBlock:((_ qrCodeResult:String)->Void)?
    
    /// 扫描会话
    var session = AVCaptureSession()
    
    /// 预览图层
    lazy var preview : AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer.init(session: self.session)
        
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        preview.frame = CGRect.init(x: 0, y: kNavigationHeight, width: kScreenWidth, height:kScreenHeight - kNavigationHeight)
        
        preview.backgroundColor = UIColor.black.cgColor
        
        
        let bpath : UIBezierPath = UIBezierPath.init(rect: self.view.bounds)
        
        let shaplayer = CAShapeLayer()
        
        shaplayer.frame = preview.bounds
        
        let path = self.createBezierPath(points: [leftTopPoint,rightTopPoint,rightBottomPoint,leftBottomPoint])
        
        bpath.append(path)
        
        shaplayer.path = bpath.cgPath
        
        shaplayer.fillColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
//        shaplayer.fillRule = CAShapeLayerFillRule.evenOdd
       
        let edgeWidth : CGFloat = 30
        
        let edgeSize = CGSize.init(width: edgeWidth, height: edgeWidth)
        
        let edgeLineWidth : CGFloat = 2
        
        let leftTopLayer = CAShapeLayer()
        
        leftTopLayer.frame = CGRect.init(origin: leftTopPoint, size: edgeSize)
        
        let leftTopPath = self.createBezierPath(points: [CGPoint.init(x: 0, y: 0),CGPoint.init(x: edgeWidth, y: 0),CGPoint.init(x: edgeWidth, y: edgeLineWidth),CGPoint.init(x: edgeLineWidth, y: edgeLineWidth),CGPoint.init(x: edgeLineWidth, y: edgeWidth),CGPoint.init(x: 0, y: edgeWidth)])
        leftTopLayer.path = leftTopPath.cgPath
        leftTopLayer.fillColor = UIColor.green.cgColor
        
        
        let rightTopLayer = CAShapeLayer()
        rightTopLayer.frame = CGRect.init(origin: CGPoint.init(x: rightTopPoint.x - edgeWidth, y: rightTopPoint.y), size: edgeSize)
        
        let rightTopPath = self.createBezierPath(points: [CGPoint.init(x: edgeWidth, y: 0),CGPoint.init(x: 0, y: 0),CGPoint.init(x: 0, y: edgeLineWidth),CGPoint.init(x: edgeWidth - edgeLineWidth, y: edgeLineWidth),CGPoint.init(x: edgeWidth - edgeLineWidth, y: edgeWidth),CGPoint.init(x: edgeWidth, y: edgeWidth)])
        rightTopLayer.path = rightTopPath.cgPath
        rightTopLayer.fillColor = UIColor.green.cgColor
        
        let rightBottomLayer = CAShapeLayer()
        rightBottomLayer.frame = CGRect.init(origin: CGPoint.init(x: rightBottomPoint.x - edgeWidth, y: rightBottomPoint.y - edgeWidth), size: edgeSize)
        
        let rightBottomPath = self.createBezierPath(points: [CGPoint.init(x: edgeWidth, y: edgeWidth),CGPoint.init(x: edgeWidth, y: 0),CGPoint.init(x: edgeWidth - edgeLineWidth, y: 0),CGPoint.init(x: edgeWidth - edgeLineWidth, y: edgeWidth - edgeLineWidth),CGPoint.init(x: 0, y: edgeWidth - edgeLineWidth),CGPoint.init(x: 0, y: edgeWidth)])
        rightBottomLayer.path = rightBottomPath.cgPath
        rightBottomLayer.fillColor = UIColor.green.cgColor
        
        
        let leftBottomLayer = CAShapeLayer()
        leftBottomLayer.frame = CGRect.init(origin: CGPoint.init(x: leftBottomPoint.x, y: leftBottomPoint.y - edgeWidth), size: edgeSize)
        
        let leftBottomPath = self.createBezierPath(points: [CGPoint.init(x: 0, y: edgeWidth),CGPoint.init(x: edgeWidth, y: edgeWidth),CGPoint.init(x: edgeWidth, y: edgeWidth - edgeLineWidth),CGPoint.init(x: edgeLineWidth, y: edgeWidth - edgeLineWidth),CGPoint.init(x: edgeLineWidth, y: 0),CGPoint.init(x: 0, y: 0)])
        leftBottomLayer.path = leftBottomPath.cgPath
        leftBottomLayer.fillColor = UIColor.green.cgColor
       
        preview.addSublayer(shaplayer)
        preview.addSublayer(leftTopLayer)
        preview.addSublayer(rightTopLayer)
        preview.addSublayer(rightBottomLayer)
        preview.addSublayer(leftBottomLayer)
        return preview
    }()
    
    lazy var animalLine : UIImageView = {
        
        let line = UIImageView.init(image: UIImage.init(named: "qrcode_scan_animal"))
        
        self.view.addSubview(line)
        
        return line
    }()
    
    var isAnimal : Bool?
    
    lazy var prompt : UILabel = {
        let prompt = UILabel.init(frame: CGRect.init(x: leftBottomPoint.x, y: leftBottomPoint.y + kNavigationHeight + 10, width: kBoxW, height: 60))
        prompt.text = "将二维码放入扫描框即可自动扫描"
        prompt.textAlignment = .center
        prompt.font = UIFont.systemFont(ofSize: 15)
        prompt.textColor = UIColor.white
        prompt.numberOfLines = 0
        prompt.sizeToFit()
        
        return prompt
    }()
    var timer : Timer?
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopRunning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRunning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "扫描二维码"
        /// 获取设备
        let devices = AVCaptureDevice.devices(for: .video)
        let d = devices.filter({ return $0.position == .back }).first
        /// 视频输入
        let videoInput = try? AVCaptureDeviceInput(device: d!)
        let queue =  DispatchQueue.global(qos: .default)
        
        let videoOutput = AVCaptureMetadataOutput()
        
        videoOutput.setMetadataObjectsDelegate(self, queue: queue)
        if session.canAddInput(videoInput!) {
            session.addInput(videoInput!)
        }
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        ///扫描类型
        videoOutput.metadataObjectTypes = [
            .qr,
            .code39,
            .code128,
            .code39Mod43,
            .ean13,
            .ean8,
            .code93]
        ///可识别区域  注意看这个rectOfInterest  不是一左上角为原点，以右上角为原点 并且rect的值是个比例在【0，1】之间
        videoOutput.rectOfInterest = CGRect.init(x: (kBoxCentY - (kBoxW/2) + kNavigationHeight/2)/kScreenHeight, y: 1 - (kScreenWidth + kBoxW)/2/kScreenWidth, width: kBoxW/kScreenHeight, height: kBoxW/kScreenWidth)
        view.layer.addSublayer(preview)
        self.view.addSubview(prompt)
    }
    
    
    func createBezierPath( points : [CGPoint]) -> UIBezierPath {
        
        var points = points
        let path = UIBezierPath()
        path.move(to: points.first!)
        points.remove(at: 0)
        for point in points {
            path.addLine(to: point)
        }
        path.close()
        return path
    }
    
    
    /// 开始扫描
    func startRunning() {
        session.startRunning()
        setupTimer()
    }
    
    @objc func animalStart() {
        view.bringSubview(toFront: self.animalLine)
        animalLine.frame = CGRect.init(x: leftTopPoint.x, y: leftTopPoint.y + kNavigationHeight , width: kBoxW, height: 1)
        UIView.animate(withDuration: 3, animations: {
            
            let frame = self.animalLine.frame
            
            let newY : CGFloat = leftTopPoint.y + kNavigationHeight + kBoxW - frame.size.height
            
            let newFrame = CGRect.init(x: frame.origin.x, y: newY, width: frame.size.width, height: frame.size.height)
            
            self.animalLine.frame = newFrame
            
        }) { (finish) in
        }
    }
    
    /// 结束扫描
    func stopRunning()  {
        session.stopRunning()
        timer?.invalidate()
    }
    
    func setupTimer()  {
        self.animalStart()
        self.timer = Timer.init(timeInterval: 3, target: self, selector: #selector(animalStart), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.commonModes)
    }
    deinit {
        print("dealloc")
    }
}
extension ACScanViewController : AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //扫描结果
        print(output)
        if metadataObjects.count > 0  {
            let obj : AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            let qrcodeResult : String = obj.stringValue!
            stopRunning()

            qrCodeBlock!(qrcodeResult)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

