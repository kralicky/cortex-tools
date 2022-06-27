module github.com/grafana/cortex-tools

go 1.16

require (
	github.com/cortexproject/cortex v1.13.0-rc.0
	github.com/go-kit/kit v0.12.0
	github.com/golang/snappy v0.0.4
	github.com/google/go-github/v32 v32.1.0
	github.com/opentracing-contrib/go-stdlib v1.0.0
	github.com/pkg/errors v0.9.1
	github.com/prometheus/client_golang v1.12.1
	github.com/prometheus/common v0.33.0
	github.com/prometheus/prometheus v1.8.2-0.20220411232225-ce6a643ee88f
	github.com/sirupsen/logrus v1.8.1
	github.com/stretchr/testify v1.7.1
	github.com/thanos-io/thanos v0.22.0
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c
	gopkg.in/yaml.v2 v2.4.0
)

// Override since git.apache.org is down.  The docs say to fetch from github.
replace git.apache.org/thrift.git => github.com/apache/thrift v0.0.0-20180902110319-2566ecd5d999

replace k8s.io/client-go => k8s.io/client-go v0.21.3

replace k8s.io/api => k8s.io/api v0.21.3

// Use fork of gocql that has gokit logs and Prometheus metrics.
replace github.com/gocql/gocql => github.com/grafana/gocql v0.0.0-20200605141915-ba5dc39ece85

// Using a 3rd-party branch for custom dialer - see https://github.com/bradfitz/gomemcache/pull/86
replace github.com/bradfitz/gomemcache => github.com/themihai/gomemcache v0.0.0-20180902122335-24332e2d58ab

// We only pin this version to avoid problems with running go get: github.com/thanos-io/thanos@main. That
// currently fails because Thanos isn't merging release branches to main branch, and Go modules system is then
// confused about which version is the latest one. v0.22.0 was released in July, but latest tag reachable from main
// is v0.19.1. We pin version from early December here. Feel free to remove when updating to later version.
replace github.com/thanos-io/thanos v0.22.0 => github.com/thanos-io/thanos v0.19.1-0.20211208205607-d1acaea2a11a

// Replace memberlist with Grafana's fork which includes some fixes that haven't been merged upstream yet
replace github.com/hashicorp/memberlist => github.com/grafana/memberlist v0.2.5-0.20211201083710-c7bc8e9df94b
