YOLO Model Selector UI
A full-stack real-time YOLO inference platform with a Flutter Web frontend and a Python backend. This project allows users to select YOLO models, set confidence thresholds, choose hardware acceleration (CPU/CUDA), and stream video input (RTSP, webcam, or local video files) for object detection.

✨ Features
🔧 Model Selection — Choose among multiple YOLO models (e.g., YOLOv5, YOLOv8, etc.)

📷 Source Selection — Supports:

RTSP streams

USB/Web cameras

Local video files

🎚️ Confidence Threshold — Adjustable detection confidence level

🚀 Hardware Acceleration — Toggle between CPU and CUDA for inference

🌐 Flutter Web UI — Intuitive and responsive web-based control panel

🧠 YOLO Backend — Real-time video analysis using Python and YOLO

🧩 Architecture Overview
sql
Copy
Edit
[Flutter Web UI]  --->  [FastAPI/Python Backend]  --->  [YOLO Inference Engine]
         |                                                    
    User selects model, source, threshold, runtime           
         |                                                    
         ---> Inference starts and returns live results      
🖥️ Frontend (Flutter Web)
📁 Path: /frontend
🚀 Getting Started
bash
Copy
Edit
cd frontend
flutter pub get
flutter run -d chrome
🔧 Features
Drop-down model selection

Input for video source (RTSP/Path)

Sliders for confidence adjustment

Toggle switch for CPU/CUDA

"Run" button to start detection via API call to backend

🧠 Backend (Python + YOLO)
📁 Path: /backend
⚙️ Requirements
Python 3.8+

pip packages (see requirements.txt)

PyTorch with CUDA support (optional)

🚀 Getting Started
bash
Copy
Edit
cd backend
pip install -r requirements.txt
python main.py
🔧 Features
REST API to receive settings from frontend

Starts video stream processing using YOLO

Supports switching models and sources dynamically

📡 API Communication
Method	Endpoint	Description
POST	/start	Starts YOLO inference
GET	/status	Returns status of the backend
POST	/stop	Stops current inference session

Payload example for /start:

json
Copy
Edit
{
  "model": "yolov8n.pt",
  "source": "rtsp://192.168.1.10:554/stream",
  "conf": 0.5,
  "device": "cuda"
}
📸 Example UI Screenshot
(Include a screenshot of your Flutter web interface here)

🔮 Future Plans
Live video preview in web UI

Authentication and user profiles

Support for multiple simultaneous streams

Export results (CSV, JSON, video)

🧑‍💻 Contributing
Pull requests are welcome! For major changes, please open an issue first.

📄 License
MIT License