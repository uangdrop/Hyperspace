#!/bin/bash

# Infinite loop to keep retrying the script if any part fails
while true; do
    printf "\n"
    cat <<EOF


██╗░░██╗░█████╗░██████╗░██╗  ██╗░░██╗██╗████████╗░█████╗░███╗░░░███╗
██║░██╔╝██╔══██╗██╔══██╗██║  ██║░░██║██║╚══██╔══╝██╔══██╗████╗░████║
█████═╝░██║░░██║██████╔╝██║  ███████║██║░░░██║░░░███████║██╔████╔██║
██╔═██╗░██║░░██║██╔═══╝░██║  ██╔══██║██║░░░██║░░░██╔══██║██║╚██╔╝██║
██║░╚██╗╚█████╔╝██║░░░░░██║  ██║░░██║██║░░░██║░░░██║░░██║██║░╚═╝░██║
╚═╝░░╚═╝░╚════╝░╚═╝░░░░░╚═╝  ╚═╝░░╚═╝╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝



EOF

    printf "\n\n"

    # GA CRYPTO Banner
    GREEN="\033[0;32m"
    RESET="\033[0m"
    printf "${GREEN}"
    printf "Stay connected for updates:\n"
    printf "   • Telegram: https://t.me/uangdrop\n"
    printf "   • X (formerly Twitter): https://x.com/uangdrop\n"
    printf "${RESET}"

    # Step 1: Install HyperSpace CLI
    echo "🚀 Installing HyperSpace CLI..."

    while true; do
        curl -s https://download.hyper.space/api/install | bash | tee /root/hyperspace_install.log

        if ! grep -q "Failed to parse version from release data." /root/hyperspace_install.log; then
            echo "✅ HyperSpace CLI installed successfully!"
            break
        else
            echo "❌ Installation failed. Retrying in 10 seconds..."
            sleep 5
        fi
    done

    # Step 2: Add aios-cli to PATH and persist it
    echo "🔄 Adding aios-cli path to .bashrc..."
    echo 'export PATH=$PATH:$HOME/.aios' >> ~/.bashrc
    export PATH=$PATH:$HOME/.aios
    source ~/.bashrc

    # Step 3: Start the Hyperspace node in a screen session
    echo "🚀 Starting the Hyperspace node in the background..."
    screen -S hyperspace -d -m bash -c "$HOME/.aios/aios-cli start"

    # Step 4: Wait for node startup
    echo "⏳ Waiting for the Hyperspace node to start..."
    sleep 10

    # Step 5: Check if aios-cli is available
    echo "🔍 Checking if aios-cli is installed..."
    if ! command -v aios-cli &> /dev/null; then
        echo "❌ aios-cli not found. Retrying..."
        continue
    fi

    # Step 6: Check node status
    echo "🔍 Checking node status..."
    aios-cli status

    # Step 7: Download the required model
    echo "🔄 Downloading the required model..."

    while true; do
        aios-cli models add hf:second-state/Qwen1.5-1.8B-Chat-GGUF:Qwen1.5-1.8B-Chat-Q4_K_M.gguf | tee /root/model_download.log

        if grep -q "Download complete" /root/model_download.log; then
            echo "✅ Model downloaded successfully!"
            break
        else
            echo "❌ Model download failed. Retrying in 10 seconds..."
            sleep 5
        fi
    done

    # Step 8: Ask for private key securely
    echo "🔑 Enter your private key:"
    read -p "Private Key: " private_key
    echo $private_key > /root/my.pem
    echo "✅ Private key saved to /root/my.pem"

    # Step 9: Import private key
    echo "🔑 Importing your private key..."
    aios-cli hive import-keys /root/my.pem

    # Step 10: Login to Hive
    echo "🔐 Logging into Hive..."
    aios-cli hive login

    # Step 11: Connect to Hive
    echo "🌐 Connecting to Hive..."
    aios-cli hive connect

    # Step 12: Display system info
    echo "🖥️ Fetching system information..."
    aios-cli system-info

    # Step 13: Set Hive Tier
    echo "🏆 Setting your Hive tier to 3..."
    aios-cli hive select-tier 3 

    # Step 14: Check Hive points in a loop every 10 seconds
    echo "📊 Checking your Hive points every 10 seconds..."
    echo "✅ HyperSpace Node setup complete!"
    echo "ℹ️ Use 'CTRL + A + D' to detach the screen and 'screen -r gaspace' to reattach."

    while true; do
        echo "ℹ️ Press 'CTRL + A + D' to detach the screen, 'screen -r gaspace' to reattach."
        aios-cli hive points
        sleep 10
    done

done