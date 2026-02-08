# research-container-launcher

調研不同作業系統下的容器啟動腳本。

## 簡介

容器服務的啟動程序步驟雖不困難，但仍有其常規步驟，本次研究就是將常見的步驟區分為不同處理函數區塊，以此常規化修改區域。

## 項目

### 語法

本研究包括以下腳本語法：

+ [batch](https://www.tutorialspoint.com/batch_script/index.htm) for Window
+ [powershell](https://www.tutorialspoint.com/powershell/index.htm) for Window
+ [bash shell](https://www.w3schools.com/bash/bash_script.php) for Linux
+ [Z shell](https://www.zsh.org/) for MacOS

## 主要程序

1. 容器映像檔載入
2. 參數前處理
3. 啟動容器
4. 參數後處理

#### 映像檔載入

經由下載檔案網址或來源映像檔服務主機網址，再啟動前進行下載處理。

網址設定參數來自兩處：

+ 腳本預設的腳本參數
+ 作業系統的環境參數

考量上述測試正確性，需額外建置以下服務：

+ 檔案下載伺服器
    - [infra-hfs](https://github.com/eastmoon/infra-hfs)
+ 映像檔發佈伺服器
    - [Registry](https://hub.docker.com/_/registry)

#### 參數前處理、後處理

經由指令解析，區分 ```--key=value``` 的目標參數與數值，並於前、後處理函數應對相關作業系統的檔案、目錄操作。
