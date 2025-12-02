#!/bin/bash
# ====================================
# HY2 端口跳跃脚本 - Debian 12 nf_tables 兼容
# 作者: ChatGPT
# ====================================

# 清空旧的 NAT 规则
echo "[*] 清空旧的 NAT 规则..."
iptables -t nat -F

# 端口跳跃规则
declare -A PORT_RANGES=(
    ["101:1500"]=100
    ["1502:3000"]=1501
    ["3002:4500"]=3001
    ["4502:6000"]=4501
    ["6002:7500"]=6001
)

# 应用端口跳跃规则
echo "[*] 应用端口跳跃规则..."
for range in "${!PORT_RANGES[@]}"; do
    target_port=${PORT_RANGES[$range]}
    echo "[*] $range -> $target_port"
    iptables -t nat -A PREROUTING -p tcp -m multiport --dports $range -j REDIRECT --to-port $target_port
done

# 保存规则
echo "[*] 保存 NAT 规则..."
netfilter-persistent save

echo "[+] 端口跳跃规则已应用并保存"
echo "[+] 当前 NAT 表规则如下:"
iptables -t nat -L -n --line-numbers
