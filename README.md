# 3DMAX - Logging

## Components

This logging stack implements:

- Grafana (For dashboards, acts as the main interface)
- Rabbitmq with mqtt enabled as an MQTT message broker
- Prometheus as a time-series database
- mqtt2prometheus as a bridge between mqtt and Prometheus

By default it will monitor the host machine and the docker containers running on it.
Metrics from the mqqt broker are also collected, and presented in Grafana.

## Exposed Ports

The following table presents the exposed port of Machine Metrics Monitoring.

| Port    | Description                          |
| ------- | ------------------------------------ |
| `22`    | SSH tcp port.                        |
| `80`    | HTTP tcp port of Grafana dashboards. |
| `1883`  | MQTT tcp port.                       |
| `15672` | Rabbitmq admin page                  |
| `15692` | Rabbitmq prometheus metrics          |

## Installation

The logging stack is meant to be installed on a Ubuntu device, this can be a physical machine or a machine hosted in a cloud environment.

Installing the stack is simplified by using ansible, in this way just running a single command will install the stack on the device.

To be able to do this, you will need to have a control node, which is a machine that will be used to run the ansible scripts. This is also a Ubuntu machine, but it can be hosted in a WSL2 environment on a Windows machine.

To setup the Logging stack on an Ubuntu device, follow these
steps.

1. [Setup a control node (installer machine)][setup-control-node]
1. [Install stack][install-stack]

[setup-control-node]: docs/setup-a-control-node.md
[install-stack]: docs/install-stack.md

## Configuration

The configuration of the logging stack is done by editing the `configuration.yml` file. This file is located in the root of the repository.

The configuration file contains all the common settings and options that can be customized in the Machine Metrics Monitoring stack. Uncomment any settings and change their values.

To configure the rabbitmq server, edit the `rabbitmq.config` file. This file is located in the `rabbitmq` directory ansible\roles\rabbitmq.

### Configuration file overview:

#### System settings

This section is used for the timezone settings.

#### prometheus_scrape_configs

Here automatic scrape configurations can be added. These are used to scrape metrics from other services. (Like status of PC, or other services)

The scrape config : - job_name: "rabbitmq_3dmax" will scrape the rabbitmq server metrics.

#### MQTT settings

This section is used to set the connection settings for the mqtt broker.

#### mqtt2prometheus

Here you can define the MQTT topic and specific channels to be stored in prometheus.

info : https://github.com/hikhvar/mqtt2prometheus

mqtt2prometheus_topic_path: The MQTT topic to subscribe to.

mqtt2prometheus_metrics:

- prom_name: Value_1 (How the metric will be named in prometheus)
  mqtt_name: Value_1 (The name of the metric in the MQTT message)
  help: Description (A description of the metric)
  type: gauge (The type of the metric: gauge or counter)

This can be a list of metrics.

mqtt2prometheus will check the MQTT topic for messages with the specified channels, and store the values in prometheus. In the json 1 or more metrics can be present, not all of them need to be in the message.

Example of a mqtt message:

```json
{
  "Value_1": 10,
  "Value_2": 20
}
```
