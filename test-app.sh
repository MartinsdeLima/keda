#!/bin/bash

# Script para testar a aplicação PHP do deployment

echo "=== Testando aplicação PHP (KEDA Demo) ==="
echo ""

# 1. Verificar se o deployment está rodando
echo "1. Verificando deployment..."
kubectl get deployment keda-php-demo -n keda-demo
echo ""

# 2. Verificar os pods
echo "2. Verificando pods..."
kubectl get pods -n keda-demo -l app=keda-php-demo
echo ""

# 3. Criar port-forward
echo "3. Criando port-forward (porta 8089)..."
kubectl port-forward svc/keda-php-demo -n keda-demo 8089:89 &
PF_PID=$!
sleep 2
echo ""

# 4. Testar endpoints
echo "4. Testando endpoints..."
echo ""

echo "   GET /ping:"
curl -s http://localhost:8089/ping && echo ""
echo ""

echo "   GET /:"
curl -s http://localhost:8089/ && echo ""
echo ""

# 5. Limpar
echo "5. Limpando (encerrando port-forward)..."
kill $PF_PID 2>/dev/null
echo "Done!"
