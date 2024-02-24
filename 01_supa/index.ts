import OpenAI from 'https://deno.land/x/openai@v4.24.0/mod.ts'
import { OpenAIStream, StreamingTextResponse } from "npm:ai";;
import { decode, JwtPayload } from "https://deno.land/x/djwt/mod.ts";


export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (req) => {
  const { query } = await req.json()
  const { token } = await req.json()
  console.log("token", token);
  const jwtPayload = decode(token) as JwtPayload;
  const userId = jwtPayload["https://hasura.io/jwt/claims"]["x-hasura-user-id"];
  console.log("userId", userId);
  const ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g";
  const openai = new OpenAI({
    apiKey: ANYSCALE_API_KEY,
    baseURL: "https://api.endpoints.anyscale.com/v1",
  })

  // Documentation here: https://github.com/openai/openai-node
  const completionStream  = await openai.chat.completions.create({
    messages: [{ role: 'user', content: "answer in maximum to about 100 tokens: " + query }],
    // Choose model from here: https://platform.openai.com/docs/models
    model: 'meta-llama/Llama-2-7b-chat-hf',
    stream: true,
    max_tokens: 150, // Limit the output to 100 tokens
  })
  
  const stream = OpenAIStream(completionStream);

  return new StreamingTextResponse(stream, { headers: corsHeaders });
  
})