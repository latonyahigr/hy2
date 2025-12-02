#!/bin/bash
# ====================================
# 一键拉取、赋权、执行、保存端口跳跃规则
# 作者: ChatGPT
# ====================================

# 安装依赖
apt-get update && apt-get install -y iptables-persistent curl

# 拉取最新脚本
curl -O -L https://raw.githubusercontent.com/latonyahigr/hy2/main/port_jump.sh

# 赋予执行权限
chmod +x port_jump.sh

# 执行脚本
./port_jump.sh

# 保存规则到 /etc/iptables/rules.v4
iptables-save > /etc/iptables/rules.v4

echo "[+] 执行完成！端口跳跃规则已生效并保存"

# 显示当前 NAT 规则
iptables -t nat -L -n --line-numbers
