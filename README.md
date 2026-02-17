# AI-Toolkit Training - RunPod Template

Template para entrenar LoRAs FLUX con AI-Toolkit de Ostris, optimizado para Network Volume persistente.

## Features
- ✅ AI-Toolkit Web UI automático (puerto 8675)
- ✅ FileBrowser incluido (puerto 8080)
- ✅ Network Volume integration
- ✅ CUDA 12.1 compatible (RunPod GPUs)
- ✅ Database persistente
- ✅ Zero data loss entre pods

## Estructura Network Volume
```
/workspace/
├── diffusion_models/      # FLUX checkpoints
│   └── flux1-dev.safetensors
├── text_encoders/         # T5 + CLIP-L
│   ├── t5xxl_fp16.safetensors
│   └── clip_l.safetensors
├── vae/
│   └── ae.safetensors
├── datasets/              # Training datasets
│   └── tu-proyecto/
│       ├── 001.jpg
│       ├── 001.txt
│       └── ...
├── aitoolkit_output/      # LoRAs entrenados
├── aitoolkit_configs/     # YAML configs (opcional)
└── aitk_db.db            # Web UI database (persistente)
```

## Uso

### Deploy
1. RunPod → Deploy
2. Template: "Chubby-AI-Toolkit-Training"
3. GPU: RTX 4090 (24GB+)
4. Network Volume: tu-volume @ `/workspace`
5. Deploy

### Acceso
- **AI-Toolkit UI**: `https://[pod-id]-8675.proxy.runpod.net`
- **FileBrowser**: `https://[pod-id]-8080.proxy.runpod.net`
- **Password**: Define en env var `AI_TOOLKIT_AUTH` (default: `password`)

## Training Workflow

1. Subir dataset a `/workspace/datasets/tu-proyecto/`
2. Acceder AI-Toolkit Web UI
3. Create Dataset → `/workspace/datasets/tu-proyecto/`
4. Create Job → configurar training
5. Start training
6. Descargar LoRA desde `/workspace/aitoolkit_output/`

## Modelos FLUX Requeridos

Deben estar en tu Network Volume:
- `/workspace/diffusion_models/flux1-dev.safetensors`
- `/workspace/text_encoders/t5xxl_fp16.safetensors`
- `/workspace/text_encoders/clip_l.safetensors`
- `/workspace/vae/ae.safetensors`

## Technical Details

- **Base Image**: `runpod/pytorch:2.1.0-py3.10-cuda12.1.1`
- **CUDA**: 12.1 (compatible RunPod GPUs)
- **Node.js**: 20.x
- **AI-Toolkit**: Latest from GitHub
