#!/bin/bash
# ====================================
# 一键拉取、赋权、执行、保存端口跳跃规则
# 作者: ChatGPT
# ====================================

# 拉取最新脚本
curl -O -L https://raw.githubusercontent.com/<your-github>/port-jump/main/port_jump.sh

# 赋予执行权限
chmod +x port_jump.sh

# 执行脚本
sudo ./port_jump.sh

echo "[+] 执行完成！端口跳跃规则已生效并保存"
