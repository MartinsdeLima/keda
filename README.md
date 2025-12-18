Instalação do KEDA no cluster Kubernetes

1 - Configuração HTTPScaledObject para a aplicação PHP
- Namespace: `keda-demo`
- Arquivo: [http-scaledobject.yaml](http-scaledobject.yaml)
- Especificação relevante:
	- `hosts`: `php-demo.local`
	- `pathPrefixes`: `/`
	- `scaleTargetRef`: `service: keda-php-demo`, `port: 80`
	- `replicas`: `min: 0`, `max: 10`
	- `scaledownPeriod`: `30`
	- `scalingMetric.requestRate`: `granularity: 1s`, `targetValue: 1`, `window: 10s`
- Aplicar:
```bash
kubectl apply -f http-scaledobject.yaml
kubectl get httpscaledobject -n keda-demo
```

2 - Instalação da aplicação PHP
- Namespace: `keda-demo`
- Arquivos: [deployment.yaml](deployment.yaml), [Dockerfile](Dockerfile), [index.php](index.php)
- Build da imagem dentro do Minikube (imagem local; `imagePullPolicy: Never`):
```bash
eval $(minikube docker-env)
docker build -t keda-php-demo:latest .
```
- Aplicar deployment e service:
```bash
kubectl apply -f deployment.yaml
kubectl get deployment,service -n keda-demo
```

3 - Comandos básicos kubectl para gerenciar o KEDA e a aplicação PHP
- Port-forward do HTTP Interceptor Proxy (para receber tráfego HTTP do add-on):
```bash
kubectl port-forward svc/keda-add-ons-http-interceptor-proxy -n keda 8081:8080
```
- Inspeção de recursos de escala:
```bash
kubectl get httpscaledobject,scaledobject,hpa -n keda-demo
kubectl describe hpa keda-hpa-keda-php-demo -n keda-demo
watch -n 1 'kubectl get hpa,replicaset,pods -n keda-demo'
```

4 - Como realizar testes
- Requisições com cabeçalho `Host`:
```bash
curl -H "Host: php-demo.local" http://localhost:8081/ping
```
- Teste de escala com carga sustentada (recomendado):
```bash
hey -z 60s -c 20 -host "php-demo.local" http://localhost:8081/ping
```
- Alternativas:
```bash
# Loop de curls (gera pico curto)
for i in {1..100}; do curl -H "Host: php-demo.local" http://localhost:8081/ping & done

# Apache Bench
ab -t 60 -c 20 -H "Host: php-demo.local" http://localhost:8081/ping
```

5 - Referências
# Fontes consultadas
https://dev.to/jonas-elias/keda-http-add-on-escalonamento-dinamico-por-volume-de-requisicoes-3d88
# Documentação oficial 
https://keda.sh/docs/2.10/
