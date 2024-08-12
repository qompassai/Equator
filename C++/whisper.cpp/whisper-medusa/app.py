import torch
import torchaudio

from whisper_medusa import WhisperMedusaModel
from transformers import WhisperProcessor

model_name = "aiola/whisper-medusa-v1"
model = WhisperMedusaModel.from_pretrained(model_name)
processor = WhisperProcessor.from_pretrained(model_name)

path_to_audio = "path/to/audio.wav"
SAMPLING_RATE = 16000
language = "en"
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

input_speech, sr = torchaudio.load(path_to_audio)
if input_speech.shape[0] > 1:  # If stereo, average the channels
    input_speech = input_speech.mean(dim=0, keepdim=True)

if sr != SAMPLING_RATE:
    input_speech = torchaudio.transforms.Resample(sr, SAMPLING_RATE)(input_speech)

input_features = processor(input_speech.squeeze(), return_tensors="pt", sampling_rate=SAMPLING_RATE).input_features
input_features = input_features.to(device)

model = model.to(device)
model_output = model.generate(
    input_features,
    language=language,
)
predict_ids = model_output[0]
pred = processor.decode(predict_ids, skip_special_tokens=True)
print(pred)

