package main

import (
	"os"

	"github.com/Sirupsen/logrus"
)

func main() {
	var log = logrus.New()
	log.Formatter = new(logrus.JSONFormatter)
	log.Level = logrus.DebugLevel
	logf, _ := os.OpenFile("example.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	defer logf.Close()
	log.Out = logf

	log.WithFields(logrus.Fields{
		"animal": "walrus",
		"number": 8,
	}).Debug("Started observing beach")

	log.WithFields(logrus.Fields{
		"animal": "walrus",
		"size":   10,
	}).Info("A group of walrus emerges from the ocean")

	log.WithFields(logrus.Fields{
		"omg":    true,
		"number": 122,
	}).Warn("The group's number increased tremendously!")

	log.WithFields(logrus.Fields{
		"temperature": -4,
	}).Debug("Temperature changes")
}
