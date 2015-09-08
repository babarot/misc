# -*- coding: utf-8 -*-

import os
import shutil
import stat

#   # ディレクトリを作成する
#   os.mkdir("path")
#   os.makedirs("aaa/bbb")  # 再帰的に作成する
#   
#   # ファイルをコピーする
#   shutil.copy("src", "dst")
#   shutil.copytree("src", "dst")
#   
#   # ファイルを移動する
#   shutil.move("src", "dst")
#   
#   # ファイルを削除する
#   os.remove("path")
#   
#   # ディレクトリを削除する
#   os.rmdir("path")  # 空でないと削除できない
#   shutil.rmtree("path")  # ディレクトリが空で無くても削除できる
#   
#   # ファイルの名前を変更する
#   os.rename("src", "dst")
#   
#   # ファイルの更新日を変更する 第2引数(アクセス日時,修正日時)
#   os.utime("path", (1, 10000))
#   
#   # ファイル権限を変更する
#   os.chmod("path", stat.S_IREAD | stat.S_IWRITE)
#   
#   # ファイルの詳細情報を取得する
#   st = os.stat("path")
#   
#   # 作業ディレクトリを変更する
#   os.chdir("/")
#   
#   # 作業ディレクトリを取得する
#   cwd = os.getcwd()
