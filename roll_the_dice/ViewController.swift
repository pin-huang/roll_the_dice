//  ViewController.swift
//  roll_the_dice
//  Created by Pincheng Huang on 2020/8/31.

import UIKit // 匯入工具
import AVFoundation

class ViewController: UIViewController {
   
    
    var imageFile = ["1","2","3","4","5","6"] // 宣告變數，並將骰子圖檔名稱存入陣列
    var player: AVPlayer? // 宣告變數，繼承型別 AVPlayer?，以便播放骰子滾動的聲音檔
    
    var rollingTopDice: Timer? // 宣告變數，繼承型別 Timer?，以便之後連結 IBAction func rollItAll ，使骰子圖檔在讀秒後作亂數變化
    var rollingButtomDice: Timer? // 宣告變數，繼承型別 Timer?，以便之後連結 IBAction func rollItAll ，使骰子圖檔在讀秒後作亂數變化
    var timer: Timer? // 宣告變數，繼承型別 Timer?，以便之後連結 IBAction func rollItAll ，讓滾動的骰子在三秒後停止
     
    var topSum = 0
    var buttomSum = 0
        
    
    // 設置 元件 UI Image View ，並連結 IBOutlet collection 
    @IBOutlet var topDiceResult: [UIImageView]!
    
    @IBOutlet weak var opponentScore: UILabel!
    
    @IBOutlet var buttomDiceResult: [UIImageView]!
    
    @IBOutlet weak var playerScore: UILabel!
    
    @IBOutlet weak var Comment: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 利用 Bundle.main 取得 app 專案內已預先存入的 骰子音效檔 mp3 的位址，並設定 AVPlayer 播放器
        let rollingDiceSound = Bundle.main.url(forResource: "rolldice", withExtension: "mp3")!
        player = AVPlayer(url: rollingDiceSound)
        
        
    }
    
    func result(){
        opponentScore.backgroundColor = UIColor.clear
        playerScore.backgroundColor = UIColor.clear
        
        if topSum == buttomSum {
            Comment.text = "睹聖：再來一次，輸的人是小狗"
        } else if topSum > buttomSum {
            Comment.text = "睹聖：哈哈! 我贏了，早就跟你說投降輸一半的嘛"
            opponentScore.backgroundColor = UIColor.red
        } else {
            Comment.text = "睹聖：以我這種人才敗在你門下，我除了說恭喜之外也不知該說什麼了"
            playerScore.backgroundColor = UIColor.red
            }
        }
    
    
    // 宣告一個計時器，名為 timeCounter 的 function 與 @IBAction func rollItAll 連動，可以在 3 秒後停止骰子的變化
    func timeCounter() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {(timer) in self.rollingTopDice?.invalidate()
            self.rollingButtomDice?.invalidate()
            self.player!.pause()
            self.result()
            }
    }
        
    // 設置元件 UI Button ，可在點擊後，執行骰子音效檔，並於每 0.1 秒後變換骰子圖檔
    // 與 IBOutlet topDiceResult 及 IBOutlet buttomDiceResult 連動，可在點擊後亂數變化骰子圖檔，並顯示骰子的總點數
    // 與 計時器 timeCounter 連動，可以在 3 秒後停止骰子的變化
    @IBAction func rollItAll(_ sender: UIButton) {
        
        // 利用 Bundle.main 取得 app 專案內已預先存入的 骰子音效檔 mp3 的位址，並設定 AVPlayer 播放器
        let rollingDiceSound = Bundle.main.url(forResource: "rolldice", withExtension: "mp3")!
        player = AVPlayer(url: rollingDiceSound)
        player?.play() // 執行骰子音效檔
        
        // 使用 for... in... 產生常數 i 來定位 topDiceResult 陣列中的圖檔位置
        // 新增常數 number 用來亂數產出 點數 (1 ~ 6)，然後就可用它來對應骰子圖檔 (imageFile) ，也可用來計算並顯示骰子的總點數 (topSum)
        rollingTopDice = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(_)in
            for _ in self.topDiceResult{
                self.topSum = 0
                for i in 0...2{
                    let number = Int.random(in: 1...6)
                    let imageName = self.imageFile[number - 1] // 讓隨機產出的常數 number 可以正確的對應到 imageFile 陣列中的圖檔順序，所以要 number - 1

                    self.topDiceResult[i].image = UIImage(named: imageName) // 對應骰子圖檔
                    self.topSum += number // 計算骰子的總點數
                    self.opponentScore.text = "\(self.topSum) 點" // 顯示骰子的總點數
                    
                }
            }
         })
  
        rollingButtomDice = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(_)in
            for _ in self.buttomDiceResult{
                    self.buttomSum = 0
                    for i in 0...2{
                        let number = Int.random(in: 1...6)
                        let imageName = self.imageFile[number - 1] // 讓隨機產出的常數 number 可以正確的對應到 imageFile 陣列中的圖檔順序，所以要 number - 1

                        self.buttomDiceResult[i].image = UIImage(named: imageName) // 對應骰子圖檔
                        self.buttomSum += number // 計算骰子的總點數
                        self.playerScore.text = "\(self.buttomSum) 點" // 顯示骰子的總點數
                        
                    }
                }
             })
        timeCounter()
        
    }
    
    
    // 宣告 override func motionBegan 以偵測 手機晃動開始 (以開始晃動來變化骰子圖檔)
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {

            // 利用 Bundle.main 取得 app 專案內已預先存入的 骰子音效檔 mp3 的位址，並設定 AVPlayer 播放器
            let rollingDiceSound = Bundle.main.url(forResource: "rolldice", withExtension: "mp3")!
            player = AVPlayer(url: rollingDiceSound)
            player?.play() // 執行骰子音效檔
            
            // 使用 for... in... 產生常數 i 來定位 topDiceResult 陣列中的圖檔位置
            // 新增常數 number 用來亂數產出 點數 (1 ~ 6)，然後就可用它來對應骰子圖檔 (imageFile) ，也可用來計算並顯示骰子的總點數 (topSum)
            rollingTopDice = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(_)in
                for _ in self.topDiceResult{
                    self.topSum = 0
                    for i in 0...2{
                        let number = Int.random(in: 1...6)
                        let imageName = self.imageFile[number - 1] // 讓隨機產出的常數 number 可以正確的對應到 imageFile 陣列中的圖檔順序，所以要 number - 1

                        self.topDiceResult[i].image = UIImage(named: imageName) // 對應骰子圖檔
                        self.topSum += number // 計算骰子的總點數
                        self.opponentScore.text = "\(self.topSum) 點" // 顯示骰子的總點數
                        
                    }
                }
             })
      
            rollingButtomDice = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(_)in
                for _ in self.buttomDiceResult{
                        self.buttomSum = 0
                        for i in 0...2{
                            let number = Int.random(in: 1...6)
                            let imageName = self.imageFile[number - 1] // 讓隨機產出的常數 number 可以正確的對應到 imageFile 陣列中的圖檔順序，所以要 number - 1

                            self.buttomDiceResult[i].image = UIImage(named: imageName) // 對應骰子圖檔
                            self.buttomSum += number // 計算骰子的總點數
                            self.playerScore.text = "\(self.buttomSum) 點" // 顯示骰子的總點數
                            
                        }
                    }
                 })
            timeCounter()

        }
    }
}
