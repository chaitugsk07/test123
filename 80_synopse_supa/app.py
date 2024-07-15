import asyncio
from typing import AsyncIterable

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from langchain.callbacks import AsyncIteratorCallbackHandler
from pydantic import BaseModel
import jwt #PyJWT

from supabase import create_client, Client
from langchain_openai import ChatOpenAI
from langchain.schema import ChatMessage

openapikey = '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'
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

supabase: Client = create_client("https://s.a.synopseai.com", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogInNlcnZpY2Vfcm9sZSIsCiAgImlzcyI6ICJzdXBhYmFzZSIsCiAgImlhdCI6IDE3MTM4MTA2MDAsCiAgImV4cCI6IDE4NzE1NzcwMDAKfQ.wdLRO9uTwoZg-tdiP_yusL7a4Vx5_kO2edcWq-PtZu0")

class Message(BaseModel):
    content: str
    articleGroupId: int
    accesstoken: str

async def send_message(searchid) -> AsyncIterable[str]:
    response = supabase.rpc("f_q01_followup_articles", {"p_id": 2}).execute()
    messages = []
    messages.append({"role": "system", "content": response.data[0]['system']})
    if len(response.data[0]['query_array']) > 0:
        for i in range(len(response.data[0]['query_array'])):
            messages.append({"role": "user", "content": response.data[0]['query_array'][i]})
            messages.append({"role": "assistant", "content": response.data[0]['reply_array'][i]})
    messages.append({"role": "user", "content": response.data[0]['query']})
    messages1 = [ChatMessage(role=m['role'], content=m['content']) for m in messages]
    callback = AsyncIteratorCallbackHandler()
    model = ChatOpenAI(
        streaming=True,
        verbose=True,
        callbacks=[callback],
        openai_api_key = openapikey
    )

    task = asyncio.create_task(
        model.agenerate(messages=[messages1])
    )

    try:
        async for token in callback.aiter():
            yield token
    except Exception as e:
        print(f"Caught exception: {e}")
    finally:
        callback.done.set()

    await task

def getaccount(accesstoken: str):
    try:
        decoded = jwt.decode(accesstoken, options={"verify_signature": False})
        return decoded["sub"]
    except Exception as e:
        print(f"Caught exception: {e}")
        return 'NA'

@app.post("/stream_chat/")
async def stream_chat(message: Message):
    account = getaccount(message.accesstoken)
    if account == 'NA':
        return 'Invalid Access Token'
    id = 0
    try:
        response = supabase.table("t_q01_ask_follow_up").insert({"query": message.content, "article_group_id": message.articleGroupId, "account": account}).execute()
        id = response.data[0]["id"]
    except Exception as e:
        print(f"Caught exception: {e}")
        return 'Failed to insert query'
    generator = send_message(id)
    return StreamingResponse(generator, media_type="text/event-stream")
