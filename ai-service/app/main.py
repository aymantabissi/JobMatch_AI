from fastapi import FastAPI

app=FastAPI(title="JobMaatch AI Srevice")

@app.get("/health")
def health_check():
    return{"status":"ok" , "service":"JobMatch AI"}