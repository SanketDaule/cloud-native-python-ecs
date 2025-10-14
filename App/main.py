from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import boto3
import os

app = FastAPI()

AWS_REGION = os.getenv("AWS_REGION", "ap-south-1")
TABLE_NAME = os.getenv("DYNAMODB_TABLE")

dynamodb = boto3.resource("dynamodb", region_name=AWS_REGION)
table = dynamodb.Table(TABLE_NAME)

class Item(BaseModel):
    id: str
    value: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/items/{item_id}")
def get_item(item_id: str):
    try:
        resp = table.get_item(Key={"id": item_id})
        item = resp.get("Item")
        if not item:
            raise HTTPException(status_code=404, detail="Item not found")
        return item
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/items")
def put_item(item: Item):
    try:
        table.put_item(Item={"id": item.id, "value": item.value})
        return item
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))