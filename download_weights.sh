#!/bin/bash

# Set the checkpoints directory
CheckpointsDir="models"

# Install Hugging Face CLI with Xet transfer (quietly)
uv pip install -q -U "huggingface_hub[hf_xet]"

# Download MuseTalk weights
hf download TMElyralab/MuseTalk --local-dir $CheckpointsDir --exclude "*.md" --exclude ".gitattributes"

# Download SD VAE weights
hf download stabilityai/sd-vae-ft-mse config.json diffusion_pytorch_model.safetensors --local-dir $CheckpointsDir/sd-vae

# Download Whisper weights
hf download openai/whisper-tiny config.json pytorch_model.bin preprocessor_config.json --local-dir $CheckpointsDir/whisper

# Download DWPose weights
hf download yzd-v/DWPose dw-ll_ucoco_384.pth --local-dir $CheckpointsDir/dwpose

# Download SyncNet weights
hf download ByteDance/LatentSync latentsync_syncnet.pt --local-dir $CheckpointsDir/syncnet

# Download Face Parse Bisent weights
hf download ManyOtherFunctions/face-parse-bisent 79999_iter.pth resnet18-5c106cde.pth --local-dir $CheckpointsDir/face-parse-bisent

echo "✅ All weights have been downloaded successfully!" 