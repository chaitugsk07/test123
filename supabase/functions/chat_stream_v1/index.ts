// deno-lint-ignore-file
// supabase functions serve  --no-verify-jwt
// supabase functions deploy chat_stream_v1  --no-verify-jwt --project-ref icrispjgfllulboelvhw
// curl -i --location --request POST "http://localhost:54321/functions/v1/chat_stream_v1" --header "Content-Type: application/json" --data "{""query"":""what is the bomd used"", ""article_id"":""149"", ""token"":""Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjEyMGFiZDNiLTI1NjctNDc4MS04Y2VhLWU5NjAzMWZlMTA3MCJ9LCJleHAiOjE3MDg1NzY3ODN9.oK45ie3uovx6R64WrZs6CnEnYBWmrZyluQ7mhcd4KTo"" }"
import OpenAI from 'https://deno.land/x/openai@v4.24.0/mod.ts'
import { OpenAIStream, StreamingTextResponse } from "npm:ai";;
import { decode  } from "https://deno.land/x/djwt@v3.0.1/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.6"




export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

function verifyGenerateToken(token: string) {
  const t1 = token.slice(7);
  try {
    const [header, payload, signature] = decode(t1);
  interface JwtPayload {
    'https://hasura.io/jwt/claims': {
      'x-hasura-user-id': string;
    };
  }
  const userId = (payload as JwtPayload)['https://hasura.io/jwt/claims']['x-hasura-user-id'];
  return userId;
  }
  catch {
    return "na";
  }
}

Deno.serve(async (req) => {
  const { query , article_id, token } = await req.json()
  const uid = verifyGenerateToken(token);
  if (uid == "na") {
    return new Response("Unauthorized", { status: 401 });
  }
  const data_input = { account: uid, article_group_id: article_id, query: query}
  const supabaseUrl = 'https://icrispjgfllulboelvhw.supabase.co'
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImljcmlzcGpnZmxsdWxib2Vsdmh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU5MjEwNTIsImV4cCI6MjAxMTQ5NzA1Mn0._OwgY5xcVKtFQ-QMrbUnljBLiXAKpbQWv9dwxRkqdQo'
  const supabase = createClient(supabaseUrl, supabaseKey)
  const response  = await supabase
    .schema('synopse_realtime')
    .from('t_v10_users_follow_up')
    .insert([data_input])
    
    if (response.error) {
      return new Response("Error a", { status: 500 });
    } 

  const response1 = await supabase
  .schema('synopse_articles')
  .rpc('f_article_context', { p_article_id: article_id })

  if (response1.error) {
    return new Response("Error b", { status: 500 });
  }
  const a1 = response1.data;
  const words = a1.split(' ');
  if (words.length > 750) {
      const trimmedWords = words.slice(0, 750);
      const a1 = trimmedWords.join(' ');
  } 
  // console.log(a1);
  const message1 = "You are a news chatbot. Your role is to answer questions with the help on the context provided in the system message. answer the question is even partially relevant to the system context then answer Generate an unbiased answer in one or two small paragraphs. ensure that maximum of 100 tokens: . This is the context " + a1 + ". ";
  const ANYSCALE_API_KEY = "esecret_7eix5t1gpk7a9t356htd89jn2g";
  const openai = new OpenAI({
    apiKey: ANYSCALE_API_KEY,
    baseURL: "https://api.endpoints.anyscale.com/v1",
  })

  const completionStream  = await openai.chat.completions.create({
    messages: [
      {role: "system", content: message1},
      {role: 'user', content:  query }],
    model: 'meta-llama/Llama-2-7b-chat-hf',
    stream: true,
    max_tokens: 300,
    temperature: 0.3,
    top_p: 0.9
  })
 
  const stream = OpenAIStream(completionStream);
  
  return new StreamingTextResponse(stream, { headers: corsHeaders });
  
})