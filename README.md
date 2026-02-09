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

常見如：

+ 前處理 ```--clean```，移除緩存內容
+ 後處理 ```--output=[TARGET_DIR]```，複製緩存內容到指定位置

## 測試

本研究測試以下啟動操作：

+ 若不存在目標映像檔 ( hello-world )，則應下載
+ 若設定選項 ```--clean``` 則移除快取目錄
+ 執行目標映像檔，並產生一個時間記錄存放於快取目錄
+ 若設定選項 ```--output``` 則將快取內容複製到目標目錄

### 測試環境

本研究主要開發環境為 Window 作業系統，使用 [ConEmu](https://conemu.github.io/) 啟動指令列執行。

+ batch

使用 [ConEmu](https://conemu.github.io/) 添加一個 ```shells:cmd```，並前往 ```src``` 目錄內執行

+ powershell

使用 [ConEmu](https://conemu.github.io/) 添加一個 ```shells:powershell```，並前往 ```src``` 目錄內執行

+ shell

使用 [ConEmu](https://conemu.github.io/) 添加一個 ```Bash:bash```，並前往 ```src``` 目錄內執行

+ zsh

使用擁有 Zsh 的 Docker 映像檔為開發與測試環境，其句型如下：

```
docker build -t docker:zsh %cd%\conf\docker\zsh
docker run -ti --rm ^
  -v "//var/run/docker.sock:/var/run/docker.sock" ^
  -v %cd%\src:/app ^
  -w /app ^
  docker:zsh
```

### 測試項目

+ 移除映像檔並重新載入
```
docker rmi hello-world
# Batch
launcher
# Powershell
.\launcher.ps1
# Shell
./launcher.sh
# Zsh
zsh ./launcher.sh
```

+ 移除快取目錄，確保移除舊的時間記錄檔案，僅有最新的檔案
```
# Batch
launcher --clean
# Powershell
.\launcher.ps1 -Clean
# Shell
./launcher.sh --clean
# Zsh
zsh ./launcher.sh --clean
```

+ 複製快取目錄至目標目錄，確保所有紀錄皆外移
```
# Batch
launcher --output=.\tmp
# Powershell
.\launcher.ps1 -Output=.\tmp
# Shell
./launcher.sh --output=.\tmp
# Zsh
zsh ./launcher.sh --output=.\tmp
```
