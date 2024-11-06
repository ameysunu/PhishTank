using Google.Apis.Auth.OAuth2;
using Google.Cloud.Firestore;
using Google.Cloud.Firestore.V1;
using Grpc.Auth;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Numerics;
using System.Text;

namespace PhishTankGCPRun
{
    public class Firebase
    {

        private static async Task<FirestoreDb> InitializeFirestoreDb(string serviceAccountKey)
        {
            GoogleCredential credential;
            using (var stream = new MemoryStream(Encoding.UTF8.GetBytes(serviceAccountKey)))
            {
                credential = GoogleCredential.FromStream(stream);
            }

            FirestoreClientBuilder firestoreClientBuilder = new FirestoreClientBuilder
            {
                ChannelCredentials = credential.ToChannelCredentials()
            };

            FirestoreClient firestoreClient = await firestoreClientBuilder.BuildAsync();
            FirestoreDb firestoreDb = FirestoreDb.Create("ios-project-11c34", firestoreClient);
            return firestoreDb;
        }

        private static async Task<bool> AddDocumentToFirestore(FirestoreDb firestoreDb, string collectionName, string documentId, object data)
        {
            DocumentReference docRef = firestoreDb.Collection(collectionName).Document(documentId);
            await docRef.SetAsync(data, SetOptions.MergeAll);
            return true;
        }

        public async Task<String> WriteToFirestore(String collectionName, PostParams data, String userId)
        {
            var fireStoreKeyBase64 = Environment.GetEnvironmentVariable("FIREBASE_SECRET_KEY");
            var serviceAccountKey = Encoding.UTF8.GetString(Convert.FromBase64String(fireStoreKeyBase64));

            Console.WriteLine("Retrieved Service Account Key");

            try
            {
                FirestoreDb firestoreDb = await InitializeFirestoreDb(serviceAccountKey);

                await AddDocumentToFirestore(firestoreDb, collectionName, userId, data.data);

                return "Succesfully added!";
            }
            catch (Exception ex)
            {
                return $"Exception: {ex.Message}";
            }
        }


    }

    public class PostParams
    {
        public bool isBreach { get; set; }
        public PayloadData data { get; set; }
        public string userId { get; set; }
    }

    [FirestoreData]
    public class PayloadData
    {
        [FirestoreProperty]
        public string textValue { get; set; }
        [FirestoreProperty]
        public string geminiResult { get; set; }
        [FirestoreProperty]
        public bool type { get; set; }
    }

    public class FirebaseController : ControllerBase
    {
        [HttpPost("sendrequest")]
        public async Task<ActionResult<string>> Post([FromBody] PostParams postParams)
        {

            if(postParams == null)
            {
                return BadRequest("You almost got, but the payload is empty");
            }

            Firebase firebaseInst = new Firebase();

            if (postParams.isBreach)
            {
                Console.WriteLine("Type is of breach");
                var collectionName = "phishtank-breach-data";

                var val = await firebaseInst.WriteToFirestore(collectionName, postParams, postParams.userId);

                if (val.Contains("Exception"))
                {
                    return BadRequest(val);
                }

                return val;

            } else
            {
                Console.WriteLine("Type is of phishing");
                var collectionName = "phishtank-phish-data";

                var val = await firebaseInst.WriteToFirestore(collectionName, postParams, postParams.userId);

                if (val.Contains("Exception"))
                {
                    return BadRequest(val);
                }

                return val;

                return Ok("Done");
            }

        }

        [HttpGet("sendrequest")]
        public ActionResult<string> Get()
        {
            return BadRequest("Ohh ohh! This endpoint only accepts POST requests :)");
        }

    }


    public class MainController : ControllerBase  
    {
        [Route("/")]
        public ActionResult Get()
        {
            return Ok("Welcome to PhishTank GCP Cloud Run. You're in the right place, but not the right endpoint. \n\nProudly built by Amey with bugs :)");
        }
    }
}