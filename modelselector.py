
import os
import shutil
from cvzone import FPS
from fastapi.params import Query
from fastapi.responses import StreamingResponse
from ultralytics import YOLO
import torch
import fastapi
import cvzone
import cv2
import multiprocessing
import logging
from pythonfiles.camera import FreshestFrame
import threading
from fastapi import File, UploadFile 
from fastapi.middleware.cors import CORSMiddleware

logging.basicConfig(
    level=logging.DEBUG,  # Capture everything from DEBUG and above
    
    format='[%(asctime)s] [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler("log.txt", mode='a', encoding='utf-8'),  # Append mode
        logging.StreamHandler()  # Optional: also show logs in console
    ]
)
UPLOAD_DIR_VIDEO = "uploads/video"
UPLOAD_DIR_MODEL="uploads/models"
os.makedirs(UPLOAD_DIR_VIDEO, exist_ok=True)
os.makedirs(UPLOAD_DIR_MODEL, exist_ok=True)
lock = threading.Lock()

app = fastapi.FastAPI()
cv2.setNumThreads(multiprocessing.cpu_count())
width, hight = 0, 0
detection_box = []
model_names = {}
model = None


origins = ["*"]  # Change this to specific domains in production

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # Allow all origins
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE"],  # Allowed HTTP methods
    allow_headers=["Origin", "X-Requested-With", "Content-Type", "Accept"],  # Allowed headers
)


def selectDevice(device):
    if torch.cuda.is_available() and device == 'cuda':
        return 'cuda'
    else:
        return 'cpu'


def loadModel(path):
    global model_names
    global model
    if model == None:
        model = YOLO(path, task='detect')
        model.eval()
        with lock:
            model_names = model.names
        logging.info('Model Load.')
    with lock:
        return model

def unloadModel():
    global model
    if model is not None:
        # Release any CUDA memory
        if hasattr(model, 'model') and hasattr(model.model, 'cuda'):
            model.model.cpu()
        # Delete the model reference
        model = None
        # Force garbage collection
        import gc
        gc.collect()
        # If using CUDA, empty cache
        if torch.cuda.is_available():
            torch.cuda.empty_cache()
        logging.info('Model unloaded.')

def detect(frame, path='models/yolov8n.pt', dev='cpu'):

    global detection_box
    boxr = []

    model = loadModel(path)

    resuilt = model.predict(frame, device=selectDevice(dev))[0]
    for box, conf, classname in zip(resuilt.boxes.xyxy, resuilt.boxes.conf, resuilt.boxes.cls):
        xyxy = tuple(map(int, box.cpu().tolist()))
        boxr.append((*xyxy, float(conf), int(classname)))
    with lock:
        detection_box = boxr


def transmit(frame, ret, path, devices: fastapi.Request, confindence):

    global width, hight
    confindence = int(confindence)
    confindence = float(confindence/100)
    hight, width = frame.shape[0], frame.shape[1]
    frame = cv2.resize(frame, (640, 640))
    if ret % 25 == 0:
        threading.Thread(target=detect, args=(
            frame.copy(), path, devices), daemon=True).start()
    with lock:
        for (x1, y1, x2, y2, conf, classname) in detection_box:
            if conf >= confindence:
                cvzone.cornerRect(frame, (x1, y1, (x2-x1), (y2-y1)),
                                  5, 1, 1, (255, 255, 255), (0, 0, 0))
                cvzone.putTextRect(frame, model_names[classname], (
                    x1, y1-15), 1, 1, (255, 255, 255), (0, 0, 0), font=cv2.FONT_HERSHEY_COMPLEX_SMALL)

    frame = cv2.resize(frame, (width, hight))
    return frame


async def generate_frame(source, devices,
                         path, request, conf):
    detection_box.clear()
    cap = cv2.VideoCapture(source)
    fresh = FreshestFrame(cap)
    fpsreader = FPS.FPS(avgCount=30)

    try:
        while True:
            if await request.is_disconnected():
                break
            ret, frame = fresh.read()
            fps, frame = fpsreader.update(frame, pos=(20, 50),
                                          bgColor=(255, 0, 255), textColor=(255, 255, 255),
                                          scale=3, thickness=3)
            if not ret:
                break
            frame = transmit(frame, ret, path=path,
                             devices=devices, confindence=conf)
            _, buffer = cv2.imencode('.jpg', frame)
            frame_bytes = buffer.tobytes()

            yield (b'--frame\r\n' b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

    except Exception as e:
        logging.error(e)
    finally:
        logging.info("Release Camera")
        fresh.release()
        cap.release()
        unloadModel()


@app.on_event("shutdown")
def shutdown_event():
    unloadModel()
    logging.info("Application shutdown, resources released")

@app.get("/")
async def video_feed(request: fastapi.Request, path: str = Query(...), device: str = Query(...), source: str = Query(...), conf: str = Query(...)):

    try:
        return StreamingResponse(

            generate_frame(source=source, devices=device,
                           path=path, request=request, conf=conf),


            media_type="multipart/x-mixed-replace; boundary=frame",
            headers={
                "Cache-Control": "no-store"
            }
        )
    except Exception as e:
        return fastapi.Response(f"Ivalid",
                                status_code=400)


@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    print(file.filename)
    if file.filename.split('.')[-1] =='pt':
        file_location = os.path.join(UPLOAD_DIR_MODEL, file.filename)
    else:
        file_location = os.path.join(UPLOAD_DIR_VIDEO, file.filename)

    with open(file_location, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    print(file_location)
    return {"filename": file.filename, "saved_to": file_location}