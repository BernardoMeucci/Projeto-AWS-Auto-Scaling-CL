#!/bin/bash
yum update -y
yum install -y httpd
echo "Servidor Web Ativo - Host: $(hostname -f)" > /var/www/html/index.html

cat <<EOL > /var/www/html/teste
#!/bin/bash
echo "Content-type: text/plain"
echo ""
echo "Requisição processada por: $(hostname -f)"
sleep 5
EOL

chmod +x /var/www/html/teste
systemctl start httpd
systemctl enable httpd 