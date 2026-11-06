#!/bin/bash

python gen_samples_from_angle.py \
    --outdir out/proj_render \
    --network  output/pti/spherehead-ckpt-025000.pkl/0/fintuned_generator.pkl \
    --latent   output/pti/spherehead-ckpt-025000.pkl/0/projected_w.npz \
    --yaw -30 --pitch 0 \
    --cfg Head