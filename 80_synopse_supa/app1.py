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


class Message(BaseModel):
    content: str


async def send_message(content: str) -> AsyncIterable[str]:
    callback = AsyncIteratorCallbackHandler()
    model = ChatOpenAI(
        streaming=True,
        verbose=True,
        callbacks=[callback],
        openai_api_key = openapikey
    )
    messages1 = [{'role': 'system', 'content': 'You are a news chatbot. Your role is to answer questions with the help on the context provided in the system message.If the question user asked is not related relevant to the system context just respond with "NA", If the question user asked is relevant to the system context then answer with an unbiased answer with maximum of 100 words. the output should in English, This is the context. Supreme Court Criticizes Uttarakhand Government for Lackadaisical Approach to Forest Fires The Supreme Court\'s criticism of the Uttarakhand government sheds light on the pressing issue of forest fires in the region. With the Chief Secretary being summoned, the government faces scrutiny over its response to the environmental crisis. This development underscores the importance of proactive measures to prevent further damage to the state\'s biodiversity and ecosystem. ‘Lackadaisical approach’: SC pulls up Uttarakhand govt over forest fires, summons chief secy , \'Approach lackadaisical\': SC pulls up Uttarakhand govt over forest fires \'Approach lackadaisical\': SC pulls up Uttarakhand govt over forest fires'}, {'role': 'user', 'content': 'explain the environmental crisis'}, {'role': 'assistant', 'content': "The environmental crisis in Uttarakhand involves widespread forest fires that threaten the region's biodiversity and ecosystem. These fires cause significant destruction of forest cover, loss of wildlife habitats, and deterioration of air quality. The resulting damage affects not only the natural environment but also the livelihoods of local communities dependent on these forests. The Supreme Court's intervention indicates severe inadequacies in the government's response to this crisis, emphasizing the need for immediate and effective measures to control and prevent such fires to protect the environment and biodiversity."}, {'role': 'user', 'content': 'how serious is the issue'}, {'role': 'assistant', 'content': "The issue is quite serious. The Supreme Court's summoning of the Uttarakhand Chief Secretary highlights significant concerns about the state's handling of forest fires. This criticism points to inadequate and slow responses to a critical environmental crisis, threatening biodiversity and the ecosystem. The court's intervention underscores the urgency for the government to adopt proactive measures to mitigate and prevent further damage."}, {'role': 'user', 'content': 'how serious is the issue'}]
    messages = [ChatMessage(role=m['role'], content=m['content']) for m in messages1]
    task = asyncio.create_task(
        model.agenerate(messages=[messages])
    )
    
    try:
        async for token in callback.aiter():
            r1 = r1 + token
            yield token
    except Exception as e:
        print(f"Caught exception: {e}")
    finally:
        callback.done.set()
    await task


@app.post("/stream_chat/")
async def stream_chat(message: Message):
    generator = send_message(message.content)
    return StreamingResponse(generator, media_type="text/event-stream")

def main():
    import uvicorn
    uvicorn.run(app, host="localhost", port=8000)