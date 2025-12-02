#!/bin/bash
# ===============================
# 一键安装端口跳跃脚本（最终版）
# 支持 TCP/UDP，开机自启+定时刷新
# 作者: ChatGPT
# ===============================

PORT_JUMP_SCRIPT="/root/port_jump.sh"
SERVICE_FILE="/etc/systemd/system/port_jump.service"
TIMER_FILE="/etc/systemd/system/port_jump.timer"

echo "[*] 创建端口跳跃脚本: $PORT_JUMP_SCRIPT"

cat > "$PORT_JUMP_SCRIPT" <<'EOF'
#!/bin/bash
# 自动端口跳跃脚本（支持定时刷新）

RULES=(
  "101-1500:100"
  "1502-3000:1501"
  "3002-4500:3001"
  "4502-6000:4501"
  "6002-7500:6001"
)

# 清空旧规则（谨慎使用）
iptables -t nat -F

for rule in "${RULES[@]}"; do
  RANGE="${rule%%:*}"
  TARGET="${rule##*:}"
  START=${RANGE%-*}
  END=${RANGE#*-}

  # TCP 端口跳跃
  iptables -t nat -A PREROUTING -p tcp --dport ${START}:${END} -j REDIRECT --to-port ${TARGET}
  # UDP 端口跳跃
  iptables -t nat -A PREROUTING -p udp --dport ${START}:${END} -j REDIRECT --to-port ${TARGET}
done
EOF

chmod +x "$PORT_JUMP_SCRIPT"

echo "[*] 创建 systemd 服务: $SERVICE_FILE"
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Port Jump Service
After=network.target

[Service]
Type=oneshot
ExecStart=$PORT_JUMP_SCRIPT
RemainAfterExit=yes
EOF

echo "[*] 创建 systemd 定时器: $TIMER_FILE"
cat > "$TIMER_FILE" <<EOF
[Unit]
Description=Run Port Jump Script every 5 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
EOF

echo "[*] 重新加载 systemd 并启动服务与定时器..."
systemctl daemon-reload
systemctl start port_jump.service
systemctl enable port_jump.service
systemctl start port_jump.timer
systemctl enable port_jump.timer

echo "[+] 安装完成！"
echo "[*] 查看服务状态: systemctl status port_jump.service"
echo "[*] 查看定时器: systemctl list-timers | grep port_jump"
