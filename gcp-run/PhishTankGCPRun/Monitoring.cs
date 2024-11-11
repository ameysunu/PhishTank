using DotnetGeminiSDK.Client;
using DotnetGeminiSDK.Client.Interfaces;
using DotnetGeminiSDK.Config;
using Google.Cloud.Firestore;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System.Text;

namespace PhishTankGCPRun
{
    public class Monitoring
    {
        public async Task<string> StartMonitoringEngine()
        {
            var fireStoreKeyBase64 = Environment.GetEnvironmentVariable("FIREBASE_SECRET_KEY");
            var serviceAccountKey = Encoding.UTF8.GetString(Convert.FromBase64String(fireStoreKeyBase64));

            Firebase firebaseCtrl = new Firebase();
            FirestoreDb firestoreDb = await firebaseCtrl.InitializeFirestoreDb(serviceAccountKey);
            var phishingStringPrompt = "";

            var geminiApiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY");
            var geminiConfig = new GoogleGeminiConfig
            {
                ApiKey = geminiApiKey
            };

            Console.WriteLine($"GEMINI API KEY = {geminiApiKey}");

            var geminiClient = new GeminiClient(geminiConfig);
            GeminiProcessor _gemProc = new GeminiProcessor(geminiClient);

            var phishingData = await GetGroupedDocumentsAsync(firestoreDb, "phishtank-phish-data");
            var breachData = await GetGroupedDocumentsAsync(firestoreDb, "phishtank-breach-data");

            if (phishingData != null)
            {
                foreach (var doc in phishingData)
                {
                    Console.WriteLine($"Document Id: {doc.Key}");

                    foreach(var docVal in doc.Value)
                    {
                        Console.WriteLine($"textVal: {docVal.textValue}");
                        phishingStringPrompt += docVal.textValue + "\n";
                    }

                    var prompt = $"Here is some data based on user's phishing data. Pretend that you are a monitoring engine and provide recommendations to the user based on this data. This is the phishing email, the user checked {phishingStringPrompt}";
                    var geminiResult = await _gemProc.GeminiRun(prompt);

                    var mtrData = new MonitoringData
                    {
                        id = Guid.NewGuid().ToString(),
                        textValue = geminiResult
                    };

                    await AddDocumentToFirestore(firestoreDb, "phishtank-monitoring-data", doc.Key, mtrData);
                }
            }


            //if (breachData != null)
            //{
            //    foreach (var breachDoc in breachData)
            //    {
            //        Console.WriteLine($"Document Id: {breachDoc.Key}");

            //        foreach (var docVal in breachDoc.Value)
            //        {
            //            breachStringPrompt += docVal.geminiResult + "for the email" + docVal.textValue + "\n";
            //            Console.WriteLine($"textVal: {docVal.textValue}");
            //        }
            //    }
            //}


            return "Success";


        }

        private static async Task<bool> AddDocumentToFirestore(FirestoreDb firestoreDb, string collectionName, string documentId, object data)
        {
            DocumentReference docRef = firestoreDb.Collection(collectionName).Document(documentId);
            await docRef.SetAsync(data, SetOptions.MergeAll);
            return true;
        }

        public static async Task<Dictionary<string, List<PayloadData>>> GetGroupedDocumentsAsync(FirestoreDb db, string collectionName)
        {
            try
            {
                CollectionReference collection = db.Collection(collectionName);
                QuerySnapshot snapshot = await collection.GetSnapshotAsync();

                var groupedDocs = new Dictionary<string, List<PayloadData>>();

                foreach (DocumentSnapshot document in snapshot.Documents)
                {
                    if (!document.Exists)
                    {
                        Console.WriteLine($"Document not found: {document.Id}");
                        continue;
                    }

                    string documentId = document.Id;
                    string googleId = documentId.Split('-')[0];

                    PayloadData payloadData = new PayloadData
                    {
                        id = documentId,
                        textValue = document.ContainsField("textValue") ? document.GetValue<string>("textValue") : null,
                        geminiResult = document.ContainsField("geminiResult") ? document.GetValue<string>("geminiResult") : null,
                        type = document.ContainsField("type") ? document.GetValue<bool>("type") : false
                    };

                    if (!groupedDocs.ContainsKey(googleId))
                    {
                        groupedDocs[googleId] = new List<PayloadData>();
                    }
                    groupedDocs[googleId].Add(payloadData);
                }

                return groupedDocs;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching documents: {ex.Message}");
                return new Dictionary<string, List<PayloadData>>();
            }
        }

    }

    public class MonitoringController : ControllerBase
    {
        [HttpGet("monitoring")]
        public async Task<ActionResult<string>> Get()
        {
            try
            {
                Monitoring mtr = new Monitoring();
                return await mtr.StartMonitoringEngine();

            } catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }

    [FirestoreData]
    public class MonitoringData
    {
        [FirestoreProperty]
        public string id { get; set; }
        [FirestoreProperty]
        public string textValue { get; set; }
    }

}
