## 1. Architecture and Data Flow
The Windows computer acts as the physical host. Oracle VM VirtualBox runs the Ubuntu Server guest VM. Docker Engine operates inside Ubuntu Server, and Docker Compose manages two application containers: WordPress and MariaDB. WordPress serves the web application and communicates with MariaDB over an internal Docker network.

```
WINDOWS HOST (Browser: http://127.0.0.1:8080)
       │
       ▼
ORACLE VM VIRTUALBOX (NAT + Port Forwarding 8080 -> 80)
       │
       ▼
UBUNTU SERVER VM (Guest IP: 10.0.2.15)
       │
       ▼
DOCKER ENGINE + DOCKER COMPOSE (/opt/ccm101-cloud)
       ├── WordPress container (ccm101-cloud-wordpress-1)
       └── MariaDB 11.4 container (ccm101-cloud-db-1)
```
3. Ubuntu Server and Docker Environment
Verify system versions and systemd service health using the following terminal commands:
sudo apt update
docker --version
docker compose version
sudo systemctl status docker --no-pager
 

Figure 1. Ubuntu Server login and system information.
Figure 2. Docker Engine, Docker Compose versions, and active systemd status.
3. Deploying the WordPress and MariaDB Stack
Navigate to /opt/ccm101-cloud to manage the deployment:
cd /opt/ccm101-cloud
sudo docker compose up -d
sudo docker compose ps
	
 

Figure 3. Docker Compose service startup output.
Figure 4. Running status showing MariaDB healthy and WordPress port 8080:80.
4. Accessing WordPress
Open the application on the host browser using http://127.0.0.1:8080
			 
Figure 5. Mission 10 WordPress site rendered in browser.
5. Container Operations and Logs
Inspect application state and resource usage:
cd /opt/ccm101-cloud
sudo docker compose ps
 

		
6. Persistent Storage
Database files persist inside ccm101-cloud_db_data. Inspect volumes and mounts with:
sudo docker volume ls
sudo docker volume inspect ccm101-cloud_db_data
sudo docker inspect ccm101-cloud-wordpress-1 --format '{{json .Mounts}}'
sudo docker inspect ccm101-cloud-db-1 --format '{{json .Mounts}}'
 
Figure 6. Docker volume list output.
7. Firewall and Security
Uncomplicated Firewall (UFW) active rules:
sudo ufw status verbose
				 
Configuration commands:
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp
sudo ufw enable
Figure 10. Live UFW firewall status.

8. Automated Backups
Automated backups are executed by /opt/ccm101-cloud/auto-backup.sh and saved to /opt/ccm101-cloud/backups.
cd /opt/ccm101-cloud
sudo ls -lh backups/
sudo bash auto-backup.sh
 
Figure 7. Backup log verifying successful database and web file archiving.
9. Cron Scheduling
Backups run automatically every day at 02:00 AM:
0 2 * * * /bin/bash /opt/ccm101-cloud/auto-backup.sh >> /opt/ccm101-cloud/backup.log 2>&1
Figure 8. Scheduled crontab entry for daily automated backups.
10. Monitoring and Health Checks
Execute health checks and check system resources:
cd /opt/ccm101-cloud
sudo docker compose ps
sudo docker stats --no-stream
df -h
free -h
 
Figure 9. Container health check monitoring output.
11. Troubleshooting Guide
Problem	Suggested Action
WordPress page unavailable	Run sudo docker compose ps, check port 8080 mapping, verify VirtualBox NAT port forwarding.
MariaDB container unhealthy	Run sudo docker compose logs --tail=100 db. Verify volume mount ccm101-cloud_db_data.
Port 8080 conflict	Identify listening process: sudo ss -ltnp | grep ':8080'.
Backup file empty (0 bytes)	Inspect /opt/ccm101-cloud/backup.log and verify free disk space (df -h).
12. Appendix & Requirement Coverage
Requirement Area	Implementation Details	Evidence Included
Base Infrastructure	Ubuntu Server 26.04.1 LTS on Oracle VM VirtualBox	Figure 1 (Login Screen)
Multi-tier Stack	WordPress + MariaDB 11.4 via Docker Compose	Figure 3 & Figure 4
Access & Port Mapping	Web interface on http://127.0.0.1:8080	Figure 5 (Browser View)
Persistent Storage	Named volume ccm101-cloud_db_data	Figure 6 (Volume List)
Security & Firewall	UFW default deny incoming, SSH (22) & HTTP allowed	Figure 10 (UFW Output)
Automation & Backups	auto-backup.sh bash script + Daily 02:00 AM Cron schedule	Figure 7 & Figure 8

