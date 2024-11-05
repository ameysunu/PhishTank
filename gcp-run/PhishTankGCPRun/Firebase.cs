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

        private static async Task<bool> AddDocumentToFirestore(FirestoreDb firestoreDb, string collectionName, string documentId, Dictionary<string, object> data)
        {
            DocumentReference docRef = firestoreDb.Collection(collectionName).Document(documentId);
            await docRef.SetAsync(data, SetOptions.MergeAll);
            return true;
        }

        public async Task<String> WriteToFirestore() 
        {
            var fireStoreKeyBase64 = Environment.GetEnvironmentVariable("FIREBASE_SECRET_KEY");
            var serviceAccountKey = Encoding.UTF8.GetString(Convert.FromBase64String(fireStoreKeyBase64));
            FirestoreDb firestoreDb = await InitializeFirestoreDb(serviceAccountKey);

            Dictionary<string, object> testData = new Dictionary<string, object>();
            testData.Add("Test", "Test");

            await AddDocumentToFirestore(firestoreDb, "geminidata", "testId", testData);

            return "Succesfully added!";
        } 


    }


    public class FirebaseController : ControllerBase
    {
        [Route("firebaseTest")]
        public ActionResult<string> Get()
        {
            Firebase firebaseInst = new Firebase();
            var val = firebaseInst.WriteToFirestore();
            return $"{val}";
        }
    }
}
