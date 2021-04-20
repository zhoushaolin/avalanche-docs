# 运行Avalanche节点监测

感谢社区成员Jovica Popović编写了此教程。如有需要，您可以通过我们的[_Discord_](https://chat.avax.network)来联系他。

## 简介

本教程的前提是您在节点上运行了Ubuntu 18.04或20.04\( 本教程的Mac OS X版本即将发布\)。

本教程会展示如何设置基础设施以监测[AvalancheGo](https://github.com/ava-labs/avalanchego)的实例。我们将使用：

* [Prometheus](https://prometheus.io/)收集和储存数据
* [node\_exporter](https://github.com/prometheus/node_exporter) 获取计算机相关信息
* AvalancheGo’s [metrics API](https://docs.avax.network/build/avalanchego-apis/metrics-api) 获取节点相关信息
* [Grafana](https://grafana.com/) 可视化仪表板上的数据。

先决条件：

* 一个运行中的AvalancheGo节点
* 运行节点的计算机的外壳访问
* 计算机的管理员特权

### **警告：安全性**

此处所述系统**不应**向公共互联网开放。如图所示，Prometheus和Grafana均严禁未经允许的访问。请确保这只能通过安全代理、本地网络或VPN访问。本教程不包括其设置，但操作时要谨慎。如果安全操作有问题，则可能使攻击者获得对您节点的控制权！您自行负责遵循适当的安全做法。

### 贡献

Grafana指示板的基础取自[ColmenaLabs](https://blog.colmenalabs.org/index.html)的优秀人士，目前已不可用。如果您对改进本教程有任何想法和建议，请在[Github](https://github.com/ava-labs)上进行说明、发布问题或发出请求。

## 设置Prometheus

首先，我们需要添加一个系统用户账号并创建目录\(您会需要超级用户凭据\)：

```cpp
sudo useradd -M -r -s /bin/false prometheus
```

```cpp
sudo mkdir /etc/prometheus /var/lib/prometheus
```

获取必要的实用程序，以防它们还没有安装:

```cpp
sudo apt-get install -y apt-transport-https
```

```cpp
sudo apt-get install -y software-properties-common wget
```

下一步，从[downloads page](https://prometheus.io/download/)获取Prometheus最新版本, (请确保您选择了合适的处理器架构\)，使用wget下载并使用tar对存档进行解压：

```cpp
mkdir -p /tmp/prometheus && cd /tmp/prometheus
```

```cpp
wget https://github.com/prometheus/prometheus/releases/download/v2.25.0/prometheus-2.25.0.linux-amd64.tar.gz
```

```cpp
tar xvf prometheus-2.25.0.linux-amd64.tar.gz
```

```cpp
cd prometheus-2.25.0.linux-amd64
```

下一步，我们需要移动二进制文件，设置所有权，并将配置文件移动到适当位置：

```cpp
sudo cp {prometheus,promtool} /usr/local/bin/
```

```cpp
sudo chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
```

```cpp
sudo chown -R prometheus:prometheus /etc/prometheus
```

```cpp
sudo chown prometheus:prometheus /var/lib/prometheus
```

```cpp
sudo cp -r {consoles,console_libraries} /etc/prometheus/
```

```cpp
sudo cp prometheus.yml /etc/prometheus/
```

`/etc/prometheus` 是用于配置,  而`/var/lib/prometheus` 是用于数据。

请对Prometheus进行设置，以将之作为系统服务运行。执行:
```cpp
sudo nano /etc/systemd/system/prometheus.service
```

\(或在您选择的文本编辑器中打开该文件\)，并输入以下配置：

```cpp
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/prometheus   --config.file=/etc/prometheus/prometheus.yml   --storage.tsdb.path=/var/lib/prometheus   --web.console.templates=/etc/prometheus/consoles   --web.console.libraries=/etc/prometheus/console_libraries   --web.listen-address=0.0.0.0:9090   --web.external-url=

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
```

保存文件。现在，我们可以将Prometheus作为系统服务运行：

```cpp
sudo systemctl daemon-reload
```

```cpp
sudo systemctl start prometheus
```

```cpp
sudo systemctl enable prometheus
```

Prometheus当前应正在运行中。如需确认，我们可以进行检查：

```cpp
sudo systemctl status prometheus
```

应生成如下结果：

```cpp
● prometheus.service - Prometheus
     Loaded: loaded (/etc/systemd/system/prometheus.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2020-04-01 19:23:53 CEST; 5 months 12 days ago
       Docs: https://prometheus.io/docs/introduction/overview/
   Main PID: 1767 (prometheus)
      Tasks: 12 (limit: 9255)
     CGroup: /system.slice/prometheus.service
             └─1767 /usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus --web.console.templa>

Sep 13 13:00:04 ubuntu prometheus[1767]: level=info ts=2020-09-13T11:00:04.744Z caller=head.go:792 component=tsdb msg="Head GC completed" duration=13.6>
Sep 13 13:00:05 ubuntu prometheus[1767]: level=info ts=2020-09-13T11:00:05.263Z caller=head.go:869 component=tsdb msg="WAL checkpoint complete" first=9>
Sep 13 15:00:04 ubuntu prometheus[1767]: level=info ts=2020-09-13T13:00:04.776Z caller=compact.go:495 component=tsdb msg="write block" mint=15999912000>
...
```

您还可以在`http://your-node-host-ip:9090/`检查Prometheus网络界面

如果防火墙处于**.**状态，则您可能需要执行`sudo ufw allow 9090/tcp`

## 安装Grafana

使用Ubuntu来设置Grafana项目存储库：

```cpp
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
```

```cpp
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

安装Grafana:

```cpp
sudo apt-get update
```

```cpp
sudo apt-get install grafana
```

将其作为一项服务进行配置：

```cpp
sudo systemctl daemon-reload
```

```cpp
sudo systemctl start grafana-server
```

```cpp
sudo systemctl enable grafana-server.service
```

确认其运行正常：

```text
sudo systemctl status grafana-server
```

grafana应显示`active`。Grafana在`http://your-node-host-ip:3000/`上可用。

如果防火墙处于**.**状态，则您可能需要执行`sudo ufw allow 3000/tcp`

使用用户名/管理员密码/管理员进行登录，并设置一个新的安全密码。现在，我们需要将Grafana连接到我们的数据源Prometheus。

在Grafana的网络界面上：

* 转到左侧菜单上的配置并选择数据源。
* 点击添加数据源。
* 选择Prometheus。
* 在表格中输入姓名\(Prometheus会进行\)，将`http://localhost:9090`作为URL。
* 点击`Save & Test`
* 查看 “数据源正在工作” 的绿色信息。

## 设置节点\_输出点

除了AvalancheGo的指标以外，让我们再设置计算机本身的监测，因此我们可以检查CPU、内存、网络和磁盘使用情况，并了解任何异常情况。为此，我们会使用节点\_输出点，即Prometheus插件。

获取最新版本：

```text
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep browser_download_url | grep linux-amd64 |  cut -d '"' -f 4 | wget -qi -
```

如果您有不同的架构（例如，RaspberryPi是`linux-arm64`），请更改`linux-amd64` 。解压并移动可执行文件。

```cpp
tar xvf node_exporter-1.1.2.linux-amd64.tar.gz
```

```cpp
sudo mv node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin
```

确认已正确安装:

```cpp
node_exporter --version
```

然后我们将节点\_输出点添加为一项服务。请执行：

```cpp
sudo nano /etc/systemd/system/node_exporter.service
```

\(或在您选择的文本编辑器中打开该文件\)并将其填满：

```cpp
[Unit]
Description=Prometheus Node Exporter
Documentation=https://github.com/prometheus/node_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/node_exporter \
    --collector.cpu \
    --collector.diskstats \
    --collector.filesystem \
    --collector.loadavg \
    --collector.meminfo \
    --collector.filefd \
    --collector.netdev \
    --collector.stat \
    --collector.netstat \
    --collector.systemd \
    --collector.uname \
    --collector.vmstat \
    --collector.time \
    --collector.mdadm \
    --collector.zfs \
    --collector.tcpstat \
    --collector.bonding \
    --collector.hwmon \
    --collector.arp \
    --web.listen-address=:9100 \
    --web.telemetry-path="/metrics"

[Install]
WantedBy=multi-user.target
```

这配置了节点\_输出点，以收集我们可能感兴趣的各种数据。开启服务，并在启动时启用它：

```cpp
sudo systemctl start node_exporter
```

```cpp
sudo systemctl enable node_exporter
```

我们需要再一次确认服务正确运行:

```cpp
sudo systemctl status node_exporter
```

如果您看到`Ignoring unknown escape sequences`之类的消息，请再三检查服务文件的内容是否被正确复制，是否存在额外的反斜杠或额外的换行符。如有必要，纠正并重新启动服务。

目前，我们可以把他们连接起来了。

## 配置AvalancheGo和节点\_输出点Prometheus

请确保您的AvalancheGo节点正在与[command line arguments](../../references/command-line-interface.md)一同运行。指标API必须启用\(默认情况下\)。如果您使用CLI参数“-http host”从主机外部进行API调用，请记下API侦听的地址。

现在我们需要定义一项合适的Prometheus任务。让我们编辑Prometheus配置：

请执行:

```cpp
sudo nano /etc/prometheus/prometheus.yml
```

\(或在您选择的文本编辑器中打开该文件\)并附加在结尾：

```cpp
  - job_name: 'avalanchego'
    metrics_path: '/ext/metrics'
    static_configs:
      - targets: ['<your-host-ip>:9650']

  - job_name: 'avalanchego-machine'
    static_configs:
      - targets: ['<your-host-ip>:9100']
        labels:
          alias: 'machine'
```

**缩进很重要**。请确保`-job_name`与现有`-job_name`对齐，其他行也适当缩进。基于您的节点配置方式，请确保您使用了正确的主机IP，或本地服务器`localhost`。

保存配置文件并重启Prometheus：

```cpp
sudo systemctl restart prometheus
```

在`http://your-node-host-ip:9090/targets`上检查Prometheus网络界面。您会看到启用的三个目标：

* Prometheus
* avalanchego
* avalanchego-machine

请确保他们的状态`State`都是`UP`。

打开Grafana；您现在可以使用任意上述来源创建指示板。您还可以使用[the preconfigured dashboards](https://github.com/ava-labs/avalanche-docs/tree/c65ea53488738b0b624a53382fe89ac5e02597ca/dashboards/README.md)。

如需导入预配置指示板：

* 打开Grafana的网络界面
* 点击左侧工具栏上的“`+` 
* 选择`Import JSON`，然后上传JSON文件, 或者在`Import via panel json`区域粘贴文件内容。
* 选择`Prometheus`作为数据源

就是这样！现在您可能震惊于节点的万能。哇哦！


<!--stackedit_data:
eyJoaXN0b3J5IjpbODE3NzUyNjIsLTE0NTE1MDk1NzcsODcwNj
E4MjM3LDEzMjA1NzkzMjhdfQ==
-->