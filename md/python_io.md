# Python IO

## import os


### カレントディレクトリに対しての操作

基本作業はカレントディレクトリになるので、カレントディレクトリの取得とディレクトリ変更は以降の学習にマスト。

**カレントディレクトリの取得**

	$ python
	Python 2.7.5 (default, Mar  9 2014, 22:15:05) 
	[GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
	Type "help", "copyright", "credits" or "license" for more information.
	>>> import os
	>>> os.getcwd()
	'/home/user1'

**カレントディレクトリ変更**

	os.chdir("./python")
	os.getcwd()
	'/home/user1/python'

**カレントディレクトリのファイル一覧表示**

	>>> os.listdir("./")
	['hello.py', 'test.py']

### ファイル操作

**ファイルを開く（オープンする）**

以下のファイルのオープンは一般的な記述方法。他の言語でもよく使われる。

	#!/usr/bin/env python

	f = open('text.txt', 'r')

	for line in f:
    	print line,
    
	f.close()

以下は簡易的な記述方法。ファイルを `close()` するのは Python の garbage collector。

	#!/usr/bin/env python
	
	for line in open('text.txt', 'r'):
    	print line

**ファイルを読む**

$ python
Python 2.7.5 (default, Mar  9 2014, 22:15:05) 
[GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import os
>>> f = open("a.txt")
>>> str = f.read()
>>> str
'asfasdf\nasfasdf\nasfasdf\nasfasdf\nasfasdf\nasfasdf\nasfasdf\nasfasdf\nasfasdf\nasfasdf\nasfasdf\n'


	
	