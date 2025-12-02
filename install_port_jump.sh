#!/bin/bash
# ====================================
# 一键拉取、赋权、执行、保存端口跳跃规则
# 作者: ChatGPT
# ====================================
apt-get update && apt-get install -y iptables-persistent

# 拉取最新脚本
curl -O -L https://raw.githubusercontent.com/latonyahigr/hy2/f2ae4b29ce3904e6866b9e43f57ff013d3d0ef4b/port_jump.sh

# 赋予执行权限
chmod +x port_jump.sh

# 执行脚本
sudo ./port_jump.sh

echo "[+] 执行完成！端口跳跃规则已生效并保存"

echo "[+] 脚本已执行，当前 NAT 规则如下:"
iptables -t nat -L -n --line-numbers
