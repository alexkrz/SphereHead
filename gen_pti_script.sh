#!/bin/bash
set -euo pipefail

model="spherehead-ckpt-025000.pkl"
model_dir="models"

target="dataset/testdata"
out="output/pti"

shopt -s nullglob
filename_list=("${target}"/*)

if ((${#filename_list[@]} == 0)); then
    printf 'No input files found in %s\n' "$target" >&2
    exit 1
fi

mkdir -p -- "$out/$model"

for filename_path in "${filename_list[@]}"; do
    filename=$(basename "${filename_path}")

    # perform the pti and save w
    python projector.py --outdir="$out" --target="$target" --network "$model_dir/$model" --idx 0 --filename="$filename" --save-video=true

    # generate .mp4 before finetune
    python gen_videos_proj_withseg.py --output="$out/$model/$filename/pre.mp4" --latent="$out/$model/$filename/projected_w.npz" --trunc 0.7 --network "$model_dir/$model" --cfg Head

    # generate .mp4 after finetune
    python gen_videos_proj_withseg.py --output="$out/$model/$filename/post.mp4" --latent="$out/$model/$filename/projected_w.npz" --trunc 0.7 --network "$out/$model/$filename/fintuned_generator.pkl" --cfg Head

done
