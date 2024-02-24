import { createClient } from 'npm:@supabase/supabase-js@2'
import {JWT} from 'npm:google-auth-library@9'

interface FCMRequest {
  id: number
  name: string
  title: string
  text: string
  image: string
}
console.log("Hello from Functions!")

const supabase = createClient(
  "https://icrispjgfllulboelvhw.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImljcmlzcGpnZmxsdWxib2Vsdmh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU5MjEwNTIsImV4cCI6MjAxMTQ5NzA1Mn0._OwgY5xcVKtFQ-QMrbUnljBLiXAKpbQWv9dwxRkqdQo",
) 
Deno.serve(async () => {
  const response = await supabase
    .schema("synopse_realtime")
    .from("t_user_notification_fcm")
    .select()
    let data;
    let fcmToken;
    if (response.error) {
      console.error(response.error);
    } else {
      data = response.data;
      fcmToken = data[0].fcmtoken;
      console.log(fcmToken);
    }
    
    const {default: serviceAccount} = await import('./service_account.json', {with: {type: "json"}})

    const accessToken = await getAccessToken({ clientEmail: serviceAccount.client_email, privateKey: serviceAccount.private_key  })
    const res = await fetch(`https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: fcmToken,
          notification: {
            title: "Hello from Supabase!",
            body: "Thanks for using Supabase",
          },
        },
      }),
      }
    )
    const resdata = await res.json();
    if (res.status < 200 || 299 < res.status) {
      throw resdata;
    }
  return new Response(
    JSON.stringify(resdata),
    { headers: { "Content-Type": "application/json" } },
  )
})

const getAccessToken =  ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string
  privateKey: string
}) : Promise<string> => {
  return new Promise((resolve, reject) => {
    const JWTClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    })
    JWTClient.authorize((err, tokens) => {
      if (err) {
         
        reject(err)
        return
      } 
      resolve(tokens!.access_token!)
    })
  }
)}
  
/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/fcm_v1' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'
    
    
    deno run --allow-net index.ts
    supabase functions deploy fcm_v1
    supabase functions serve hello-fcm_v1 --no-verify-jwt

*/
