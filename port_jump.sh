#!/bin/bash
# ====================================
# 固定端口跳跃脚本
# TCP/UDP，直接生效并保存规则
# 作者: ChatGPT
# ====================================

# 定义端口映射 (固定不变)
RULES=(
  "101-1500:100"
  "1502-3000:1501"
  "3002-4500:3001"
  "4502-6000:4501"
  "6002-7500:6001"
)

# 清空 nat 表 PREROUTING
iptables -t nat -F

# 应用规则
for rule in "${RULES[@]}"; do
  RANGE="${rule%%:*}"
  TARGET="${rule##*:}"

  iptables -t nat -A PREROUTING -p tcp --dport ${RANGE} -j REDIRECT --to-port ${TARGET}
  iptables -t nat -A PREROUTING -p udp --dport ${RANGE} -j REDIRECT --to-port ${TARGET}
done

# 保存规则
if command -v iptables-save >/dev/null 2>&1; then
  iptables-save > /etc/iptables/rules.v4
fi

echo "[+] 端口跳跃规则已应用并保存"
iptables -t nat -L -n --line-numbers
