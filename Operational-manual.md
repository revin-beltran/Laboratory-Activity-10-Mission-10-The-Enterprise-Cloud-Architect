# **OPERATIONAL MANUAL**
## 1. Architecture and Data Flow
The Windows computer acts as the physical host. Oracle VM VirtualBox runs the Ubuntu Server guest VM. Docker Engine operates inside Ubuntu Server, and Docker Compose manages two application containers: WordPress and MariaDB. WordPress serves the web application and communicates with MariaDB over an internal Docker network.

```
WINDOWS HOST (Browser: http://8081)
       │
       ▼
ORACLE VM VIRTUALBOX (NAT + Port Forwarding 8081 -> 80)
       │
       ▼
UBUNTU SERVER VM (Guest IP: 10.0.2.15)
       │
       ▼
DOCKER ENGINE + DOCKER COMPOSE (/opt/ccm101-cloud)
       ├── WordPress container (ccm101-cloud-wordpress-1)
       └── MariaDB 11.4 container (ccm101-cloud-db-1)
```

## 2. Ubuntu Server and Docker Environment
Verify system versions and systemd service health using the following terminal commands:

```
sudo apt update
docker --version
docker compose version
sudo systemctl status docker --no-pager
```

## 3. Deploying the WordPress and MariaDB Stack
Navigate to /opt/ccm101-cloud to manage the deployment:

```
cd /opt/ccm101-cloud
sudo docker compose up -d
sudo docker compose ps
``` 

## 4. Accessing WordPress
Open the application on the host browser using http://8081
			 
## 5. Container Operations and Logs
Inspect application state and resource usage:

```
cd /opt/ccm101-cloud
sudo docker compose ps
``` 
	
## 6. Persistent Storage
Database files persist inside ccm101-cloud_db_data. Inspect volumes and mounts with:

```
sudo docker volume ls
sudo docker volume inspect ccm101-cloud_db_data
sudo docker inspect ccm101-cloud-wordpress-1 --format '{{json .Mounts}}'
sudo docker inspect ccm101-cloud-db-1 --format '{{json .Mounts}}'
```

## 7. Firewall and Security
Uncomplicated Firewall (UFW) active rules:

```
sudo ufw status verbose
```
				 
Configuration commands:

```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 8081/tcp
sudo ufw enable
```

## 8. Automated Backups
Automated backups are executed by /opt/ccm101-cloud/auto-backup.sh and saved to /opt/ccm101-cloud/backups.

```
cd /opt/ccm101-cloud
sudo ls -lh backups/
sudo bash auto-backup.sh
```
 
## 9. Cron Scheduling
Backups run automatically every day at 02:00 AM:

```
0 2 * * * /bin/bash /opt/ccm101-cloud/auto-backup.sh >> /opt/ccm101-cloud/backup.log 2>&1
```

## 10. Monitoring and Health Checks
Execute health checks and check system resources:

```
cd /opt/ccm101-cloud
sudo docker compose ps
sudo docker stats --no-stream
df -h
free -h
```
 
## 11. Troubleshooting Guide

<table>
  <thead>
    <tr>
      <th align="left">Problem</th>
      <th align="left">Suggested Action</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>WordPress page unavailable</td>
      <td>Run sudo docker compose ps, check port 8081 mapping, verify VirtualBox NAT port forwarding.</td>
    </tr>
    <tr>
      <td>MariaDB container unhealthy</td>
      <td>Run sudo docker compose logs --tail=100 db. Verify volume mount ccm101-cloud_db_data.</td>
    </tr>
    <tr>
      <td>Port 8081 conflict</td>
      <td>Identify listening process: sudo ss -ltnp | grep ':8081'.</td>
    </tr>
    <tr>
      <td>Backup file empty (0 bytes)</td>
      <td>Inspect /opt/ccm101-cloud/backup.log and verify free disk space (df -h).</td>
    </tr>
  </tbody>
</table>
