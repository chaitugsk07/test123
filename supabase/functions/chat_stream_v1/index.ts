// deno-lint-ignore-file
// supabase functions serve  --no-verify-jwt
// supabase functions deploy  --no-verify-jwt
// supabase functions deploy chat_stream_v1  --no-verify-jwt --project-ref icrispjgfllulboelvhw
// curl -i --location --request POST "http://localhost:54321/functions/v1/chat_stream_v1" --header "Content-Type: application/json" --data "{"query":"what is the bank", "article_id":"703", "token":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjEyMGFiZDNiLTI1NjctNDc4MS04Y2VhLWU5NjAzMWZlMTA3MCJ9LCJleHAiOjE3MTI4Mjg0NDB9.NRFnBsDA9yQKS-WZkrtEydyiXikhIW2F2AvyK8eARqY", ""language"":""en"" }"
// curl -i --location --request POST "http://localhost:54321/functions/v1/chat_stream_v1" --header "Content-Type: application/json" --data "{""query"":""RCB Kiy Hai"", ""article_id"":""685"", ""token"":""Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjEyMGFiZDNiLTI1NjctNDc4MS04Y2VhLWU5NjAzMWZlMTA3MCJ9LCJleHAiOjE3MTI4Mjg0NDB9.NRFnBsDA9yQKS-WZkrtEydyiXikhIW2F2AvyK8eARqY"", ""language"":""hi"" }"
// curl -L -X POST "https://icrispjgfllulboelvhw.supabase.co/functions/v1/chat_stream_v1" --header "Content-Type: application/json" --data "{""query"":""RCB Kiy Hai"", ""article_id"":""685"", ""token"":""Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjEyMGFiZDNiLTI1NjctNDc4MS04Y2VhLWU5NjAzMWZlMTA3MCJ9LCJleHAiOjE3MTI4Mjg0NDB9.NRFnBsDA9yQKS-WZkrtEydyiXikhIW2F2AvyK8eARqY"", ""language"":""hi"" }"
// curl -L -X POST "https://icrispjgfllulboelvhw.supabase.co/functions/v1/chat_stream_v1" --header "Content-Type: application/json" --data "{""query"":""what is the bank"", ""article_id"":""703"", ""token"":""Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjEyMGFiZDNiLTI1NjctNDc4MS04Y2VhLWU5NjAzMWZlMTA3MCJ9LCJleHAiOjE3MTI4Mjg0NDB9.NRFnBsDA9yQKS-WZkrtEydyiXikhIW2F2AvyK8eARqY"", ""language"":""en"" }"
// curl -L -X POST "https://icrispjgfllulboelvhw.supabase.co/functions/v1/chat_stream_v1" --header "Content-Type: application/json" --data "{"query":"what is the bank", "article_id":"703", "token":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjEyMGFiZDNiLTI1NjctNDc4MS04Y2VhLWU5NjAzMWZlMTA3MCJ9LCJleHAiOjE3MTI4Mjg0NDB9.NRFnBsDA9yQKS-WZkrtEydyiXikhIW2F2AvyK8eARqY", "language":"en" }"
// curl -i --location --request POST "https://icrispjgfllulboelvhw.supabase.co/functions/v1/chat_stream_v1" --header "Content-Type: application/json" --data "{""query"":""RCB Kiy Hai"", ""article_id"":""685"", ""token"":""Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsidXNlciJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtdXNlci1pZCI6IjEyMGFiZDNiLTI1NjctNDc4MS04Y2VhLWU5NjAzMWZlMTA3MCJ9LCJleHAiOjE3MTI4Mjg0NDB9.NRFnBsDA9yQKS-WZkrtEydyiXikhIW2F2AvyK8eARqY"", ""language"":""hi"" }"

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
    // deno-lint-ignore no-unused-vars
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
  const { query , article_id, token, language } = await req.json()
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
  let a1; 
  a1 = response1.data;
  const words = a1.split(' ');
  if (words.length > 750) {
      const trimmedWords = words.slice(0, 750);
      a1 = trimmedWords.join(' ');
  } 

  let message1;
  message1 = "na"

  if (language == "en"|| language == "de" ) {
    if (language == "en"){
     message1 = "You are a news chatbot. Your role is to answer questions with the help on the context provided in the system message. answer the question is even partially relevant to the system context then answer Generate an unbiased answer in one or two small paragraphs. ensure that maximum of 100 tokens: . This is the context " + a1 + ". ";
    }
    else if (language == "de"){
     message1 = "Sie sind ein Nachrichten-Chatbot. Ihre Aufgabe ist es, Fragen mit Hilfe des im Systemnachricht bereitgestellten Kontexts zu beantworten. Beantworten Sie die Frage, auch wenn sie nur teilweise relevant für den Systemkontext ist. Generieren Sie eine unvoreingenommene Antwort in ein oder zwei kleinen Absätzen. Stellen Sie sicher, dass maximal 100 Token: . Dies ist der Kontext " + a1 + ". ";
    }
    console.log(message1);
    
    const openai = new OpenAI({
      apiKey: ANYSCALE_API_KEY,
      baseURL: "https://api.endpoints.anyscale.com/v1",
    })
    console.log(query);

    const completionStream  = await openai.chat.completions.create({
      messages: [
        {role: "system", content: message1},
        {role: 'user', content:  query }],
      model: 'meta-llama/Llama-2-7b-chat-hf',
      stream: true,
      max_tokens: 120,
      temperature: 0.3,
      top_p: 0.9
    })
    
    const stream = OpenAIStream(completionStream);
    
    return new StreamingTextResponse(stream, { headers: corsHeaders });
  
  }
  else if (language == "hi" || language == "te" || language == "ta") {
    if(language == "hi" ){
     message1 = "आप एक समाचार चैटबॉट हैं। आपका कार्य है सिस्टम संदेश में प्रदान किए गए संदर्भ की सहायता से प्रश्नों का उत्तर देना। यदि प्रश्न सिस्टम संदर्भ के लिए भी आंशिक रूप से प्रासंगिक है तो भी उत्तर दें। एक या दो छोटे अनुच्छेदों में एक निष्पक्ष उत्तर उत्पन्न करें। सुनिश्चित करें कि अधिकतम 100 टोकन: . यह संदर्भ है " + a1 + ". ";
    }
    else if(language == "te" ){
     message1 = "మీరు ఒక వార్తా చాట్ బాట్ ఉన్నారు. మీ పాత్రలు ప్రశ్నలను సిస్టమ్ సందేశంలో అందించిన సందర్భంతో సహా జవాబు ఇస్తుంది. ప్రశ్న సిస్టమ్ సందర్భంలో కూడా భాగంగా సంబంధితమైనా సమాధానం ఇవ్వడం కూడా ఉండాలి. ఒక లేదా రెండు చిన్న అనుచ్ఛేదాలలో నిష్పక్ష సమాధానం తయారు చేయండి. అధికంగా 100 టోకెన్లు ఉండాలి: . ఇది సందర్ భం " + a1 + ". ";
    }
    else if(language == "ta" ){
     message1 = "நீங்கள் ஒரு செய்தி சாட் பாட் ஆகும். நீங்கள் சிஸ்டம் செய்தியில் வழங்கப்பட்ட சூழ்நிலையின் உதவியுடன் கேள்கைகளுக்கு பதில் கொடுக்க வேண்டும். சிஸ்டம் சூழ்நிலைக்கு உட்பட்ட கேள்கை சம்பந்தப்பட்டதாக உத்தரம் உருவாக்குங்கள். ஒரு அல்லது இரண்டு சிறிய பத்திரங்களில் ஒரு பகுப்பாய்வு உருவாக்குங்கள். அதிகபட்ச 100 டோக்கன்கள் உள்ளது: . இது சூழ்நிலை " + a1 + ". ";
    }
    const ANYSCALE_API_KEY = "";
    const openai = new OpenAI({
      apiKey: ANYSCALE_API_KEY,
    })

    const completionStream  = await openai.chat.completions.create({
      messages: [
        {role: "system", content: message1},
        {role: 'user', content:  query }],
      model: 'gpt-3.5-turbo',
      stream: true,
      temperature: 0.3,
      top_p: 0.9
    })
  
    const stream = OpenAIStream(completionStream);
    
    return new StreamingTextResponse(stream, { headers: corsHeaders });
  }
  else {
    return new Response("Error c", { status: 500 });
  }
})