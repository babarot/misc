package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
	"time"
)

const (
	DAEMON_START = 1 + iota
	DAEMON_SUCCESS
	DAEMON_FAIL
)

func main() {
	var child *bool = flag.Bool("child", false, "Run as a child process")
	flag.Parse()

	if !*child {
		// parent
		if err := parentMain(); err != nil {
			log.Fatalf("Error occurred [%v]", err)
			os.Exit(1)
		} else {
			os.Exit(0)
		}

	} else {
		// child
		childMain()
	}
}

func parentMain() (err error) {
	args := []string{"--child"}
	args = append(args, os.Args[1:]...)

	// 子プロセスとのパイプを作っておく
	r, w, err := os.Pipe()
	if err != nil {
		return err
	}

	cmd := exec.Command(os.Args[0], args...)
	cmd.ExtraFiles = []*os.File{w}
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	if err = cmd.Start(); err != nil {
		return err
	}

	// パイプから子プロセスの起動状態を取得する
	var status int = DAEMON_START
	go func() {
		buf := make([]byte, 1)
		r.Read(buf)

		if int(buf[0]) == DAEMON_SUCCESS {
			status = int(buf[0])
		} else {
			status = DAEMON_FAIL
		}
	}()

	// 子プロセスの起動を30秒待つ
	i := 0
	for i < 60 {
		if status != DAEMON_START {
			break
		}
		time.Sleep(500 * time.Millisecond)
		i++
	}

	// 親プロセス終了
	if status == DAEMON_SUCCESS {
		return nil
	} else {
		return fmt.Errorf("Child failed to start")
	}
}

func childMain() {
	// 初期化処理があればここに
	var err error

	// 子プロセスの起動状態を親プロセスに通知する
	pipe := os.NewFile(uintptr(3), "pipe")
	if pipe != nil {
		defer pipe.Close()
		if err == nil {
			pipe.Write([]byte{DAEMON_SUCCESS})
		} else {
			pipe.Write([]byte{DAEMON_FAIL})
		}
	}

	// SIGCHILDを無視する
	signal.Ignore(syscall.SIGCHLD)

	// STDOUT, STDIN, STDERRをクローズ
	syscall.Close(0)
	syscall.Close(1)
	syscall.Close(2)

	// プロセスグループリーダーになる
	syscall.Setsid()

	// Umaskをクリア
	syscall.Umask(022)

	// / にchdirする
	syscall.Chdir("/")

	// main loop
	for {
		time.Sleep(1000 * time.Millisecond)
	}
}
