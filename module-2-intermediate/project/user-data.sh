#!/bin/bash
# User data script for EC2 instance
# This script runs when the instance first launches

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Create a simple web page
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform EC2 Demo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 800px;
            width: 100%;
        }
        h1 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 2.5em;
        }
        .emoji {
            font-size: 3em;
            margin-bottom: 20px;
        }
        p {
            color: #333;
            line-height: 1.6;
            margin-bottom: 20px;
            font-size: 1.1em;
        }
        .info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .info-item {
            margin: 10px 0;
            padding: 8px;
            background: rgba(255,255,255,0.1);
            border-radius: 5px;
        }
        .info-item strong {
            display: inline-block;
            width: 180px;
        }
        .success {
            color: #10b981;
            font-weight: bold;
            font-size: 1.2em;
            margin-top: 20px;
        }
        .badge {
            display: inline-block;
            background: #10b981;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="emoji">🚀</div>
        <h1>Terraform EC2 Web Server</h1>
        <p>This web server was automatically deployed using <strong>Terraform</strong> and AWS!</p>
        
        <div class="info">
            <h2 style="margin-bottom: 15px;">Instance Information</h2>
            <div class="info-item">
                <strong>Instance ID:</strong>
                <span id="instance-id">Loading...</span>
            </div>
            <div class="info-item">
                <strong>Instance Type:</strong>
                <span id="instance-type">Loading...</span>
            </div>
            <div class="info-item">
                <strong>Availability Zone:</strong>
                <span id="az">Loading...</span>
            </div>
            <div class="info-item">
                <strong>Public IP:</strong>
                <span id="public-ip">Loading...</span>
            </div>
            <div class="info-item">
                <strong>Region:</strong>
                <span id="region">Loading...</span>
            </div>
        </div>
        
        <p class="success">✅ Infrastructure as Code works perfectly!</p>
        <span class="badge">Deployed with Terraform</span>
    </div>

    <script>
        // Fetch instance metadata
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(r => r.text())
            .then(data => document.getElementById('instance-id').textContent = data)
            .catch(() => document.getElementById('instance-id').textContent = 'N/A');

        fetch('http://169.254.169.254/latest/meta-data/instance-type')
            .then(r => r.text())
            .then(data => document.getElementById('instance-type').textContent = data)
            .catch(() => document.getElementById('instance-type').textContent = 'N/A');

        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(r => r.text())
            .then(data => {
                document.getElementById('az').textContent = data;
                document.getElementById('region').textContent = data.slice(0, -1);
            })
            .catch(() => {
                document.getElementById('az').textContent = 'N/A';
                document.getElementById('region').textContent = 'N/A';
            });

        fetch('http://169.254.169.254/latest/meta-data/public-ipv4')
            .then(r => r.text())
            .then(data => document.getElementById('public-ip').textContent = data)
            .catch(() => document.getElementById('public-ip').textContent = 'N/A');
    </script>
</body>
</html>
EOF

# Start Apache and enable on boot
systemctl start httpd
systemctl enable httpd

# Create a health check endpoint
echo "OK" > /var/www/html/health.html
