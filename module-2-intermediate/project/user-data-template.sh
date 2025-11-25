#!/bin/bash
# Template user data script for cluster instances
# Variables are interpolated by Terraform

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Create a custom web page with server number
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server ${server_number} - ${project_name}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 600px;
            text-align: center;
        }
        h1 {
            color: #f5576c;
            font-size: 3em;
            margin-bottom: 20px;
        }
        .server-number {
            font-size: 5em;
            color: #f093fb;
            font-weight: bold;
            margin: 20px 0;
        }
        p { color: #333; margin: 10px 0; }
        .badge {
            display: inline-block;
            background: #10b981;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 Web Server</h1>
        <div class="server-number">#${server_number}</div>
        <p><strong>Project:</strong> ${project_name}</p>
        <p><strong>Instance ID:</strong> <span id="instance-id">Loading...</span></p>
        <p><strong>Public IP:</strong> <span id="public-ip">Loading...</span></p>
        <span class="badge">Deployed with Terraform</span>
    </div>
    <script>
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(r => r.text())
            .then(data => document.getElementById('instance-id').textContent = data);
        fetch('http://169.254.169.254/latest/meta-data/public-ipv4')
            .then(r => r.text())
            .then(data => document.getElementById('public-ip').textContent = data);
    </script>
</body>
</html>
EOF

# Start Apache and enable on boot
systemctl start httpd
systemctl enable httpd
