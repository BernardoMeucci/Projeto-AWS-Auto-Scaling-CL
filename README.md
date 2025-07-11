# Projeto-AWS-Auto-Scaling-CL

 
## 🚀 Atividade: Auto Scaling + CLB + Endpoint de Teste
 
### 1. Crie um **Classic Load Balancer**
- Escolha as mesmas VPC/subnets das instâncias
- Permita porta **HTTP 80**
- Registre alvo como **instâncias EC2**

![](/print-trabalho/clb.jpg)
 
---
 
### 2. Crie um **Auto Scaling Group**
- Use uma AMI Amazon Linux

![](/print-trabalho/modelo%20de%20execucao.jpg)

- Grupo de segurança permitindo SSH e HTTP

![](/print-trabalho/grupo%20de%20seguranca.jpg)

- Associando Auto Scaling a VPC e as Sub-redes em duas AZs

![](/print-trabalho/auto-scaling.jpg)

- Defina:
  - Mínimo: `1`
  - Máximo: `3`
- Associe ao seu Classic Load Balancer

![](/print-trabalho/config%201%20asg.jpg)

![](/print-trabalho/config%202%20asg.jpg)
 
![](/print-trabalho/config%203%20asg.jpg)
---
 
### 3. Na instância, suba um **servidor simples com endpoint HTTP**
Use esse script na **User Data** da instância ou execute manualmente:

```bash
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
```
 
> Agora você pode acessar: `http://<IP_OU_DNS_CLB>/teste` e vai ver a resposta do servidor.
 
---
 
### 4. Configure **Regras de Escalonamento Automático**
 
#### ➕ Regra: Aumentar quando houver mais requisições
- Métrica: **RequestCount** por instância > 10
- Ação: Adicionar 1 instância

![](/print-trabalho/resumo%20cloud%20watch%20alto.jpg)

#### ➖ Regra: Diminuir quando requisicoes caírem
- Métrica: **RequestCount** por instância < 5
- Ação: Remover 1 instância
 
![](/print-trabalho/resumo%20cloud%20watch%20baixo.jpg)

![](/print-trabalho)

> ⚙️ Configure isso em **Scaling Policies** do ASG usando **CloudWatch Alarms**.
 
![](/print-trabalho/cloud-watch%20alto.jpg)

![](/print-trabalho/cloud%20watch%20baixo.jpg)

![](/print-trabalho/cloud-watch.jpg)

- Funcionamento

![](/print-trabalho/alerta%20de%20reducao.jpg)

![](/print-trabalho/alarmes%20em%20funcionamento%20trafego%20alto.jpg)

![](/print-trabalho/alarmes%20em%20funcionamento%20trafego%20baixo.jpg)

---
 
### 5. Teste o Auto Scaling
 
- Use ferramentas como `hey` ou `ab` pra gerar carga:
 
```bash
hey -z 5m http://<DNS_DO_LOAD_BALANCER>/teste
```
 
- Aguarde alguns minutos e veja se novas instâncias aparecem no ASG!
 
![](/print-trabalho/3%20instancias%20iniciadas.jpg)

- Após finalizar o teste irá reduzir uma instância.

![](/print-trabalho/comecando%20a%20diminuir%20as%20instancias.jpg)
---
 
## ✅ Resultado Esperado:
- O endpoint `/Teste` responde em cada instância
- Requisições constantes fazem o Auto Scaling aumentar máquinas
- Quando parar de enviar requisições, o ASG diminui instâncias

