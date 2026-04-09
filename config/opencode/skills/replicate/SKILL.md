---
name: replicate
description: Search, explore, and run ML models on Replicate via plugin tools
---

# Replicate

You have four tools for interacting with Replicate:

- **replicate_search** -- Search for models by task or name
- **replicate_schema** -- Get a model's input/output schema (always call this before running)
- **replicate_run** -- Run a prediction (handles sync wait + polling automatically)
- **replicate_whoami** -- Check the authenticated Replicate account

## Key concepts

- **Models** are identified as `owner/name` (e.g. `black-forest-labs/flux-schnell`).
- **Official models** are always warm, predictably priced, and have stable APIs. Use the `owner/name` format with replicate_run.
- **Community models** require a version ID: `owner/name:version_id`. Get the version ID from replicate_schema.
- **Predictions** go through states: starting -> processing -> succeeded/failed/canceled.

## Workflow

When a user asks you to run a model or perform a task:

1. If they haven't specified a model, use **replicate_search** to find appropriate ones
2. Use **replicate_schema** to understand the model's inputs before running it
3. Use **replicate_run** with the correct inputs -- it handles sync wait (60s) and polling automatically
4. Present the output clearly -- for image URLs, display them inline; for JSON, format it nicely
5. Link to the prediction: `https://replicate.com/p/PREDICTION_ID`

## Understanding user requests

Users often ask to generate things without specifying how. Plan which models to use.

### Examples

- **"Make a commercial"**: Generate keyframes with an image model (FLUX, Nano Banana Pro), then generate video segments between keyframes in parallel with a video model, then stitch them together.
- **"Decorate my room"**: Ask for a room photo and style preferences, then use an image editing model with the inputs.
- **"Celebrity selfie video"**: Get a user selfie, find celebrity images (via web search if needed), generate keyframes, create video segments, stitch together.
- **"Summarize a PDF"**: Use an OCR model on Replicate to extract text, then summarize it yourself (no need for a language model on Replicate).
- **"Translate a video"**: Extract audio -> speech recognition -> translate text yourself -> text-to-speech -> lip sync model with original video.

## Finding the right model

- Always use the **latest version** of a model (Kling 3.0 over Kling 2.5, Nano Banana Pro over Nano Banana, etc.)
- Prefer **recently released** models over old ones
- Prefer **official models** over community models
- High run counts can indicate old popular models, not necessarily the best current option
- The search API does its best to surface recent state-of-the-art models, but apply judgment

## Downloading outputs

When a prediction returns file URLs (images, audio, video), download them to the workspace:

```bash
curl -sL "OUTPUT_URL" -o descriptive-filename.png
```

Report the saved path so the user can access the file. Use descriptive filenames with timestamps when generating multiple outputs.
