package commands

import (
	"net/url"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/push"
	"github.com/sirupsen/logrus"
	"gopkg.in/alecthomas/kingpin.v2"
)

// PushGatewayConfig configures the pushgateway
type PushGatewayConfig struct {
	Endpoint *url.URL
	JobName  string
	Interval time.Duration

	pusher     *push.Pusher
	done       chan struct{}
	terminated chan struct{}
}

// Register configures log related flags
func (l *PushGatewayConfig) Register(app *kingpin.Application) {
	app.PreAction(l.setup)
	app.Flag("push-gateway.endpoint", "url for the push-gateway to register metrics").URLVar(&l.Endpoint)
	app.Flag("push-gateway.job", "job name to register metrics").StringVar(&l.JobName)
	app.Flag("push-gateway.interval", "interval to forward metrics to the push gateway").Default("1m").DurationVar(&l.Interval)
}

func (l *PushGatewayConfig) setup(pc *kingpin.ParseContext) error {
	if l.Endpoint == nil || l.JobName == "" {
		logrus.Infoln("push-gateway not configured")
		return nil
	}

	logrus.WithFields(logrus.Fields{
		"endpoint": l.Endpoint,
		"job_name": l.JobName,
		"interval": l.Interval.String(),
	}).Infoln("push-gateway enabled")

	l.pusher = push.New(l.Endpoint.String(), l.JobName).Gatherer(prometheus.DefaultGatherer)
	err := l.pusher.Push()
	if err != nil {
		logrus.WithError(err).Errorln("unable to forward metrics to pushgateway")
	}

	go l.push()

	return nil
}

func (l *PushGatewayConfig) push() {
	timer := time.NewTicker(l.Interval)
	defer timer.Stop()
	defer close(l.terminated)

	for {
		select {
		case <-l.done:
			return
		case <-timer.C:
			err := l.pusher.Add()
			logrus.WithError(err).Errorln("unable to forward metrics to pushgateway")
		}
	}
}

// Stop shutsdown the pushgateway
func (l *PushGatewayConfig) Stop() {
	close(l.done)
	<-l.terminated
}