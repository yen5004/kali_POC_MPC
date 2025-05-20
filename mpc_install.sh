#! /bin/bash
# Script used to install and set up a Kali VM with a MPC for use in AI models

# Ensure kali is up to date
sudo apt update -y && sudo apt upgrade -y

#For Kali Linux, install essential pentesting tools:
sudo apt install nmap gobuster dirb nikto sqlmap metasploit-framework hydra john wpscan enum4linux -y

# Clone the MCP repository:
sudo git clone https://github.com/vicorente/kali_mcp.git
cd kali_mcp

# Run the setup script (recommended):
 ./setup.sh

#Alternatively, set it up manually:
# python3 -m venv venv
# source venv/bin/activate
# pip install -r requirements.txt
#chmod +x mcp_server.py kali_api_server.py run.py


# Start MCP Server/Run the MCP server:
./run.py

# You can specify ports if needed:
./run.py --api-port 5000 --mcp-port 8080


# Integrate with White Rabbit Neo or Other Pentesting Models
#     If you're using White Rabbit Neo or another AI model, configure it to communicate with the MCP server. This typically involves:
#     Setting up API endpoints for interaction.
#     Ensuring authentication parameters are correctly configured.
#     Using MCP protocol commands to send requests and receive responses.


# Test and Debug/Verify that the MCP server is running:
curl http://localhost:8080/status

#Check logs for errors:
tail -f logs/mcp_server.log

# Automate and Expand
# You can automate pentesting tasks by integrating MCP with AI-driven security tools. Consider using Docker for sandboxed execution:

docker run -d -p 8080:8080 kali_mcp
