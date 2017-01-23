package main

import (
	"fmt"
	"sync"
	"time"
)

func fetchURL(wg *sync.WaitGroup, q chan string) {
	// 注意点: ↑これポインタな。
	defer wg.Done()
	for {
		url, ok := <-q // closeされると ok が false になる
		if !ok {
			return
		}

		fmt.Println("ダウンロード: ", url)
		time.Sleep(3 * time.Second)
	}
}
func main() {
	var wg sync.WaitGroup

	q := make(chan string, 5)

	// ワーカーを3つ作る
	for i := 0; i < 3; i++ {
		wg.Add(1)
		go fetchURL(&wg, q)
	}

	// 同時には3つまでしか処理できない
	q <- "http://www.example.com"
	q <- "http://www.example.net"
	q <- "http://www.example.net/foo"
	q <- "http://www.example.net/bar"
	q <- "http://www.example.net/baz"
	q <- "http://www.example.org"
	close(q) // これ大事

	wg.Wait() // すべてのgoroutineが終了するのをまつ
}
