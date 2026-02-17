#!/bin/bash
echo "🔧 Configurando AI-Toolkit para Network Volume..."

# Wait for AI-Toolkit directory
while [ ! -d "/app/ai-toolkit" ]; do
    echo "⏳ Esperando AI-Toolkit..."
    sleep 2
done

echo "✅ AI-Toolkit detectado"

# Create structure in Network Volume (PERSISTENT)
mkdir -p /workspace/diffusion_models
mkdir -p /workspace/text_encoders
mkdir -p /workspace/vae
mkdir -p /workspace/datasets
mkdir -p /workspace/aitoolkit_output
mkdir -p /workspace/aitoolkit_configs
mkdir -p /workspace/.cache/huggingface

# Backup original directories if they exist
if [ -d "/app/ai-toolkit/datasets" ] && [ ! -L "/app/ai-toolkit/datasets" ]; then
    echo "📦 Backing up original datasets..."
    mv /app/ai-toolkit/datasets /app/ai-toolkit/datasets.bak
fi

if [ -d "/app/ai-toolkit/output" ] && [ ! -L "/app/ai-toolkit/output" ]; then
    echo "📦 Backing up original output..."
    mv /app/ai-toolkit/output /app/ai-toolkit/output.bak
fi

if [ -d "/app/ai-toolkit/config" ] && [ ! -L "/app/ai-toolkit/config" ]; then
    echo "📦 Backing up original config..."
    mv /app/ai-toolkit/config /app/ai-toolkit/config.bak
fi

# Remove if broken symlinks
rm -f /app/ai-toolkit/datasets
rm -f /app/ai-toolkit/output
rm -f /app/ai-toolkit/config
rm -f /app/ai-toolkit/aitk_db.db

# Create symlinks AI-Toolkit → Network Volume
ln -sf /workspace/datasets /app/ai-toolkit/datasets
ln -sf /workspace/aitoolkit_output /app/ai-toolkit/output
ln -sf /workspace/aitoolkit_configs /app/ai-toolkit/config
ln -sf /workspace/.cache/huggingface /root/.cache/huggingface

# Database in Network Volume (persistent)
if [ ! -f "/workspace/aitk_db.db" ]; then
    echo "🆕 Creando database inicial..."
    touch /workspace/aitk_db.db
fi
ln -sf /workspace/aitk_db.db /app/ai-toolkit/aitk_db.db

echo "🔗 Symlinks creados:"
ls -la /app/ai-toolkit/ | grep -E 'datasets|output|config|aitk_db'

echo "✅ Setup completado - AI-Toolkit usa Network Volume"
echo "📂 Modelos FLUX disponibles:"
ls -lh /workspace/diffusion_models/*.safetensors 2>/dev/null || echo "  (ninguno encontrado aún)"
ls -lh /workspace/text_encoders/*.safetensors 2>/dev/null || echo "  (ninguno encontrado aún)"
