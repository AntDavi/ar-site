#!/bin/bash

# Script de Otimização do Modelo 3D - VIRTUEX MÓVEIS
# Este script automatiza a otimização do arquivo GLB

echo "🚀 OTIMIZAÇÃO DO MODELO 3D - VIRTUEX MÓVEIS"
echo "=============================================="
echo ""

# Verificar se o arquivo existe
if [ ! -f "src/assets/MESA MOVENORD.glb" ]; then
    echo "❌ Erro: Arquivo 'MESA MOVENORD.glb' não encontrado!"
    exit 1
fi

echo "📊 Arquivo original encontrado:"
ls -lh "src/assets/MESA MOVENORD.glb"
echo ""

# Verificar se gltf-transform está instalado
if ! command -v gltf-transform &> /dev/null; then
    echo "📦 Instalando gltf-transform..."
    npm install -g @gltf-transform/cli
    echo ""
fi

echo "⚙️  Iniciando otimização..."
echo ""

# Passo 1: Otimização básica com compressão
echo "1️⃣  Aplicando compressão meshopt..."
gltf-transform optimize "src/assets/MESA MOVENORD.glb" "src/assets/MESA_STEP1.glb" \
  --compress meshopt 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Compressão aplicada!"
    ls -lh "src/assets/MESA_STEP1.glb"
else
    echo "⚠️  Aviso: Compressão falhou, continuando..."
    cp "src/assets/MESA MOVENORD.glb" "src/assets/MESA_STEP1.glb"
fi
echo ""

# Passo 2: Redimensionar texturas
echo "2️⃣  Redimensionando texturas (max 2048x2048)..."
gltf-transform resize "src/assets/MESA_STEP1.glb" "src/assets/MESA_STEP2.glb" \
  --width 2048 --height 2048 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Texturas redimensionadas!"
    ls -lh "src/assets/MESA_STEP2.glb"
else
    echo "⚠️  Aviso: Redimensionamento falhou, continuando..."
    cp "src/assets/MESA_STEP1.glb" "src/assets/MESA_STEP2.glb"
fi
echo ""

# Passo 3: Comprimir texturas para WebP
echo "3️⃣  Convertendo texturas para WebP..."
gltf-transform webp "src/assets/MESA_STEP2.glb" "src/assets/MESA_OTIMIZADO.glb" \
  --quality 85 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Texturas convertidas para WebP!"
else
    echo "⚠️  WebP não disponível, usando arquivo anterior..."
    cp "src/assets/MESA_STEP2.glb" "src/assets/MESA_OTIMIZADO.glb"
fi
echo ""

# Limpar arquivos temporários
echo "🧹 Limpando arquivos temporários..."
rm -f "src/assets/MESA_STEP1.glb" "src/assets/MESA_STEP2.glb"
echo ""

# Comparar tamanhos
echo "=============================================="
echo "📊 RESULTADOS DA OTIMIZAÇÃO"
echo "=============================================="
echo ""
echo "📦 Arquivo ORIGINAL:"
ls -lh "src/assets/MESA MOVENORD.glb" | awk '{print "   Tamanho: " $5}'
ORIGINAL_SIZE=$(stat -f%z "src/assets/MESA MOVENORD.glb" 2>/dev/null || stat -c%s "src/assets/MESA MOVENORD.glb" 2>/dev/null)

echo ""
echo "✨ Arquivo OTIMIZADO:"
ls -lh "src/assets/MESA_OTIMIZADO.glb" | awk '{print "   Tamanho: " $5}'
OPTIMIZED_SIZE=$(stat -f%z "src/assets/MESA_OTIMIZADO.glb" 2>/dev/null || stat -c%s "src/assets/MESA_OTIMIZADO.glb" 2>/dev/null)

echo ""
# Calcular redução percentual
if [ ! -z "$ORIGINAL_SIZE" ] && [ ! -z "$OPTIMIZED_SIZE" ]; then
    REDUCTION=$(echo "scale=2; (1 - $OPTIMIZED_SIZE / $ORIGINAL_SIZE) * 100" | bc)
    echo "📉 Redução: ${REDUCTION}%"
fi

echo ""
echo "=============================================="
echo "✅ OTIMIZAÇÃO CONCLUÍDA!"
echo "=============================================="
echo ""
echo "🎯 Próximos passos:"
echo ""
echo "1. Testar o modelo otimizado:"
echo "   - Abra o site em um navegador"
echo "   - Verifique se o modelo carrega corretamente"
echo "   - Teste a qualidade visual"
echo ""
echo "2. Se estiver satisfeito, atualize o index.html:"
echo "   - Altere: src=\"src/assets/MESA MOVENORD.glb\""
echo "   - Para:   src=\"src/assets/MESA_OTIMIZADO.glb\""
echo ""
echo "3. (Opcional) Faça backup e substitua o original:"
echo "   mv \"src/assets/MESA MOVENORD.glb\" \"src/assets/MESA_ORIGINAL_BACKUP.glb\""
echo "   mv \"src/assets/MESA_OTIMIZADO.glb\" \"src/assets/MESA MOVENORD.glb\""
echo ""
echo "🚀 Tempo de carregamento esperado: 4-6 segundos"
echo ""
