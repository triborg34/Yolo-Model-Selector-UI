# YOLO Model Selector UI

This project is a full-stack real-time YOLO inference system with:

- 🖥️ **Flutter Web Frontend** for selecting YOLO models, video sources, confidence thresholds, and compute devices.
- 🧠 **Python Backend** for running YOLO inference (supports CUDA and CPU), handling video input (RTSP, webcam, or video files), and communicating with the frontend.

## 🚀 Features

- ✅ Model selection (e.g., YOLOv5, YOLOv8)
- 📷 Source input: RTSP, webcam, or video file
- 🎚️ Confidence threshold adjustment
- ⚙️ CPU / CUDA device toggle
- 🖼️ Real-time detection
- 🔌 REST API integration

---

For BackEnd 

its Modelselector.py and camera.py 
run modelselector.py with uvicorn modelselector:app
