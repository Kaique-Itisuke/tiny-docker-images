from fastapi import FastAPI

app = FastAPI()


@app.get("/health")
def read_root() -> dict[str, str]:
    return {"Message": "healthy"}
