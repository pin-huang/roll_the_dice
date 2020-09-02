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
    var timer: Timer? // 宣告變數，繼承型別 Timer?，以便之後與 IBAction func rollItAll 連動 ，讓滾動的骰子在三秒後停止
     
    var topSum = 0 // 宣告變數，讓 IBAction func rollItAll 計算骰子的總點數
    var buttomSum = 0 // 宣告變數，讓 IBAction func rollItAll 計算骰子的總點數
    var opponentMoney = 100
    var playerMoney = 100
    var bidMoney = ""
    
    let opponentWin = ["賭聖：哈哈! 我贏了，早就跟你說投降輸一半的嘛", "賭聖：再回去練練吧你", "賭聖：你可不要輸到脫褲子啊", "賭聖：回家喝奶吧你", "賭聖：你回火星吧，地球是很危險的", "賭聖：我左青龍，右白虎，老牛在腰間，龍頭在胸口，人擋殺人，佛擋殺佛！", "賭聖：意不意外？高不高興？開不開心？", "賭聖：喂喂喂！大家不要生氣，生氣會犯了嗔戒的！"]
    let evenscore = ["賭聖：再來一次，輸的人是小狗", "賭聖：沒事! 沒事!", "賭聖：再來啊"]
    let opponentLose = ["賭聖：以我這種人才敗在你門下，我除了說恭喜之外也不知該說什麼了", "賭聖：不會吧?", "賭聖：來真的? 船還沒到公海呢", "賭聖：有沒有搞錯?", "賭聖：I 服了 You", "賭聖：別打了，跟我出去看上帝好不好?", "賭聖：你媽貴姓？", "賭聖：命運真是不公平，為什麼我這麼帥卻要掉頭髮，你們長的那麼醜卻不掉頭髮?", "賭聖：有沒有錢沒關係，但起碼要做一個受人尊重的人！"]
    
    
    // 設置 元件 UI Image View ，並連結 IBOutlet collection 
    @IBOutlet var topDiceResult: [UIImageView]!
    
    // 設置 元件 UI Label ，讓 func result() 比對結果，並顯示骰子的總和
    @IBOutlet weak var opponentScore: UILabel!
    
    // 設置 元件 UI Label ，讓 func result() 比對結果，並變換金額
    @IBOutlet weak var opponentCoin: UILabel!
    
    // 設置 元件 UI Image View ，並連結 IBOutlet collection
    @IBOutlet var buttomDiceResult: [UIImageView]!
    
    // 設置 元件 UI Label ，讓 func result() 比對結果，並顯示骰子的總和
    @IBOutlet weak var playerScore: UILabel!
    
    // 設置 元件 UI Label ，讓 func result() 比對結果，並變換金額
    @IBOutlet weak var playerCoin: UILabel!
    
    // 設置 元件 UI Label ，讓 func result() 比對結果，並帶出賭聖的台詞
    @IBOutlet weak var Comment: UILabel!
    
    
    @IBOutlet weak var Label: UILabel!
    
    // 設置 元件 UI Text field ，讓使用者決定下注金額，並在 func result() 比對結果
    @IBOutlet weak var bid: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 利用 Bundle.main 取得 app 專案內已預先存入的 骰子音效檔 mp3 的位址，並設定 AVPlayer 播放器 (因為是在 viewDidLoad 之下，所以此音效檔只會載入一次就失效了，但這裡若不先宣告，第一次執行 roll it all 會沒音效)
        let rollingDiceSound = Bundle.main.url(forResource: "rolldice", withExtension: "mp3")!
        player = AVPlayer(url: rollingDiceSound)
    }
    
    // 點擊鍵盤外的區域，即可收起鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    // 宣告 func result() 比對結果，判斷要帶出哪句台詞，並在 元件 UI Label (opponentScore、playerScore) 顯示骰子的總和
    func result(){
        opponentScore.backgroundColor = UIColor.clear // 清除 元件 UI Label 的底色
        playerScore.backgroundColor = UIColor.clear
        
 
        
        
        if topSum == buttomSum {
            Comment.text = String(evenscore.randomElement()!)
        } else if topSum > buttomSum, playerMoney >= 0 {
            Comment.text = String(opponentWin.randomElement()!)
            opponentScore.backgroundColor = UIColor.red // 標示贏家 元件 UI Label 的底色
            let bidMoney = Int(bid.text!) ?? 10 // 讓 元件 UI Text field 的內容 (bid ，型別為 String) 轉換成 Int 的型別，且預設內容值為 10
            opponentMoney = opponentMoney + bidMoney
            opponentCoin.text = String(opponentMoney)
            
            playerMoney = playerMoney - bidMoney
            playerCoin.text = String(playerMoney)
        
            if playerMoney <= 0 {
                Comment.text = "賭聖：比賽結束，下去把錢付清，回家喝奶吧你"
            }
            
        } else {
            Comment.text = String(opponentLose.randomElement()!)
            playerScore.backgroundColor = UIColor.red
            let bidMoney = Int(bid.text!) ?? 10
            opponentMoney = opponentMoney - bidMoney
            opponentCoin.text = String(opponentMoney)
            
            playerMoney = playerMoney + bidMoney
            playerCoin.text = String(playerMoney)
            
            if opponentMoney <= 0 {
                Comment.text = "賭聖：這不是真的，你看不到我… 你看不到我…"
                Label.text = "比賽結束，你贏了"
            }
            }
        }
    
    
    // 宣告一個計時器 (名為 timeCounter 的 function) 與 @IBAction func rollItAll 連動，可以在 3 秒後停止骰子的變化
    func timeCounter() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {(timer) in self.rollingTopDice?.invalidate()
            self.rollingButtomDice?.invalidate()
            self.player!.pause()
            self.result()
            }
    }
        
    // 設置元件 UI Button ，可在點擊後，執行骰子音效檔，並於每 0.1 秒後變換骰子圖檔
    // 與 IBOutlet topDiceResult 及 IBOutlet buttomDiceResult 連動，可在點擊後亂數變化骰子圖檔，計算並顯示骰子的總點數
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
                    self.topSum += number // 將此陣列中每個骰子的點數作加總計算
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
                        self.buttomSum += number // 將此陣列中每個骰子的點數作加總計算
                        self.playerScore.text = "\(self.buttomSum) 點" // 顯示骰子的總點數
                        
                    }
                }
             })
        timeCounter() // 執行計時器 timeCounter ，在 3 秒後停止骰子的變化，並帶出阿星的台詞
        
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
                        self.topSum += number // 將此陣列中每個骰子的點數作加總計算
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
                            self.buttomSum += number // 將此陣列中每個骰子的點數作加總計算
                            self.playerScore.text = "\(self.buttomSum) 點" // 顯示骰子的總點數
                            
                        }
                    }
                 })
            timeCounter() // 執行計時器 timeCounter ，在 3 秒後停止骰子的變化，並帶出阿星的台詞

        }
    }

}
